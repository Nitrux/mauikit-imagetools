#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2025-2026 <Nitrux Latinoamericana S.C. <hello@nxos.org>>


# -- Exit on errors.

set -e


# -- Download Source

git clone --depth 1 --branch "$MAUIKIT_IMAGETOOLS_BRANCH" https://github.com/Nitrux/mauikit-imagetools-src.git

rm -rf mauikit-imagetools-src/{examples,LICENSE,README.md}


# -- Compile Source

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
	-DCMAKE_INSTALL_LIBDIR="/usr/lib/${HOST_MULTIARCH}" \
	../mauikit-imagetools-src/

make -j"$(nproc)"

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
	--pkgname=mauikit-imagetools \
	--pkgversion="$PACKAGE_VERSION" \
	--pkgarch="$(dpkg --print-architecture)" \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=libs \
	--pkgsource=mauikit-imagetools-src \
	--pakdir=. \
	--maintainer=uri_herrera@nxos.org \
	--provides=mauikit-imagetools \
	--requires="libc6,libexiv2-28,libkf6coreaddons6,libkf6i18n6,libkf6iconthemes6,libleptonica6,libopencv-core410,libqt6core6t64,libqt6gui6,libqt6positioning6,libqt6positioning6-plugins,libqt6positioningquick6,libqt6qml6,libqt6quick6,libqt6quickcontrols2-6,libqt6quickshapes6,libqt6sql6,libqt6svg6,libqt6svgwidgets6,mauikit \(\>= 4.0.3\),qml6-module-org-kde-kirigami,qml6-module-org-kde-kquickimageeditor,qml6-module-qtquick-controls,qml6-module-qtquick-shapes,qml6-module-qtquick3d-spatialaudio,tesseract-ocr" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
