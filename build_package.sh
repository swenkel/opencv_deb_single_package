#!/bin/bash

version=4.6.0
sha256_main_source="1ec1cba65f9f20fe5a41fda1586e01c70ea0c9a6d7b67c9e13edf0cfe2239277"
sha256_contrib_source="1777d5fd2b59029cf537e5fd6f8aa68d707075822f90bde683fcde086f85f7a7"

echo "Creating build folders"
rm -rf ./build
mkdir -p ./build


echo ""

echo "Downloading and verifying OpenCV sources"
echo "Downloading main OpenCV source"
curl -L -o "./build/opencv_$version.orig.tar.gz" "https://github.com/opencv/opencv/archive/refs/tags/4.6.0.tar.gz"
main_sum=$(sha256sum "./build/opencv_$version.orig.tar.gz" | cut -d ' ' -f 1)
if ! [ "$main_sum" == "$sha256_main_source" ]
then
	echo "OpenCV main source does not match checksum"
	echo "Deleting build folder"
	rm -rf "./build"
	exit 1
fi



echo "Downloading contrib OpenCV source"
curl -L -o "./build/opencv_$version.orig-contrib.tar.gz" "https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.tar.gz"
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

