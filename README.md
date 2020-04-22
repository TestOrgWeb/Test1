# Backport your changes

This action will backport the recent commit made on your PR to the desired branch (version).

The action won't push directly to your backport branches, instead, it will create a PR. This allows you to make sure the backport compiles and passes your tests before merging.

## Requirements

* You need to be the **MEMBER** of the OpenDistro For ElasticSearch organization on github
* Pull Request with changes to be backported to older versions (branches)

## How to Use:

You might already have a PR in process with the required changes in it. Comment on the same PR in the pattern below:
```
                           [Backport] to <branch-Name>
```

The workflow won’t be triggered unless *[Backport]* is mentioned in the comment along with the square brackets. The purpose is to avoid the unintentional triggers during conversation.
Mention the branch name or a regex (eg: opendistro-1*) to which you want to backport the changes to. 

## Results

Result of the back-porting attempt will be posted on the same PR where made the comment. This will include:
* Attempt status (success/failure)
* Link to the workflow (in case you want to look at the logs or see the process)
* Link to the new back-porting PR that was created 

## Conclusion

You will get either of the result:
1. ***Back-porting is successful***: In this case the cherry-pick is successful and no merge conflicts were faced. You are free to go and merge the changes to the intended branch. 
2. ***Back-porting failed***: In this case, the cherry-pick attempt failed due to merge conflicts. However to ease the process, a new PR will be raised along with the merge conflicts and additional data from git (eg: <<<<<<<head).
You can go ahead and resolve that before merging or you can close the PR. It’s your decision.

**Important**: Delete the auto-created branch after merging or closing the PR.

Refer [quip](https://quip-amazon.com/XHzKAYtgb89Y/GitHub-Backport) for more details


