#!/bin/sh -l

echo "Repository name: ${NAME}"

#Setting up bot name
git config --global user.email "backport@amazon.com"
git config --global user.name "Backport Bot"

git fetch

#setting up workflow URL
workflowUrl=https://github.com/TestOrgWeb/infra/actions/runs/${GITHUB_RUN_ID}

#Branches where changes need to be backported
echo "Regex specified: ${BRANCH}"
git branch -r | sed 's/origin\///' >> regex
backportingBranches=`grep "^  ${BRANCH}" regex`
rm regex
echo "------------Branch/es where changes are to be backported-----------"
echo $backportingBranches

#Getting the merge commit 
echo "-------The merged commit--------"
echo $PR
data=$(curl $PR)
state=`echo $data | jq .state`
echo $state
if [ $state=="closed" ] 
then
commit_sha=`echo $data | jq -r '.merge_commit_sha'`
echo "Merge commit : $commit_sha"
else
#Serially applying the commits
data=$(curl $PR/commits)
commit_sha=`echo $data | jq -r '.[].sha'`
echo "Commits on the PR: $commit_sha"
fi

# echo "----------------Backporting now----------------"
# for i in $backportingBranches; do
#     echo "##############################################"
#     echo "Current branch in process: ${i} "
#     echo "##############################################"
#     git checkout ${i}

#     echo "--------creating a temp autobackport branch for raising PR-------------"
#     dt=`date +"%y%m%dT%H%M"`
#     autobranch=autoBackport-${i}-$dt 
#     git checkout -b $autobranch origin/${i}

#     echo "----------Cherry picking the commits from PR-------------------"
#     for j in commit_sha; do
#         git cherry-pick $commit_sha
#     done
#     if [ `echo $?` -ne 0 ] #failure scenario
#     then
#     git add .
#     git commit -m "Merge Conflicts here!"
#     git push origin $autobranch
#     echo "BACKPORTING FAILED FOR BRANCH $i!!!!! NEED MANUAL INTERVENTION TO RESOLVE CONFLICTS"

#     # Creating PR  with conflicts now
#     echo "---------Creating merge conflict PR----------------"
#     response=$(curl -X POST https://api.github.com/repos/${NAME}/pulls \
#     -H 'Content-Type: application/json' \
#     -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#     -d "{
#          \"title\":\"Backporting PR for ${i} with merge conflicts\", 
#          \"body\":\"This PR has merge conflicts. Please refer to the files changed tab, resolve and then merge\", 
#          \"head\":\"$autobranch\",
#          \"base\":\"${i}\"
#          }")
#     pull_url=$(echo "$response" | jq .html_url | sed 's/\"//g')

#     # Informing the user via PR comment that it failed
#     echo `curl -X POST ${COMMENT_URL} -H 'Content-Type: application/json' \
#     -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#     -d "{ 
#         \"body\" : \"Backporting attempted at ${COMMENTTIME} **FAILED** for branch $i!! Manual intervention required to resolve the conflicts\n\
#         - [Check Workflow]($workflowUrl)\n\
#         - [Check new PR with conficts]($pull_url) \"
#         }"`

#     else #success scenario
#     echo "--------Push the branch to upstream-------------"
#     git push origin $autobranch

#     # Creating PR now
#     echo "---------Creating PR----------------"
#     res=$(curl -X POST https://api.github.com/repos/${NAME}/pulls \
#     -H 'Content-Type: application/json' \
#     -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#     -d "{
#          \"title\":\"Backporting PR for ${i}\", 
#          \"body\":\"Backporting the changes to previous version\", 
#          \"head\":\"$autobranch\",
#          \"base\":\"${i}\"
#          }")
#     new_pr=$(echo "$res" | jq .html_url | sed 's/\"//g')
#     echo "Backporting successful for branch: $i"

#     # Informing the user via PR comment that it succeeded
#     echo `curl -X POST ${COMMENT_URL} -H 'Content-Type: application/json' \
#     -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#     -d "{ 
#         \"body\" : \"Backporting attempted at ${COMMENTTIME} **SUCCEEDDED** for branch $i\n\
#         - [Check Workflow]($workflowUrl)\n\
#         - [Check new PR]($new_pr)\" 
#         }"`

#     fi
# done