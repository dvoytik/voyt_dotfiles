#!/bin/sh

function mutagen_sync_to_remote_host() {
        remote_host=$1
        remote_ssh_port=$2
        sync_path=$3
        name=$4

        if ! mutagen sync list | grep $name; then
                if ping -c1 $remote_host 2>&1 > /dev/null; then
                        if mutagen sync list | grep $name; then
                                mutagen sync terminate $name
                        fi
                        mutagen sync create \
                                --mode=one-way-replica \
                                --name=$name \
                                $sync_path \
                                voyt@$remote_host:$remote_ssh_port:$sync_path \
                                --ignore=.out
                else
                        echo "Host $remote_host is not available"
                        exit
                fi
        fi
        mutagen sync flush $name
        echo "Sync to $remote_host is done"
}

mutagen_sync_to_remote_host \
        192.168.0.10 \
        20 \
        /home/voyt/p/linux \
        voytpc
