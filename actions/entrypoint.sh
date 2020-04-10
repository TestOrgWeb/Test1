#!/bin/sh -l

echo "${NAME}"

# Set up .netrc file with GitHub credentials
cat <<- EOF > /home/runner/work/.netrc
    machine github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
    machine api.github.com
    login gaiksaya
    password ${ACCESS_TOKEN}
EOF
chmod 600 /home/runner/work/.netrc
cat .netrc