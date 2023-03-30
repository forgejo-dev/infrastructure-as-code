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

mc mirror -preserve --watch s3src/gitea $TARGET
