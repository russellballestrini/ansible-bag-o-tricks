#!/usr/bin/env bash

source /etc/default/mongo-back

get_env_or_set_default=${mongodb_host:=localhost}
get_env_or_set_default=${mongodb_backup_dir:=/tmp/mongodb-backups}
get_env_or_set_default=${retention_days:=21}

the_date=$(date +%Y-%m-%d-%H%M%S)

backup_dir="$mongodb_backup_dir/$the_date"

mkdir -p "$mongodb_backup_dir"
mkdir -p "$backup_dir"

/usr/bin/mongodump --quiet --host $mongodb_host -o $backup_dir
tar -zcvf "$backup_dir.tar.gz" "$backup_dir"
rm -rf "$backup_dir"

find $mongodb_backup_dir -mindepth 1 -mtime +$retention_days -type f -delete -name "*.tar.gz"
