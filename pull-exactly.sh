#!/usr/bin/env bash

TEMP_DIR=$(mktemp -d)
ARGS=("$HELM_BIN" "pull")
MY_ARGS=("$HELM_BIN" "pull" "--untar" "--untardir" "$TEMP_DIR")
VERSION=""

function debug {
  [[ "$HELM_DEBUG" == "true" ]] && echo "helm pull-exactly: $@"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --version)
      VERSION="$2"
      ARGS+=("$1")
      MY_ARGS+=("$1")
      shift
      ARGS+=("$1")
      MY_ARGS+=("$1")
      shift
      ;;
    -h|--help)
      echo "Mimics the helm pull arguments but asserts the version is exactly as specified"
      exit 0
      ;;
    -d|--destination|--untar|--untardir|--prov)
      # ignore these flags
      ARGS+=("$1")
      shift
      ;;
    *)
      MY_ARGS+=("$1")
      ARGS+=("$1")
      shift
      ;;
  esac
done

[[ -z "$VERSION" ]] && debug "No version specified" && exit 1

eval "${MY_ARGS[@]}"

CHART_NAME=$(ls $TEMP_DIR)

[[ -z "$CHART_NAME" ]] && debug "Failed to pull down chart with command: ${MY_ARGS[@]}" && exit 1

CHART_VERSION=$(cat ${TEMP_DIR}/${CHART_NAME}/Chart.yaml | grep ^version | sed 's/version: //g')

[[ "$CHART_VERSION" != "$VERSION" ]] && debug "Versions do not match: given version=${VERSION} found version=${CHART_VERSION}" && exit 1

eval "${ARGS[@]}"
