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

function employee_app {
  echo "Generating for employee_app..."

  # Keep employee_app in sync with the same backend spec used by user_app.
  echo "Merging ai_apis.json → user_apis.json..."
  node $BASE_DIR/open-api/bin/merge-apis.js ai_apis.json user_apis.json

  generate_dart $BASE_DIR/employee_app/openapi $BASE_DIR/open-api/user_apis.json employee_openapi
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

function test_backdoor {
  echo "Generating Test Backdoor API for patrol_test..."

  local OUTPUT_DIR=$BASE_DIR/user_app/patrol_test/openapi
  local SWAGGER_FILE=$BASE_DIR/open-api/user_apis_test.json
  local TEMPLATE_DIR=$BASE_DIR/open-api/templates/test
  local PUB_NAME=test_backdoor_api

  rm -rf $OUTPUT_DIR
  mkdir -p $OUTPUT_DIR

  export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS} -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"
  npx --yes @openapitools/openapi-generator-cli generate \
    -g dart \
    -i $SWAGGER_FILE \
    -o $OUTPUT_DIR \
    -t $TEMPLATE_DIR \
    --additional-properties pubName=$PUB_NAME \
    --type-mappings Date=DateTime \
    2>&1 | grep -v '^\[main\] INFO'

  # ---- Post-generation cleanup ----
  # Remove package scaffolding (we're not a separate package)
  rm -f $OUTPUT_DIR/pubspec.yaml
  rm -f $OUTPUT_DIR/analysis_options.yaml
  rm -f $OUTPUT_DIR/.travis.yml
  rm -f $OUTPUT_DIR/git_push.sh
  rm -f $OUTPUT_DIR/.gitignore
  rm -rf $OUTPUT_DIR/.openapi-generator
  rm -f $OUTPUT_DIR/.openapi-generator-ignore
  rm -rf $OUTPUT_DIR/doc
  rm -rf $OUTPUT_DIR/test
  rm -f $OUTPUT_DIR/README.md

  # Flatten lib/ up one level
  if [ -d "$OUTPUT_DIR/lib" ]; then
    mv $OUTPUT_DIR/lib/* $OUTPUT_DIR/
    rmdir $OUTPUT_DIR/lib
  fi

  # Patch library name: openapi.api → test_backdoor_api
  sed -i '' 's/library openapi\.api;/library test_backdoor_api;/' \
    $OUTPUT_DIR/api.dart

  # Patch all part-of directives
  find $OUTPUT_DIR -name '*.dart' -exec \
    sed -i '' 's/part of openapi\.api;/part of test_backdoor_api;/' {} +

  # Rename barrel file to match library name
  mv $OUTPUT_DIR/api.dart $OUTPUT_DIR/test_backdoor_api.dart

  # Fix array-enum generator bug: inline enums for array-of-enum fields
  # get their value typed as List<String> instead of String
  find $OUTPUT_DIR -name '*.dart' -exec \
    sed -i '' \
      -e 's/final List<String> value;/final String value;/' \
      -e 's/String toString() => value\.toString();/String toString() => value;/' \
      -e 's/List<String> toJson() => value;/String toJson() => value;/' \
      -e 's/List<String> encode(/String encode(/' {} +

  echo "✅ Test Backdoor API generated at patrol_test/openapi/"
}

# requires server to be built
# npm run sync:open-api --prefix=../server

if [[ $1 == 'user' ]]; then
  user_app
elif [[ $1 == 'admin' ]]; then
  admin_panel
elif [[ $1 == 'employee' ]]; then
  employee_app
elif [[ $1 == 'ws' ]]; then
  ws_client
  ws_admin
elif [[ $1 == 'test' ]]; then
  test_backdoor
elif [[ $1 == 'all' ]]; then
  user_app
  admin_panel
  employee_app
  ws_client
  ws_admin
  test_backdoor
else
  user_app
  admin_panel
  employee_app
  ws_client
  ws_admin
  test_backdoor
fi
