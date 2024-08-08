#!/bin/bash

# Store current working directory
cwd=$(pwd)

# git ls-tree -rtd --name-only HEAD ./ | grep -Ev '^\.'

# Update repodata.txt for each git-tracked directory not starting with '.'
for dir in $(git ls-tree -rtd --name-only HEAD ./ | grep -Ev '^\.'); do
    # Temporarily `cd` to ${dir} to compute checksums and git operations
    cd "${cwd}/${dir}"

    # Get sorted basenames of files not starting with '.' and not named 'repodata.txt'
    files=$(find . -maxdepth 1 -type f ! -name '.*' ! -name 'repodata.txt' -exec basename -a {} + | sort)

    # If ${files} is non-empty, write SHA-256 checksums to 'repodata.txt' and then stage it
    if [ -n "${files}" ]; then
        sha256sum ${files} > 'repodata.txt'
        # git add 'repodata.txt'
    fi
done

# Return to current working directory
cd "${cwd}"

