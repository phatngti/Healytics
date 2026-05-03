
            set -eu
            docker build --target runtime -t "${BACKEND_IMAGE}:${IMAGE_TAG}" .
            docker build --target migrate -t "${BACKEND_MIGRATION_IMAGE}:${IMAGE_TAG}" .
          