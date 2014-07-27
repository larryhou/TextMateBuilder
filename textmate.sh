#!/bin/bash
cd $(dirname $0)

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

# clean up before start
ninja -t clean

# build app
./configure && ninja

# replace TextMate.app in /Applications/
rsync -cvazh --delete /Users/doudou/build/TextMate/Applications/TextMate/TextMate.app/ /Applications/TextMate.app/

# delete building temp files
rm -fr /Users/doudou/build
