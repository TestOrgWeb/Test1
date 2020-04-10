#!/bin/sh -l

echo "${NAME}"

# Set up .netrc file with GitHub credentials
cat <<- EOF > $HOME/.netrc
    machine github.com
    login gaiksaya
    password 8486954681412a2464f9c6acbc1d6f7fde11c2e4
    machine api.github.com
    login gaiksaya
    password 8486954681412a2464f9c6acbc1d6f7fde11c2e4
EOF
chmod 600 $HOME/.netrc

echo "checking git remote"
git remote -v