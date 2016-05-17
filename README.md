[![Build Status](https://travis-ci.org/dmp1ce/decompose-common.svg?branch=master)](https://travis-ci.org/dmp1ce/decompose-common)
# decompose-common
Some common code usable for nearly all decompose environments

## Requirements

- [decompose](https://github.com/dmp1ce/decompose)
- [colordiff](http://www.colordiff.org/) (Optional)

## How to use

Include this library and source `elements` and `processes` files your main decompose environment.

### Example

First add lib as a submodule to your environment:
``` bash
$ cd .decompose/environment
$ git submodule add https://github.com/dmp1ce/decompose-common.git lib/common
```

Then make your `processes` and `elements` file look like this:
``` bash
$ cat elements
# Include common elements
source $(_decompose-project-root)/.decompose/environment/lib/common/elements
$ cat processes
# Include common processes
source $(_decompose-project-root)/.decompose/environment/lib/common/processes
DECOMPOSE_PROCESSES=( "${DECOMPOSE_COMMON_PROCESSES[@]}" )
```

## Elements provided

- `PROJECT_VERSION_FILE` : Used by the `_decompose-process-build_version_file` function to create a version file. Should be the relative path and filename to the version file. For example: `PROJECT_VERSION_FILE=my/path/version.txt`

## Processes provided

- `project-root` : Prints the root path of the decompose environment
- `diff-skeleton` : Shows differences between the project and the decompose environment skeleton located at `.decompose/environment/skel`
- `print-vars` : Prints all of the `PROJECT_*` variables

### diff-skeleton process

By default the `diff-skeleton` process will diff all files in project root against the evironment skeleton. The process allows for ignore files to which ignore diffs on specified files. The ignore files which `diff-skeleton` looks for are located at:

- .decompose/environment/skel-diff-ignore
- .decompose/skel-diff-ignore
- .decompose-skel-diff-ignore

See the `diff` utitlity for details on how the ignore files syntax. Or see this [StackOverflow explination](http://stackoverflow.com/a/3775390).

### Other functions

These functions can be used inside your custom processes.

- `_decompose-process-common-build` : Only runs `decompose-process-templates`
- `_decompose-process-build_version_file` : Creates a version file located at `$PROJECT_VERSION_FILE`
