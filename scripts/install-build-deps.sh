#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    APT_COMMAND="sudo apt-get"
else
    APT_COMMAND="apt-get"
fi

$APT_COMMAND update -q
$APT_COMMAND install -qy --no-install-recommends \
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
    kquickimageeditor-dev \
    libleptonica-dev \
    libexiv2-dev \
    libkf5coreaddons-dev \
    libkf5i18n-dev \
    libkf5kio-dev \
    libopencv-dev \
    libtesseract-dev \
    qtbase5-dev \
    qtpositioning5-dev \
