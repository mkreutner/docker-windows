# +---------------------------------------------------------------------------
# : Project specific recipes
# +---------------------------------------------------------------------------
[private]
@help:
    echo ".:: Project Help ::."
    just --list --list-heading '' --list-prefix "    ↪ " --justfile {{justfile()}}

[private]
[windows]
@setup:
    #!/usr/bin/env sh
    echo ".:: 🚧 Windows Project Setup ::."
    cd ..
    if [ ! -e .env ]; then
        echo ">>> Create .env file"
        cp .env.dist .env
    fi
    if [ -e ./docker/.gitconfig ]; then
        echo ">>> Copy .gitconfig in:"
        echo ">>>   - ./src/python"
        cp ./docker/.gitconfig ./src/python/.gitconfig
    fi
    uid=$(id -u)
    gid=$(id -g)
    sed -i "s/UID=.*/UID=$uid/" .env
    sed -i "s/GID=.*/GID=$gid/" .env

    touch config/.bash_history