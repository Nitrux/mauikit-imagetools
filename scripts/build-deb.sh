#! /bin/bash

set -x

### Update sources

wget -qO /etc/apt/sources.list.d/nitrux-depot.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux

wget -qO /etc/apt/sources.list.d/nitrux-testing.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.testing

curl -L https://packagecloud.io/nitrux/depot/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/unison/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;

apt -qq update

### Install Package Build Dependencies #2

apt -qq -yy install --no-install-recommends \
	mauikit-git

### Download Source

git clone --depth 1 --branch $MAUIKIT_IMAGETOOLS_BRANCH https://invent.kde.org/maui/mauikit-imagetools.git

rm -rf mauikit-imagetools/{examples,LICENSE,README.md}

### Compile Source

mkdir -p build && cd build

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
	-DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu ../mauikit-imagetools/

make -j$(nproc)

make install

### Run checkinstall and Build Debian Package

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
	--pkgversion=$PACKAGE_VERSION \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=libs \
	--pkgsource=mauikit-imagetools \
	--pakdir=. \
	--maintainer=uri_herrera@nxos.org \
	--provides=mauikit-imagetools-git \
	--requires="kquickimageeditor,libc6,libexiv2-27,liblept5,libopencv-core406,libqt5core5a,libqt5positioning5,libqt5positioning5-plugins,libqt5positioningquick5,libqt5qml5,libqt5sql5,libstdc++6,mauikit-git \(\>= 2.2.1+git\),qml-module-org-kde-kirigami2,tesseract-ocr" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
