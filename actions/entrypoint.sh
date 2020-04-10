#!/bin/sh -l

echo "${NAME}"

# Set up .netrc file with GitHub credentials
cat <<- EOF > $HOME/.netrc
    machine github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
    machine api.github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
EOF
chmod 600 $HOME/.netrc

echo "checking git remote"
git remote -v