# The documentation for justfile can be found here: https://just.systems/man/en/

#<<< Settings
set dotenv-load
set allow-duplicate-recipes
set shell := ['bash', '-c']
#>>> Settings

#<<< Variables
#>>> Variables

#<<< Imports
import '.just/project.just'
import? '.just/ascii.just'
#>>> Imports

#<<< Default
[private]
default:
    @just --justfile .just/project.just help
#>>> Default

#<<< Setup
# Sets up the project. Use this command if you just cloned the project
# and you want to set it up.
setup:
    @echo "{{GREEN}}Setting up the project...{{NORMAL}}"
    @just --justfile .just/project.just setup
#>>> Setup