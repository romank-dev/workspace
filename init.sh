#!/bin/bash

cd $(dirname "$0")

if [ "$#" -ne 2 ]; then
    echo "USAGE: init.sh [-u|-m|-f] [VALUE]"
    echo "       -u    VALUE is the url of the manifest"
    echo "       -f    VALUE is the local path of the manifest"
    echo "    Manifest is a line-separated list of repos to pull"
    exit
fi

METHOD=$1
MANIFEST_PATH=$2

# Check git
if ! command -v git &> /dev/null; then
  echo "Error: git is not installed."
  exit 1
fi

if [[ $METHOD == "-f" ]]; then
    echo "cloning git repos listed in manifest file " $MANIFEST_PATH      
    MANIFEST_TEXT=$(<$MANIFEST_PATH)
    echo $MANIFEST_TEXT
elif [[ $METHOD == "-u" ]]; then
    echo "cloning git repos listed in manifest url" $MANIFEST_PATH
    MANIFEST_TEXT=$(curl "$MANIFEST_PATH" 2>/dev/null)
    echo $MANIFEST_TEXT
else
    echo "bad method " $METHOD
    exit
fi


# Check SSH to GitHub
echo "Checking SSH access to GitHub..."
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "Error: SSH to git@github.com failed."
  echo "Make sure your SSH key is added to GitHub and the SSH agent is running."
  exit 1
fi

# remove src
if [ -d "src" ]; then
    echo "Removing src directory"
fi
rm -rf src
rm -f make_order.txt

# make src
echo "Creating src directory"
mkdir src

# clone the repos into src
IFS=$'\n'
for i in $MANIFEST_TEXT;
do
    if [[ $i == r:* ]]; then
        echo "Downloading repo " ${i:2}
        git clone ${i:2} src/$(basename ${i:2})
    elif [[ $i == d:* ]]; then
        echo "Adding dependency: " ${i:2}
        echo ${i:2} >> make_order.txt
    fi
done

