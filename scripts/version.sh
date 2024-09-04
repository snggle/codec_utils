#!/usr/bin/env bash

# This script is used to have a single and consistent way of retrieving version from the source code
VERSION_FILE=./pubspec.yaml
VERSION=$(grep -Fn -m 1 'version: ' $VERSION_FILE | rev | cut -d ":" -f1 | rev | xargs | tr -dc '[:alnum:]\-\.\+' || echo '')
RAW_VERSION=$VERSION

# Script MUST fail if the version could NOT be retrieved
[ -z $VERSION ] && echo "ERROR: codec_utils version was not found in the version file '$VERSION_FILE' !" && exit 1

PATHS_COUNT=$(echo "${VERSION}" | tr -cd "." | wc -c)

if [[ $PATHS_COUNT -lt 2 ]] ; then
    echo "ERROR: Version has invalid format, must be X.X.X, X.X.X.X, X.X.X+X, X.X.X-rc.X, but got $RAW_VERSION"
fi

VERSION=${VERSION//+/.}
VERSION=$(echo "$VERSION" | grep -o '[^-]*$')

if [[ $PATHS_COUNT -le 2 ]] ; then
    VERSION="${VERSION}.0"
fi

major_VERSION=$(echo $VERSION | cut -d. -f1 | sed 's/[^0-9]*//g')
minor_VERSION=$(echo $VERSION | cut -d. -f2 | sed 's/[^0-9]*//g')
build_VERSION=$(echo $VERSION | cut -d. -f3 | sed 's/[^0-9]*//g')

echo "${major_VERSION}.${minor_VERSION}.${build_VERSION}"