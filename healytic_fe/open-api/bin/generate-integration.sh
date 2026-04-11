#!/usr/bin/env bash
OPENAPI_GENERATOR_VERSION=v7.17.0
BASE_DIR=/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/

# usage: ./bin/generate-open-api.sh

function generate_dart {
  local OUTPUT_DIR=$1
  local SWAGGER_FILE=$2
  local PUB_NAME=${3:-openapi}  # Default to 'openapi' if not provided
  rm -rf $OUTPUT_DIR
  mkdir -p $OUTPUT_DIR
  
  # Download templates if needed
  cd $BASE_DIR/open-api/templates/mobile/serialization/native
  [ ! -f native_class.mustache ] && wget -O native_class.mustache https://raw.githubusercontent.com/OpenAPITools/openapi-generator/$OPENAPI_GENERATOR_VERSION/modules/openapi-generator/src/main/resources/dart2/serialization/native/native_class.mustache

  cd ../../
  [ ! -f api.mustache ] && wget -O api.mustache https://raw.githubusercontent.com/OpenAPITools/openapi-generator/$OPENAPI_GENERATOR_VERSION/modules/openapi-generator/src/main/resources/dart2/api.mustache

  cd ../../
  
  # Generate Client with custom package name
  # JAVA_TOOL_OPTIONS is read directly by the JVM (unlike JAVA_OPTS which needs launcher support)
  export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS} -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"
  npx --yes @openapitools/openapi-generator-cli generate -g dart -i $SWAGGER_FILE -o $OUTPUT_DIR -t $BASE_DIR/open-api/templates/mobile --additional-properties pubName=$PUB_NAME --type-mappings Date=DateTime 2>&1 | grep -v '^\[main\] INFO'
  
  # Post generate patches
  # Don't include analysis_options.yaml for the generated openapi files
  # so that language servers can properly exclude the mobile/openapi directory
  rm $OUTPUT_DIR/analysis_options.yaml
}

function user_app {
  echo "Generating for user_app..."

  # Merge ai_apis.json into user_apis.json before generation
  echo "Merging ai_apis.json → user_apis.json..."
  node $BASE_DIR/open-api/bin/merge-apis.js ai_apis.json user_apis.json

  generate_dart $BASE_DIR/user_app/openapi $BASE_DIR/open-api/user_apis.json user_openapi
}

function admin_panel {
  echo "Generating for admin_panel..."
  generate_dart $BASE_DIR/admin_panel/openapi $BASE_DIR/open-api/admin_apis.json admin_openapi
}

function ws_client {
  echo "Generating WebSocket client for user_app..."
  node $BASE_DIR/open-api/bin/generate-ws-client.js \
    --spec $BASE_DIR/open-api/ws-contract.json \
    --output $BASE_DIR/user_app/lib/core/services/ws \
    --namespaces user-chat,chat-notifications
}

function ws_admin {
  echo "Generating WebSocket client for admin_panel..."
  node $BASE_DIR/open-api/bin/generate-ws-client.js \
    --spec $BASE_DIR/open-api/ws-contract.json \
    --output $BASE_DIR/admin_panel/lib/core/services/ws \
    --namespaces partner-chat,chat-notifications
}

# requires server to be built
# npm run sync:open-api --prefix=../server

if [[ $1 == 'user' ]]; then
  user_app
elif [[ $1 == 'admin' ]]; then
  admin_panel
elif [[ $1 == 'ws' ]]; then
  ws_client
  ws_admin
elif [[ $1 == 'all' ]]; then
  user_app
  admin_panel
  ws_client
  ws_admin
else
  user_app
  admin_panel
  ws_client
  ws_admin
fi
