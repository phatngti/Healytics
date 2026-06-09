# Healytics Landing Page

Static landing page served by a small Node.js HTTP server for Heroku.

## Local Run

```bash
npm start
```

The server uses `PORT` when provided by Heroku and defaults to `8080` locally.
`/` redirects to `/demo` to preserve the previous public path.

## Deploy To Heroku

From this repository:

```bash
./dockers/landing-page/deploy-heroku.sh
```

The deploy script packages the current `landing-page` working tree and pushes it to:

```text
https://git.heroku.com/healytics-landing-page.git
```

`HEROKU_FORCE_PUSH` defaults to `true` because the Heroku git remote is a deployment target, not the source repository.
Set `HEROKU_DRY_RUN=true` to verify the package step without pushing.
