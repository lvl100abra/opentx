#!/bin/bash

# stops on first error
set -e
set -x

# make sure we are in the good directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

# pull the latest changes
./update-repo.sh

# retrieve release after the repo update
source ./version.sh

DESTDIR=/var/www/html/downloads-${version}/companion

# clean radio source
cd opentx/radio/src
make clean

# create companion rpm
rm -rf   ${DIR}/companion-build/
mkdir -p ${DIR}/companion-build/
cd       ${DIR}/companion-build/
cmake ../opentx/companion/src
make package
cp ./companion${version}-${release}-i686.rpm ${DESTDIR}
make stamp
chmod -Rf g+w . || true

# request companion compilation on Windows
cd ${DESTDIR}
wget -qO- http://winbox.open-tx.org/companion-builds/compile21.php?branch=${branch}
wget -O companion-windows-${release}.exe http://winbox.open-tx.org/companion-builds/companion-windows-${release}.exe
mv ${DIR}/opentx/companion/companion.stamp ./companion-windows.stamp

chmod -Rf g+w . || true

