#!/bin/sh -l

echo "${NAME}"

# Set up .netrc file with GitHub credentials
cat <<- EOF > .netrc
    machine github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
    machine api.github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
EOF
chmod 600 .netrc
cat .netrc

git init
git clone git@github.com:TestOrgWeb/infra.git
echo "git clone worked"