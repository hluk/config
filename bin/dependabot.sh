#!/bin/bash
# Helps to merge all dependabot commits into a single one in git repository
# cloned in the current directory.
set -euo pipefail

branch="update-dependencies"

update_dependencies() {
    if ! poetry update; then
        echo "Warning: Replacing lock file"
        rm -f poetry.lock
        poetry lock
    fi
    poetry install --no-root
}

cherry_pick() {
    git cherry-pick "$1" || {
        git checkout HEAD^ poetry.lock
        git mergetool
        git cherry-pick --continue || git cherry-pick --skip
    }
    git checkout HEAD^ poetry.lock
    update_dependencies
    git add poetry.lock
    git commit --squash=HEAD^ --amend --no-edit --allow-empty
}

get_main_branch() {
    if git branch | grep -qw main; then
        echo main
    elif git branch | grep -qw develop; then
        echo develop
    else
        echo master
    fi
}

get_upstream_remote_name() {
    if git remote | grep -qw upstream; then
        echo upstream
    else
        echo origin
    fi
}

main=$(get_main_branch)
remote=$(get_upstream_remote_name)

git fetch --prune "$remote"
git checkout "$remote/$main"
git checkout -b "$branch"

poetry install --no-root
git commit --allow-empty --message "Update dependencies"

for branch in $(git branch --remote --list "$remote/dependabot/*"); do
    cherry_pick "$branch"
done

git rebase --interactive --autosquash "$remote/$main"
