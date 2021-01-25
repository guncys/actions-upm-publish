#!/bin/bash

set -e

cat << EOS | sed -i '1r /dev/stdin' CHANGELOG.md

## [${INPUT_RELEASE_VERSION##v}] - $(date "+%Y-%m-%d")

${INPUT_RELEASE_SUMMARY}

$(echo "${INPUT_RELEASE_BODY}" | sed 's/^#/\#\#/')
EOS
cat package.json | jq -Mr '. | .version = "'"${INPUT_RELEASE_VERSION##v}"'"' > /tmp/package.json
mv /tmp/package.json package.json

echo $(echo -n "http://dev.upm.guncys.net:4873" | sed 's/^http://')'/:_authToken="'tK5vucgkB7dqQVENM6cdizjogTq4ole+MdXx3tEY1H0='"' >> ~/.npmrc

echo "Inside ~/.npmrc"
cat ~/.npmrc


# npm publish --tag latest --registry ${INPUT_NPM_REGISTRY_URL} 

git config --global user.email "github-actions@example.com"
git config --global user.name "GitHub Actions"
git checkout -b "temporary-$(date '+%Y%m%d%H%M%S')"
git add .
git commit -m ":up: Bump up version: ${INPUT_RELEASE_VERSION}" && git push "https://${INPUT_GITHUB_ACTOR}}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_GITHUB_REPOSITORY}.git" HEAD:${INPUT_RELEASE_BRANCH} || true
git tag -d ${INPUT_RELEASE_VERSION}
git tag ${INPUT_RELEASE_VERSION}
git push --tags --force
