#!/bin/sh -l

echo "Repository name: ${NAME}"
echo "---------Setting up bot name--------------"
git config --global user.email "backport@bot.com"
git config --global user.name "gaiksaya"
echo "----------Set up .netrc file with GitHub credentials------"
cat <<- EOF > $HOME/.netrc
    machine github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
    machine api.github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
EOF
chmod 600 $HOME/.netrc
echo "------------Branch name-----------"
git fetch
echo ${BRANCH} 
backportingBranches=`git branch -r | grep ${BRANCH} | sed 's/origin\///'`
echo "----------------Backporting now----------------"
# for i in $backportingBranches; do
#     echo "Current branch in process: ${i} "
#     git checkout ${i}
#     git branch
#     echo "--------creating autobackport branch for raising PR-------------"
#     git checkout -b autoBackport-${i} origin/${i}
#     echo "----------Cherry picking the commit-------------------"
#     git cherry-pick ${COMMIT_SHA}
#     if [ `echo $?` -ne 0 ]
#     then echo "Need manual intervention to resolve the conflicts"
#     else
#     echo "--------Push the branch to upstream-------------"
#     git push -f origin autoBackport-${i}
    echo "-------Creating PR----------------"
    echo `curl -X POST \
    https://api.github.com/repos/${NAME}/pulls \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer ${ACCESS_TOKEN}' \
    -d '{ \"title\":\"Backporting PR\", \"body\":\"Backporting the changes to previous version\", \"head\":\"autobackport-${i}\",\"base\":\"${i}\"}'`
#     fi

# done