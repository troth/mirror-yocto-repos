#!/bin/bash

MIRROR_REPOS=(
    meta-arm
    meta-ti
    meta-virtualization
    meta-yocto
    yocto-docs
)

function sync_mirror ()
{
    local repo="$1"

    echo ""
    echo "### Syncing mirror: ${repo}"
    if [ ! -d "${repo}.git" ]
    then
        git clone --mirror --bare "https://git.yoctoproject.org/${repo}"
    fi

    cd "${repo}.git"
    set -x
    git remote set-url --push origin "github:troth/${repo}.git"
    git remote -v
    git fetch -p origin
    git push --mirror
}

mkdir -p yocto-mirrors
cd yocto-mirrors

for repo in "${MIRROR_REPOS[@]}"
do
    ( sync_mirror "${repo}" )
done
