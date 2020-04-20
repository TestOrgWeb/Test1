#!/bin/sh -l

echo "Repository name: ${NAME}"

#Setting up bot name
git config --global user.email "backport@amazon.com"
git config --global user.name "Backport Bot"

git fetch
workflowUrl=https://github.com/TestOrgWeb/infra/actions/runs/${GITHUB_RUN_ID}
echo "------------Branch/es name-----------"
echo "Regex specified: ${BRANCH}"
git branch -r | sed 's/origin\///' >> regex
backportingBranches=`grep "^  ${BRANCH}" regex`
echo $backportingBranches
echo "----------------Backporting now----------------"
for i in $backportingBranches; do
    echo "Current branch in process: ${i} "
    git checkout ${i}
    git branch
    echo "--------creating autobackport branch for raising PR-------------"
    git checkout -b autoBackport-${i} origin/${i}
    echo "----------Cherry picking the commit-------------------"
    git cherry-pick ${COMMIT_SHA}
    if [ `echo $?` -ne 0 ]
    then 
    echo "BACKPORTING FAILED FOR BRANCH $i!!!!! NEED MANUAL INTERVENTION TO RESOLVE CONFLICTS"
    # Informing the user via PR comment that it failed
    echo `curl -X POST ${PR_URL} -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -d "{ 
        \"body\" : \"Backporting failed for branch $i!!! NEED MANUAL INTERVENTION TO RESOLVE CONFLICTS \n
        Workflow URL\:  $workflowUrl\"
        }"`
    else
    echo "--------Push the branch to upstream-------------"
    git push -f origin autoBackport-${i}
    # Creating PR now
    echo "---------Creating PR----------------"
    echo `curl -X POST https://api.github.com/repos/${NAME}/pulls \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -d "{
         \"title\":\"Backporting PR\", 
         \"body\":\"Backporting the changes to previous version\", 
         \"head\":\"autoBackport-${i}\",
         \"base\":\"${i}\"
         }"`
    echo "Backporting successful for branch: $i"
    # Informing the user via PR comment that it succeeded
    echo `curl -X POST ${PR_URL} -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -d "{ 
        \"body\" : \"Backporting successful for branch $i  Workflow URL $workflowUrl\" 
        }"`
    fi

done