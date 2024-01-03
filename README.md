# rsync deployments to systems that require both an ssh password

This GitHub Action deploys files in `GITHUB_WORKSPACE` to a remote folder via
rsync over ssh. 

Use this action in a CD workflow which leaves deployable code in
`GITHUB_WORKSPACE`.

The base-image (drinternet/rsync) of this action is very small and is based on
Alpine 3.15.0 (no cache) which results in fast deployments.

`Rsyncpass` is a Dockerfile that builds in the extra pacakges needed so that
when the action is run it doesn't need to install those, making it an even
faster deploy!

---

## Inputs

- `switches`* - The first is for any initial/required rsync flags, eg: `-avzr
  --delete`
- `rsh` - Remote shell commands
- `path` - The source path. Defaults to GITHUB_WORKSPACE
- `remote_path`* - The deployment target path
- `remote_host`* - The remote host
- `remote_port` - The remote port. Defaults to 22
- `remote_user`* - The remote user
- `remote_password`* - The remote password 

``* = Required``

## Required secret(s)

This action *should* use a secret variable for the ssh password (but doesn't
have to). The secret variable should be set in the Github secrets section of
your org/repo and then referenced as the  `remote_password` input.

> Always use secrets when dealing with sensitive inputs!

For simplicity, we are using `DEPLOY_*` as the secret variables throughout the
examples.

## Example usage

Simple:

```
name: DEPLOY
on:
  push:
    branches:
    - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: rsync deployments
      uses: burnett01/rsync-deployments@5.2
      with:
        switches: -avzr --delete
        path: src/
        remote_path: /var/www/html/
        remote_host: example.com
        remote_user: debian
        remote_password: correcthorsebatterystaple
```

Advanced:

```
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: rsync deployments
      uses: burnett01/rsync-deployments@5.2
      with:
        switches: -avzr --delete --exclude="" --include="" --filter=""
        path: src/
        remote_path: /var/www/html/
        remote_host: example.com
        remote_port: 5555
        remote_user: debian
        remote_password: ${{ secrets.DEPLOY_PASSWORD }}
```

For better **security**, I suggest you create additional secrets for
remote_host, remote_port, remote_user, remote_password and remote_path inputs.

```
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: rsync deployments
      uses: burnett01/rsync-deployments@5.2
      with:
        switches: -avzr --delete
        path: src/
        remote_path: ${{ secrets.DEPLOY_PATH }}
        remote_host: ${{ secrets.DEPLOY_HOST }}
        remote_port: ${{ secrets.DEPLOY_PORT }}
        remote_user: ${{ secrets.DEPLOY_USER }}
        remote_password: ${{ secrets.DEPLOY_PASSWORD }}
```

If your private key is passphrase protected you should use:

```
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: rsync deployments
      uses: burnett01/rsync-deployments@5.2
      with:
        switches: -avzr --delete
        path: src/
        remote_path: ${{ secrets.DEPLOY_PATH }}
        remote_host: ${{ secrets.DEPLOY_HOST }}
        remote_port: ${{ secrets.DEPLOY_PORT }}
        remote_user: ${{ secrets.DEPLOY_USER }}
        remote_password: ${{ secrets.DEPLOY_PASSWORD }}
```

---

## Acknowledgements

+ This project is a fork of
  [kroominator/rsync-deployments-simply-com](https://github.com/kroominator/rsync-deployments-simply-com)
+ Base image [JoshPiper/rsync-docker](https://github.com/JoshPiper/rsync-docker)
