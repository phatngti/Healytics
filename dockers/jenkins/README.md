# Healytics Jenkins Controller

This setup keeps the Jenkins controller on the VPS for stable GitHub webhooks, but keeps DockerHub and deploy credentials on the trusted local build machine.

## Secure Flow

```text
GitHub push/merge
  -> Jenkins controller on VPS receives webhook
  -> controller schedules the pipeline on local-docker-builder
  -> local inbound agent checks out code, tests, builds, and pushes Docker images
  -> local inbound agent SSHs to the VPS deploy user
  -> VPS pulls the public DockerHub image and runs deploy-backend.sh
```

The VPS controller must not store these values:

```dotenv
DOCKERHUB_TOKEN=
VPS_SSH_PRIVATE_KEY=
JENKINS_AGENT_SECRET=
```

`JENKINS_URL`, `GITHUB_REPO_OWNER`, `GITHUB_REPO_NAME`, and `VPS_SSH_USER` are not secrets.

## Start Controller On VPS

Only start the Jenkins controller on the VPS. Do not start the `ci-agent` profile on the VPS.

```bash
cd /opt/healytics/dockers
docker compose --env-file .env --profile ci up -d jenkins
```

Required VPS `.env` values:

```dotenv
JENKINS_URL=https://ci.example.com
GITHUB_REPO_OWNER=your-github-org-or-user
GITHUB_REPO_NAME=Healytics
JENKINS_ADMIN_USER=admin
JENKINS_ADMIN_PASSWORD=change-me
JENKINS_BIND_ADDR=127.0.0.1
JENKINS_PORT=8081
```

Expose the controller through Cloudflare Tunnel or another HTTPS reverse proxy. GitHub must reach:

```text
https://ci.example.com/github-webhook/
```

Protect the Jenkins UI with Cloudflare Access or VPN. If Access is enabled, allow GitHub webhook delivery to `/github-webhook/`.

## GitHub Access

For a public repository, the controller does not need GitHub credentials.

For a private repository, the controller still needs read-only GitHub access so the multibranch job can discover branches and load `backend/Jenkinsfile`. Use the least-privileged credential possible, such as a read-only deploy key or a fine-scoped token. This is separate from DockerHub and VPS deploy credentials.

## Local Docker Agent Requirements

Install these on the trusted local build machine:

- Docker or Docker Desktop
- Docker Compose V2
- SSH client for one-time key setup

The Jenkins node label must be:

```text
local-docker-builder
```

The node is created by `jenkins/casc.yml`; copy the inbound agent secret from Jenkins after the controller starts:

```text
Manage Jenkins -> Nodes -> local-docker-builder -> Status
```

The Dockerized local agent image includes Java 17, Git, Node 22, Corepack/Yarn, SSH client, and Docker CLI. It uses the host Docker daemon through `/var/run/docker.sock`.

## Local DockerHub Login

Create a dedicated Docker config for the Jenkins agent container:

```bash
mkdir -p "$HOME/.healytics-jenkins-docker"
DOCKER_CONFIG="$HOME/.healytics-jenkins-docker" docker login

tmpdir="$(mktemp -d)"
printf 'FROM scratch\n' > "$tmpdir/Dockerfile"
DOCKER_CONFIG="$HOME/.healytics-jenkins-docker" docker build -t giahung2111/healytics_backend:test-login-check "$tmpdir"
DOCKER_CONFIG="$HOME/.healytics-jenkins-docker" docker push giahung2111/healytics_backend:test-login-check
docker image rm giahung2111/healytics_backend:test-login-check
rm -rf "$tmpdir"
```

The Compose agent mounts `$HOME/.healytics-jenkins-docker` as `/root/.docker:ro`. No DockerHub token is stored on the VPS controller.

## Local SSH Deploy Key

Create a dedicated SSH directory for the Jenkins agent container:

```bash
mkdir -p "$HOME/.healytics-jenkins-ssh"
chmod 700 "$HOME/.healytics-jenkins-ssh"

ssh-keygen -t ed25519 -f "$HOME/.healytics-jenkins-ssh/healytics_deploy"
ssh-copy-id -i "$HOME/.healytics-jenkins-ssh/healytics_deploy.pub" deploy@your-vps-host
ssh-keyscan -H your-vps-host >> "$HOME/.healytics-jenkins-ssh/known_hosts"
```

