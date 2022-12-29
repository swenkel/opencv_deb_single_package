#!/bin/bash

version=4.7.0
sha256_main_source="8df0079cdbe179748a18d44731af62a245a45ebf5085223dc03133954c662973"
sha256_contrib_source="42df840cf9055e59d0e22c249cfb19f04743e1bdad113d31b1573d3934d62584"

echo "Creating build folders"
rm -rf ./build
mkdir -p ./build


echo ""

echo "Downloading and verifying OpenCV sources"
echo "Downloading main OpenCV source"
curl -L -o "./build/opencv_$version.orig.tar.gz" "https://github.com/opencv/opencv/archive/refs/tags/$version.tar.gz"
main_sum=$(sha256sum "./build/opencv_$version.orig.tar.gz" | cut -d ' ' -f 1)
if ! [ "$main_sum" == "$sha256_main_source" ]
then
	echo "OpenCV main source does not match checksum"
	echo "Deleting build folder"
	rm -rf "./build"
	exit 1
fi



echo "Downloading contrib OpenCV source"
curl -L -o "./build/opencv_$version.orig-contrib.tar.gz" "https://github.com/opencv/opencv_contrib/archive/refs/tags/$version.tar.gz"
contrib_sum=$(sha256sum "./build/opencv_$version.orig-contrib.tar.gz" | cut -d ' ' -f 1)
if ! [ "$contrib_sum" == "$sha256_contrib_source" ]
then
	echo "OpenCV contrib source does not match checksum"
	echo "Deleting build folder"
	rm -rf "./build"
	exit 1
fi

echo "Extracting sources"
cd build
tar xf opencv_$version.orig.tar.gz
tar xf opencv_$version.orig-contrib.tar.gz --directory ./opencv-$version/
mv ./opencv-$version/opencv_contrib-$version ./opencv-$version/contrib

echo "Copying build and packaging instructions"
cp -r ../debian ./opencv-$version/

cd ./opencv-$version/
echo "Building package"
fakeroot debian/rules binary

