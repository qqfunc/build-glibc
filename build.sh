#!/usr/bin/env sh

set -e

GLIBC_VERSION=2.40
GLIBC_URL=https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz
GLIBC_DIR=glibc-$GLIBC_VERSION

download () {
  cd ./build
  wget $GLIBC_URL
  tar -xf "$(basename $GLIBC_URL)"
  rm "$(basename $GLIBC_URL)"
}

while getopts ":t:vd" opt; do
  case $opt in
    t) TARGET=$OPTARG ;;
    v) GLIBC_VERSION=$OPTARG ;;
    d)
      download
      exit 1 ;;
    \?)
      echo "ERROR: Invalid option (-$OPTARG)" >&2
      exit 1 ;;
  esac
done

if [ -z "$TARGET" ]; then
  echo "ERROR: Specify target with -t" >&2
  exit 1
fi

if [ ! -d $GLIBC_DIR ]; then
  download
fi

cd $GLIBC_DIR

./configure --prefix="$PWD/prefix" --target="$TARGET"
make "-j$(nproc)"
make install
