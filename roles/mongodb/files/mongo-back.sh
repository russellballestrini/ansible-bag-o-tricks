#!/bin/bash

mongodb_backup_dir="/tmp/mongodb-backups"
mongodb_name_file="/tmp/mongodb-database-names"
the_date=$(date +%Y-%m-%d-%H%M%S)
retention_days=21

mkdir -p $mongodb_backup_dir

echo 'db.adminCommand({ listDatabases: 1 })["databases"].forEach(function(x){print(x.name)});' | \
  /usr/bin/mongo --quiet > $mongodb_name_file

echo ""

while read dbname; do
  echo "database $dbname:"
  mongodb_collection_file="/tmp/mongodb-$dbname-collection-names"
  echo 'show collections;' | /usr/bin/mongo $dbname --quiet > "$mongodb_collection_file"
  while read cname; do
    file_name="$dbname.$cname.$the_date.bson.gz"
    gzip_file="$mongodb_backup_dir/$file_name"
    echo "  dumping collection $cname into $gzip_file"
    /usr/bin/mongodump --quiet -d $dbname -c $cname -o - | gzip -9 > "$gzip_file" 
  done <$mongodb_collection_file
  rm "$mongodb_collection_file"
  echo ""
done <$mongodb_name_file
rm "$mongodb_name_file"

find $mongodb_backup_dir -mindepth 1 -mtime +$retention_days -type f -delete -name *.gz
