#!/bin/sh

user=voyt
default_ssh_port=

function mutagen_sync_to_remote_host() {
        local remote_host=$1
        local remote_ssh_port=$2
        local sync_path=$3
        local name=$4

        if ! mutagen sync list | grep $name; then
                if ping -c1 $remote_host 2>&1 > /dev/null; then
                        if mutagen sync list | grep $name; then
                                mutagen sync terminate $name
                        fi
                        mutagen sync create \
                                --mode=one-way-replica \
                                --name=$name \
                                $sync_path \
                                $user@$remote_host:$remote_ssh_port:$sync_path
                                # --ignore=./path
                else
                        echo "Host $remote_host is not available"
                        exit
                fi
        fi
        mutagen sync flush $name
        echo "Sync to $remote_host is done"
}

# fast version of scp path remote_path
function sync_files_one_way() {
        local remote_host=$1
        local sync_path=$2
	local name=${sync_path//[!A-Za-z0-9-]/}
        mutagen_sync_to_remote_host \
                $remote_host \
                $default_ssh_port \
                $sync_path \
		$name
        mutagen sync terminate $name
}

#####################################################################



sync_files_one_way 192.168.000.002 $HOME/p/voyt_dotfiles
