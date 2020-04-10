#!/bin/sh -l

echo "${NAME}"
echo "------------Remote url-----------"
echo `git remote -v`
echo "-------------without echo-------------------"
git remote -v