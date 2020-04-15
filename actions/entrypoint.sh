#!/bin/sh -l

echo "Repository name: ${NAME}"
echo "------------Remote url-----------"
git remote -v
pwd 
echo "---------See the git config----------"
ls -al
cat .git/config
for i in $(git branch -r | grep ${BRANCH} | sed 's/origin\///'); do
    git fetch
    git checkout ${i}
    git branch
    echo "--------creating autobackport branch for raising PR-------------"
    git checkout -b autoBackport-${i} origin/${i}
    echo "----------Cherry picking the commit-------------------"
    git cherry-pick ${COMMIT_SHA}
    if [ echo$? -ne 0 ]
    then echo "Need manual intervention to resolve the conflicts"
    else
    echo "--------Push the branch to upstream-------------"
    git push -f origin autoBackport-${i}
    echo "-------Creating PR----------------"
    curl -X POST \
    https://api.github.com/repos/${NAME}/pulls?access_token=${ACCESS_TOKEN} \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer ${ACCESS_TOKEN}' \
    -d '{ \"title\":\"Backporting PR\", \"body\":\"Backporting the changes to previous version\", \"head\":\"autobackport-${i}\",\"base\":\"${i}\"}'
    fi

done