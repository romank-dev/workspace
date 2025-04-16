#!/bin/bash

#  Copyright 2025 Roman Kudinov. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


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
    echo "$MANIFEST_TEXT"
elif [[ $METHOD == "-u" ]]; then
    echo "cloning git repos listed in manifest url" $MANIFEST_PATH
    if ! MANIFEST_TEXT=$(curl -fsSL "$MANIFEST_PATH"); then
        echo "Failed to fetch manifest from $MANIFEST_PATH"
        exit 1
    fi
    echo "$MANIFEST_TEXT" | tee manifest.txt
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

