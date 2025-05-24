# Workspace

This repository hosts the root workspace from which my other C++ projects are built.
It provides a fast and convenient way to clone git project repositories along with their dependent projects, build the workspace while keeping the dependency order.

## Manifest file
Workspace uses a "manifest" file that contains a list of projects (github repos) to be cloned, and their relative dependencies, which are also workspace projects.
The dependencies are used to build the projects in the workspace in the right order.

**Each workspace project provides a manifest.txt file that can be used to clone it and it's dependencies** 

Here is an example content for a manifest file: 
```
r:git@github.com:romank-dev/libcommon
r:git@github.com:romank-dev/libconfig
r:git@github.com:romank-dev/libipc
r:git@github.com:my_user/my_project
d:libconfig:libcommon
d:libipc:libcommon
d:my_project:libcommon libconfig libipc
```
* If a line starts with an 'r', the following should bne a URL to the git repo to be cloned.
* If a line starts with a 'd', the following should be a dependency list for a project, in the format "project: dep1 dep2 ..."

## Setup using init.sh
Running init.sh with no arguments reveals the two modes of setting up:
* Provide a URL to the manifest file: `init.sh -u https://some_website.com/my_project_manifest.txt`. Usually the manifest of a project is hosted on it's github homepage
* Provide a path on your file system: `init.sh -f /path/to/manifest.txt`

The **init.sh** script will use **git over SSH** to clone all of the projects into the 'src' folder (after deleting the possibly existing one) 
and create the file "make_order.txt" which will be parsed by the root Makefile when building.

## Building the workspace
* Run "make" while inside the root folder of the workspace. All projects under **src/** should be built in the correct order.
* You can run "make <subproject>" to build a specific project under **src/** and it's dependencies.

## Workspace structure
Let's go over the structure of the workspace once it's built:
* **src/** - The source folder. All project repositories to be built will be located here.
* **obj/** - The folder for compiled object (.o) and dependency (.d) files.
* **bin/** - The binaries/products folder. Linked libraries and executables will be there. For complex projects, additional assets (e.g. example files, images, data) will be included.
  * **bin/<library.so>** - Shared libraries will be located directly under **bin/**.
  * **bin/<project_name>/program_exe** - Executables and other products of projects will reside inside the folder with the project's name.
 
## NOTE: Dynamic Library Path Situation
The method of making the Linux library loader locate the shared libraries under **bin/** is **left entirely to the user**. Here are some options:
* Configure /etc/ld.so.conf.d to include workspace/bin and run ldconfig.
* Use the LD_LIBRARY_PATH environment variable
* Add compile flags e.g. `-Wl,-rpath` to the G_CXXFLAGS variable in the root Makefile
   