Create `$HOME/.healytics-jenkins-ssh/config`:

```sshconfig
Host healytics-vps
  HostName your-vps-host
  User deploy
  IdentityFile /root/.ssh/healytics_deploy
  IdentitiesOnly yes
```

```bash
chmod 600 "$HOME/.healytics-jenkins-ssh/config"
```

The Compose agent mounts `$HOME/.healytics-jenkins-ssh` as `/root/.ssh:ro`.

## Start Dockerized Local Inbound Agent

Create `jenkins-agent.env` in the `dockers/` directory on the local machine:

```dotenv
JENKINS_AGENT_URL=https://ci.example.com
JENKINS_AGENT_SECRET=replace-with-agent-secret-from-jenkins
JENKINS_AGENT_NAME=local-docker-builder

HEALYTICS_VPS_HOST=healytics-vps
HEALYTICS_VPS_SSH_USER=deploy
```

`jenkins-agent.env` is git-ignored. Keep it only on the local machine.

Start the local inbound agent through Docker Compose:

```bash
cd /path/to/Healytics/dockers
docker compose \
  --env-file .env.example \
  --env-file jenkins-agent.env \
  --profile ci-agent \
  up -d --build jenkins-agent
```

Because the agent is inbound over WebSocket, the local machine does not need a static IP or inbound firewall rule.

Check local agent logs:

```bash
docker compose \
  --env-file .env.example \
  --env-file jenkins-agent.env \
  --profile ci-agent \
  logs -f jenkins-agent
```

## Jenkinsfile Activation

The active pipeline is:

```text
backend/Jenkinsfile
```

It runs all stages on `local-docker-builder`:

- checkout from GitHub
- verify branch is `main` or `master`
- install dependencies
- run tests
- build runtime and migration Docker images
- push immutable commit-tagged images to DockerHub
- SSH from the local machine to the VPS
- run `/opt/healytics/dockers/scripts/deploy-backend.sh <tag>`

Commit and push the Jenkinsfile to `main` or `master`. Then in Jenkins:

```text
Healytics Backend -> Scan Multibranch Pipeline Now
```

After the first branch job appears, push another commit or merge into `main`/`master` to verify webhook-triggered builds.

## VPS Deploy Files

The VPS must have these files:

```text
/opt/healytics/dockers/.env
/opt/healytics/dockers/backend.env
/opt/healytics/dockers/deploy.env
/opt/healytics/dockers/scripts/deploy-backend.sh
```

`backend.env` contains runtime application secrets and stays only on the VPS. Jenkins does not need to read it.

The deploy script writes the selected immutable image tag into `deploy.env`, runs migrations, starts the backend, reapplies Kong config, checks `/backend/health`, and rolls back to the previous tag if verification fails.

## Security Notes

- Do not commit `.env`, `backend.env`, `deploy.env`, private keys, or Docker config files.
- If `.env` was ever committed, remove it from tracking and rotate any real secrets that appeared in git history.
- Do not build untrusted pull requests on `local-docker-builder`; it has Docker access and deploy access.
- Use a restricted `deploy` user on the VPS with permission only for `/opt/healytics/dockers` deployment commands.
- DockerHub images are public in this flow. Do not bake application secrets into Docker images.

## Verification

Check the local agent:

```bash
docker compose \
  --env-file .env.example \
  --env-file jenkins-agent.env \
  --profile ci-agent \
  run --rm --entrypoint docker jenkins-agent info

docker compose \
  --env-file .env.example \
  --env-file jenkins-agent.env \
  --profile ci-agent \
  run --rm --entrypoint ssh jenkins-agent -o BatchMode=yes healytics-vps 'echo ok'
```

Check the VPS after deploy:

```bash
cd /opt/healytics/dockers
docker compose --env-file .env --env-file deploy.env --profile prod ps backend
curl -fsS http://127.0.0.1:8000/backend/health
```
