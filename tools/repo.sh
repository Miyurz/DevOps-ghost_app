#!/bin/bash

git_url="http://git.publiodigital.com/"

while IFS='' read -r repo || [[ -n "$repo" ]]; do

	echo "Cloning repo: ${git_url}$repo"
	IFS='/' read -ra GIT_REPO <<< "$repo"

	echo git repo is ${GIT_REPO[1]}
	IFS='.' read -ra DIRNAME <<< "${GIT_REPO[1]}"

	echo directory where you clone ${DIRNAME[0]}

	if [ -d "../${DIRNAME[0]}" ];
	then
	   cd ../${DIRNAME[0]}
	   git pull
	   cd -
        else
	   git clone ${git_url}$repo ../${DIRNAME[0]}
        fi
done < "repo_list.txt"








