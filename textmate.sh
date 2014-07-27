#!/bin/bash

cd $(dirname $0)
folder=$(pwd)

retryCount=$1
if [ "${retryCount}" = "" ]
then
	retryCount=0
fi

if [ -d textmate ]
then
	cd textmate
	git pull -v
else
	git clone https://github.com/textmate/textmate.git
	cd textmate
fi

# update submodule
git submodule update --init

# build app
./configure && ninja
if [ ! $? -eq 0 ]
then
	clear
	let retryCount=retryCount+1
	echo =================[RESTART:${retryCount}]=================
	sh ${folder}/textmate.sh ${retryCount}
	exit
fi

# quit TextMate.app before replacing
osascript -e 'tell application "TextMate" to quit'

# replace TextMate.app in /Applications/
rsync -cvazh --delete ${HOME}/build/TextMate/Applications/TextMate/TextMate.app/ /Applications/TextMate.app/

# quit TextMate.app if running
osascript -e 'tell application "TextMate" to quit'

# restart TextMate.app
open -a TextMate

# delete temp building files
ninja -t clean
rm -fr ${HOME}/build
