#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    APT_COMMAND="sudo apt"
else
    APT_COMMAND="apt"
fi

BUILD_DEPS='
    appstream
    automake
    autotools-dev
    build-essential
    checkinstall
    cmake
    curl
    devscripts
    equivs
    extra-cmake-modules
    gettext
    git
    gnupg2
    kquickimageeditor-dev
    libexiv2-dev
    libkf6archive-dev
    libkf6config-dev
    libkf6coreaddons-dev
    libkf6filemetadata-dev
    libkf6i18n-dev
    libkf6iconthemes-dev
    libkf6kio-dev
    libleptonica-dev
    libopencv-dev
    libtesseract-dev
    lintian
    qt6-base-dev
    qt6-base-private-dev
    qt6-declarative-dev
    qt6-declarative-private-dev
    qt6-multimedia-dev
    qt6-positioning-dev
    qt6-svg-dev
'

$APT_COMMAND update -q
$APT_COMMAND install -y - --no-install-recommends $BUILD_DEPS
