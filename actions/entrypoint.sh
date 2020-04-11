#!/bin/sh -l

echo "${NAME}"
echo "------------Remote url-----------"
git remote -v
echo "------------Clone repo-----------"
git clone ${NAME}
echo "-------------branch name-------------------"
git branch
echo "-------------Checking out the branch------------"
git checkout ${BRANCHES}
