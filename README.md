# helm-pull-exactly

get the exact chart you wanted

## Usage

Instead of `helm pull $ARGS` you can do `helm pull-exactly $ARGS`. The helm plugin will verify that the downloaded chart's version is equal to the passed in `--version [VERSION]`.

### When wouldn't this be true

`helm` respects SemVer and it will find matching versions when a simple lookup fails. For example `bitnami/kubeapps--version 8.1.11+do.not.exist` would resolve to `8.1.11`.

## Install

```sh
helm plugin install https://github.com/nhomble/helm-pull-exactly
```
