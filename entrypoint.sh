#!/bin/sh

# Add strict errors.
set -eu

# Variables.
SWITCHES="$INPUT_SWITCHES"
echo "SWITCHES: $SWITCHES"
RSH="ssh -o StrictHostKeyChecking=no -p $INPUT_REMOTE_PORT $INPUT_RSH"
echo "RSH: $RSH"
LOCAL_PATH="$GITHUB_WORKSPACE/$INPUT_PATH"
echo "LOCAL_PATH: $LOCAL_PATH"
DSN="$INPUT_REMOTE_USER@$INPUT_REMOTE_HOST"
echo "DSN: $DSN"

# Deploy.

sh -c "sshpass -p '$INPUT_REMOTE_PASSWORD' rsync -aHAXxv --numeric-ids --delete --progress -e '$RSH' $LOCAL_PATH $DSN:$INPUT_REMOTE_PATH"
