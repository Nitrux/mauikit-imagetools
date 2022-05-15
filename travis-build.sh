#!/bin/bash

set -x

### Install Build Tools #1

DEBIAN_FRONTEND=noninteractive apt -qq update
DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	appstream \
	automake \
	autotools-dev \
	build-essential \
	checkinstall \
	cmake \
	curl \
	devscripts \
	equivs \
	extra-cmake-modules \
	gettext \
	git \
	gnupg2 \
	lintian \
	wget

### Add Neon Sources

wget -qO /etc/apt/sources.list.d/neon-user-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.neon.user

DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
	55751E5D > /dev/null

curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;

wget -qO /etc/apt/sources.list.d/nitrux-testing-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.nitrux.testing

DEBIAN_FRONTEND=noninteractive apt -qq update

### Install Package Build Dependencies #2
### Imagetools needs ECM > 5.70

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	kquickimageeditor \
	libexiv2-dev \
	libkf5coreaddons-dev \
	libkf5i18n-dev \
	libkf5kio-dev \
	mauikit-git \
	qtbase5-dev \
	qtpositioning5-dev

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --only-upgrade \
	extra-cmake-modules

### Clone Repository

git clone --depth 1 --branch master https://invent.kde.org/maui/mauikit-imagetools.git

rm -rf mauikit-imagetools/{examples,LICENSE,README.md}

### Compile Source

mkdir -p mauikit-imagetools/build && cd mauikit-imagetools/build

cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_BSYMBOLICFUNCTIONS=OFF \
	-DQUICK_COMPILER=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_SYSCONFDIR=/etc \
	-DCMAKE_INSTALL_LOCALSTATEDIR=/var \
	-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	-DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu ..

make

### Run checkinstall and Build Debian Package
### DO NOT USE debuild, screw it

>> description-pak printf "%s\n" \
	'A free and modular front-end framework for developing user experiences.' \
	'' \
	'MauiKit Image Tools Components.' \
	'' \
	'Maui stands for Multi-Adaptable User Interface and allows ' \
	'any Maui app to run on various platforms + devices,' \
	'like Linux Desktop and Phones, Android, or Windows.' \
	'' \
	'This package contains the MauiKit imagetools shared library, the MauiKit imagetools qml module' \
	'and the MauiKit imagetools development files.' \
	'' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=mauikit-imagetools-git \
	--pkgversion=2.1.2+git+2 \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=libs \
	--pkgsource=mauikit-imagetools \
	--pakdir=../.. \
	--maintainer=uri_herrera@nxos.org \
	--provides=mauikit-imagetools-git \
	--requires="libc6,libqt5core5a,libqt5qml5,libqt5sql5,libstdc++6,mauikit-git \(\>= 2.1.2+git\),qml-module-org-kde-kirigami2" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
