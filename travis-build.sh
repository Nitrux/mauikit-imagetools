#!/bin/bash

set -x

apt -qq update
apt -qq -yy install equivs curl git wget gnupg2

### FIXME - the container mauikit/ubuntu-18.04-amd64 does have the neon repo but for some idiotic reason it isn't working here

wget -qO /etc/apt/sources.list.d/neon-user-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.neon.user

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
	55751E5D > /dev/null

curl -L https://packagecloud.io/nitrux/repo/gpgkey | apt-key add -;

wget -qO /etc/apt/sources.list.d/nitrux-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.nitrux

apt -qq update

### Install Dependencies

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends devscripts debhelper gettext lintian build-essential automake autotools-dev cmake extra-cmake-modules appstream qml-module-qtquick-controls2 qml-module-qtquick-shapes qml-module-qtgraphicaleffects mauikit-dev qtpositioning5-dev libexiv2-dev kquickimageeditor

mk-build-deps -i -t "apt-get --yes" -r

### Clone repo.

git clone --depth 1 --branch v2.0.1 https://invent.kde.org/maui/mauikit-imagetools.git

mv mauikit-imagetools/* .

rm -rf mauikit-imagetools examples LICENSES README.md

sed -i 's+ecm_find_qmlmodule(org.kde.kquickimageeditor 1.0)+ecm_find_qmlmodule(kquickimageeditor 1.0)+g' CMakeLists.txt

### Build Deb

mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us
