#!/bin/bash
set -eo pipefail
_loadData() {
    namespace=$(basename "$1")
    if [ ! -e "$1/RWStore.properties" ]; then
        echo >&2 ' No configuration file for the namespace '
		exit 1
	fi
    if [ ! -e -d "$1/data" ]; then
        echo >&2 ' No data dir for kb to import '
	fi
    dataloader=( java -cp /usr/bin/blazegraph.jar com.bigdata.rdf.store.DataLoader -quiet -namespace ${namespace} $1/RWStore.properties $1/data/ )
    echo "loading $1"
    "${dataloader[@]}"
}
if [ "$1" = 'blazegraph' ]; then
    set java_params=

    if [ ! -z "$JAVA_XMS" ]; then
        java_params+=( -Xms"${JAVA_XMS}" )
    else
        java_params+=( -Xms512m )
    fi

    if [ ! -z "$JAVA_XMX" ]; then
        java_params+=( -Xmx"${JAVA_XMX}" )
    else
        java_params+=( -Xmx1g )
    fi

    conf=()
    if [ -e /etc/blazegraph/override.xml ]; then
        conf+=( -Djetty.overrideWebXml=/etc/blazegraph/override.xml )
    fi

    blazegraph=( java ${java_params[@]} ${conf[@]} -jar /usr/bin/blazegraph.jar )

    echo
    echo 'Blazegraph init process done. Ready for start up.'
    echo

    for f in docker-entrypoint-initdb.d/*; do
        if [ -e $f ];then
            _loadData "$f"
        fi
    done

    echo "${blazegraph[@]}"
    cd /var/lib/blazegraph
    exec "${blazegraph[@]}"
fi