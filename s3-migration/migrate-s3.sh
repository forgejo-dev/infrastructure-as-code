#!/bin/bash

set -e

# Check for existing ENVs
if [[ -z "$ACCESSKEY" ]]; then
	echo "=> No ACCESSKEY ENV found. Exit."; exit 1 ;
fi

if [[ -z "$SECRETKEY" ]]; then
	echo "=> No SECRETKEY ENV found. Exit."; exit 1 ;
fi

if [[ -z "$SOURCE" ]]; then
	echo "=> No SOURCE ENV found. Exit."; exit 1 ;
fi

if [[ -z "$TARGET" ]]; then
        echo "=> No TARGET ENV found. Exit."; exit 1 ;
fi

mc alias set s3src $SOURCE $ACCESSKEY $SECRETKEY
mc alias set s3trg $TARGET $ACCESSKEY $SECRETKEY

mc admin config export s3src > config.txt
mc admin config import s3trg < config.txt

mc admin service restart s3trg

mc admin cluster bucket export s3src
mc admin cluster bucket import s3trg cluster-metadata.zip

# mirroring existing bucket -> migration server/bucket
mc mirror -preserve --watch s3src/gitea s3trg/gitea
