#!/bin/sh -l

echo "${NAME}"
echo "Viewing git remote"
git remote -v
# Making sure we are on top of the branch
echo "Git checkout branch ${GITHUB_REF##*/}"
git checkout ${GITHUB_REF##*/}