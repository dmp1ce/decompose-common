# decompose-common
Some common code usable for nearly all decompose environments

## Requirements

- [decompose](https://github.com/dmp1ce/decompose)

## How to use

Include this library and source `elements` and `processes` files your main decompose environment `elments` and `processes` file.

### Example

First add lib as a submodule to your environment:
```
$ cd .decompose/environment
$ git submodule add https://github.com/dmp1ce/decompose-common.git lib/common
```

Then make your `processes` and `elements` file look like this:
```
$ cat elments
# Include common elements
source $(_decompose-project-root)/.decompose/environment/lib/common/elements
$ cat processes
# Include common processes
source $(_decompose-project-root)/.decompose/environment/lib/common/processes
```

## Elements provided

- `PROJECT_VERSION_FILE` : Used by the `_decompose-process-build_version_file` function to create a version file. Should be the relative path and filename to the version file. For example: `PROJECT_VERSION_FILE=my/path/version.txt`

## Processes provided

- `project-root` : Prints the root path of the decompose environment
- `diff-skeleton` : Shows differences between the project and the decompose environment skeleton located at `.decompose/environment/skel`
- `print-vars` : Prints all of the `PROJECT_*` variables

### Other functions

These functions can be used inside your custom processes.

- `_decompose-process-common-build` : Only runs `decompose-process-templates`
- `_decompose-process-build_version_file` : Creates a version file located at `$PROJECT_VERSION_FILE`
