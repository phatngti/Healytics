#!/usr/bin/env bash
OPENAPI_GENERATOR_VERSION=v7.17.0
BASE_DIR=/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/
SWAGGER_SPEC_FILE=$BASE_DIR/open-api/swagger.json

# usage: ./bin/generate-open-api.sh

function dart {
  rm -rf $BASE_DIR/user_app/openapi
  mkdir -p $BASE_DIR/user_app/openapi
  cd $BASE_DIR/open-api/templates/mobile/serialization/native
  [ ! -f native_class.mustache ] && wget -O native_class.mustache https://raw.githubusercontent.com/OpenAPITools/openapi-generator/$OPENAPI_GENERATOR_VERSION/modules/openapi-generator/src/main/resources/dart2/serialization/native/native_class.mustache

  cd ../../
  [ ! -f api.mustache ] && wget -O api.mustache https://raw.githubusercontent.com/OpenAPITools/openapi-generator/$OPENAPI_GENERATOR_VERSION/modules/openapi-generator/src/main/resources/dart2/api.mustache

  cd ../../
  npx --yes @openapitools/openapi-generator-cli generate -g dart -i $SWAGGER_SPEC_FILE -o $BASE_DIR/user_app/openapi -t $BASE_DIR/open-api/templates/mobile
  # Post generate patches
  # Don't include analysis_options.yaml for the generated openapi files
  # so that language servers can properly exclude the mobile/openapi directory
  rm $BASE_DIR/user_app/openapi/analysis_options.yaml
}


# requires server to be built
# npm run sync:open-api --prefix=../server

# if [[ $1 == 'dart' ]]; then
#   dart
# elif [[ $1 == 'typescript' ]]; then
#   typescript
# fi

dart
