#!/bin/bash
set -e

defaultjdkSuite='openjdk:8-alpine'
declare -A jdkSuites=(
	[2.0.0]='openjdk:8-alpine'
	[2.0.1]='openjdk:8-alpine'
	[2.1.0]='openjdk:8-alpine'
	[2.1.1]='openjdk:8-alpine'
	[2.1.2]='openjdk:8-alpine'
	[2.1.4]='openjdk:8-alpine'
	[2.1.5]='openjdk:8-alpine'
)

declare -A urlBlazeGraphSuites=(
	[2.0.0]='https://sourceforge.net/projects/bigdata/files/bigdata/2.0.0/blazegraph.jar/download'
	[2.0.1]='https://sourceforge.net/projects/bigdata/files/bigdata/2.0.1/blazegraph.jar/download'
	[2.1.0]='https://sourceforge.net/projects/bigdata/files/bigdata/2.1.0/blazegraph.jar/download'
	[2.1.1]='https://sourceforge.net/projects/bigdata/files/bigdata/2.1.1/blazegraph.jar/download'
	[2.1.2]='https://sourceforge.net/projects/bigdata/files/bigdata/2.1.2/blazegraph.jar/download'
	[2.1.4]='https://sourceforge.net/projects/bigdata/files/bigdata/2.1.4/blazegraph.jar/download'
	[2.1.5]='https://github.com/blazegraph/database/releases/download/BLAZEGRAPH_RELEASE_CANDIDATE_2_1_5/blazegraph.jar'
)

versions=( "$@" )

if [ ${#versions[@]} -eq 0 ]; then
	versions=("${!urlBlazeGraphSuites[@]}")
fi
versions=( "${versions[@]%/}" )
for version in "${versions[@]}"; do
    echo "produce $version"
    dockerfiles=()
    if [ ! -e "$version" ]; then
        mkdir "$version"
    fi

    # prepare Dockerfile
	{ cat Dockerfile-alpine.template; } > "$version/Dockerfile"
	{ cat README.template; } > "$version/README.md"
	if [ ! -e "$version/docker-entrypoint-initdb.d" ]; then
	    mkdir -p "$version/docker-entrypoint-initdb.d/kb/data/"
	fi
	{ cat RWStore.properties; } > "$version/docker-entrypoint-initdb.d/kb/RWStore.properties"

    cp  \
            docker-entrypoint.sh \
            "$version/"

    jdkSuite="${jdkSuites[$version]:-$defaultjdkSuite}"
    url="${urlBlazeGraphSuites[$version]}"
    fullVersion="${version}"
    dockerfiles+=( "$version/Dockerfile" )

    for f in "${version}"/*; do
        if [ ! -d "${f}" ]; then
            (
                sed -ri \
                    -e 's!%%BLAZEGRAPH_VERSION%%!'"$fullVersion"'!' \
                    -e 's!%%BLAZEGRAPH_URL%%!'"$url"'!' \
                    -e 's!%%JDK_SUITE%%!'"$jdkSuite"'!' \
                    ${f}
            )
        fi
    done
done