#!/bin/bash
set -e

## Get git commit ID
CI_COMMIT_ID=${CI_COMMIT_ID:-$(git rev-list HEAD | head -n 1)}
CI_COMMIT_ID_SHORT=${CI_COMMIT_ID:0:6}

## Get latest tag ID
CI_TAG_ID=$(git tag | tail -n 1)
if [ -z "${CI_TAG_ID}" ]; then
	CI_TAG_ID="v0.0.0";
fi
CI_TAG_AUTO="$(echo ${CI_TAG_ID} | awk -F'.' '{print $1 "." $2}').$(date +"%y%m%d-%H%M")"

## Login to docker hub on release action
if [ ! -f "/root/.docker/config.json" ]; then
	docker login -u $DOCKER_REGISTRY_USERNAME -p $DOCKER_REGISTRY_PASSWORD
fi

function github_release {
	TAG="$1"
	NAME="$2"
	latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
	comparison="$latest_tag..HEAD"
	if [ -z "$latest_tag" ]; then
		comparison="";
	fi
	changelog=$(git log $comparison --oneline --no-merges)
	echo "Creating release $1: $2"
	github-release release \
		--user titpetric \
		--repo sonyflake \
		--tag "$1" \
		--name "$2" \
		--description "$CHANGELOG"
}

function github_upload {
	echo "Uploading $2 to $1"
	github-release upload \
		--user titpetric \
		--repo sonyflake \
		--tag "$1" \
		--name "$(basename $2)" \
		--file "$2"
}

function github_delete {
	echo "Deleting release: $1"
	github-release delete \
		--user titpetric \
		--repo sonyflake \
		--tag "$1"
}

set +e
github_delete ${CI_TAG_AUTO}
set -e

github_release ${CI_TAG_AUTO} "$(date)"

FILES=$(find build -type f | grep tgz$)
for FILE in $FILES; do
	github_upload ${CI_TAG_AUTO} "$FILE"
done

docker tag titpetric/sonyflake titpetric/sonyflake:${CI_COMMIT_ID_SHORT}
docker push titpetric/sonyflake:${CI_COMMIT_ID_SHORT}
docker push titpetric/sonyflake:latest
