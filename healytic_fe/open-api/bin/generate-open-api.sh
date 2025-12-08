#!/usr/bin/env bash
OPENAPI_GENERATOR_VERSION=v7.17.0
BASE_DIR=/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/

# usage: ./bin/generate-open-api.sh

function generate_dart {
  local OUTPUT_DIR=$1
  local SWAGGER_FILE=$2
  rm -rf $OUTPUT_DIR
  mkdir -p $OUTPUT_DIR
  
  # Download templates if needed
  cd $BASE_DIR/open-api/templates/mobile/serialization/native
  [ ! -f native_class.mustache ] && wget -O native_class.mustache https://raw.githubusercontent.com/OpenAPITools/openapi-generator/$OPENAPI_GENERATOR_VERSION/modules/openapi-generator/src/main/resources/dart2/serialization/native/native_class.mustache

  cd ../../
  [ ! -f api.mustache ] && wget -O api.mustache https://raw.githubusercontent.com/OpenAPITools/openapi-generator/$OPENAPI_GENERATOR_VERSION/modules/openapi-generator/src/main/resources/dart2/api.mustache

  cd ../../
  
  # Generate Client
  npx --yes @openapitools/openapi-generator-cli generate -g dart -i $SWAGGER_FILE -o $OUTPUT_DIR -t $BASE_DIR/open-api/templates/mobile
  
  # Post generate patches
  # Don't include analysis_options.yaml for the generated openapi files
  # so that language servers can properly exclude the mobile/openapi directory
  rm $OUTPUT_DIR/analysis_options.yaml
}

function user_app {
  echo "Generating for user_app..."
  generate_dart $BASE_DIR/user_app/openapi $BASE_DIR/open-api/user_apis.json
}

function admin_panel {
  echo "Generating for admin_panel..."
  generate_dart $BASE_DIR/admin_panel/openapi $BASE_DIR/open-api/admin_apis.json
}

# requires server to be built
# npm run sync:open-api --prefix=../server

if [[ $1 == 'user_app' ]]; then
  user_app
elif [[ $1 == 'admin_panel' ]]; then
  admin_panel
else
  user_app
  admin_panel
fi
