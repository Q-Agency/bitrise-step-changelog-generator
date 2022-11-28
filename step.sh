#!/usr/bin/env bash
set -ex

environment="staging"

newest_tag=`git tag | grep $environment | tail -n 1`
if [ -z $newest_tag ]; then
   echo "No $environment tag found."
   exit 1
fi

tag_count=`git tag | grep $environment | wc -l`
second_newest_tag=`git tag | grep $environment | tail -n 2 | head -n 1`
if [ $tag_count -eq "1" ]; then
   changelog=`git log --pretty=format:%s | grep "ID"`
else
   changelog=`git log --pretty=format:%s $newest_tag...$second_newest_tag | grep "ID"`
fi

date=`git log -1 --format=%ai $newest_tag`
build_number=`echo $newest_tag | cut -d "_" -f 3`

envman add --key COMMIT_MESSAGE_CLEAN --value "$changelog"