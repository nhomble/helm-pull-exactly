#!/usr/bin/env bash

TEMP_DIR=$(mktemp -d)
ARGS=()
MY_ARGS=("--untar" "--untardir" "$TEMP_DIR")
VERSION=""

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

[[ -z "$VERSION" ]] && exit 1

PULL_ARGS=$(printf " %s" "${ARGS[@]}")
PLUGIN_ARGS=$(printf " %s" "${MY_ARGS[@]}")

helm pull $PLUGIN_ARGS

CHART_NAME=$(ls $TEMP_DIR)
CHART_VERSION=$(cat ${TEMP_DIR}/${CHART_NAME}/Chart.yaml | grep ^version | sed 's/version: //g')

[[ "$CHART_VERSION" != "$VERSION" ]] && exit 1

helm pull $PULL_ARGS
