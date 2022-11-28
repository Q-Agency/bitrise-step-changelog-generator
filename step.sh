#!/usr/bin/env bash
# fail if any commands fails
set -ex

newest_tag=`git tag | grep $ENVIRNOMENT_TAG | tail -n 1`
if [ -z $newest_tag ]; then
   echo "No $ENVIRNOMENT_TAG tag found."
   exit 1
fi

tag_count=`git tag | grep $ENVIRNOMENT_TAG | wc -l`
second_newest_tag=`git tag | grep $ENVIRNOMENT_TAG | tail -n 2 | head -n 1`
if [ $tag_count -eq "1" ]; then
   changelog=`git log --pretty=format:%s | grep "ID"`
else
   changelog=`git log --pretty=format:%s $newest_tag...$second_newest_tag | grep "$COMMIT_TAG"`
fi

date=`git log -1 --format=%ai $newest_tag`
build_number=`echo $newest_tag | cut -d "_" -f 3`

envman add --key CHANGELOG --value "$changelog"