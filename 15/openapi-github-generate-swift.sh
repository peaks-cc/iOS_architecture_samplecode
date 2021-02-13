#!/bin/sh

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH=${JAVA_HOME}/bin:$PATH

rm -rf ./GitHubAPI
java -jar openapi-generator-cli.jar generate \
    -i openapi-github.yaml \
    -g swift5 \
    -o ./GitHubAPI \
    --library alamofire \
    --additional-properties projectName='GitHubAPI' \
    --additional-properties podAuthors='susieyy' \
    --additional-properties podHomepage='https://example.com' \
    --additional-properties podSummary='GitHubAPIClient' \
    --additional-properties unwrapRequired=false

cp -R ./openapi-patch-swift/* ./GitHubAPI/GitHubAPI/Classes/OpenAPIs/
find ./GitHubAPI/GitHubAPI/Classes/OpenAPIs/Models -type f -print0 | xargs -0 sed -i '' -e 's/: Codable /: Codable, Equatable, Hashable /g'