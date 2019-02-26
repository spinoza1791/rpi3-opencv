#!/bin/sh -x

V=4.0.1
TESS_INC_DIR=/usr/local/include/tesseract
TESS_LIBRARY=/usr/local/lib/libtesseract.so.4

sudo pip3 install numpy

sudo apt-get install -y \
     build-essential \
     gettext \
     ccache \
     cmake \
     pkg-config \
     libpng-dev \
     libpng++-dev \
     libjpeg-dev \
     libtiff5-dev \
     libjasper-dev \
     libavcodec-dev \
     libavformat-dev \
     libavresample-dev \
     libswresample-dev \
     libavutil-dev \
     libswscale-dev \
     libv4l-dev \
     libxvidcore-dev \
     libx264-dev \
     libgtk-3-dev \
     libgdk-pixbuf2.0-dev \
     libpango1.0-dev \
     libcairo2-dev \
     libfontconfig1-dev \
     libatlas-base-dev \
     liblapack-dev \
     liblapacke-dev \
     libblas-dev \
     libcanberra-gtk* \
     libopenblas-dev \
     gfortran \
     python-pip \
     python3-pip \
     python-numpy \
     python-dev \
     python3-dev \
     libeigen2-dev \
     libeigen3-dev \
     libopenexr-dev \
     libgstreamer1.0-dev \
     libgstreamermm-1.0-dev \
     libgoogle-glog-dev \
     libgflags-dev \
     libprotobuf-c-dev \
     libprotobuf-dev \
     protobuf-c-compiler \
     protobuf-compiler \
     libgphoto2-dev \
     qt5-default \
     libvtk6-dev \
     libvtk6-qt-dev \
     libhdf5-dev \
     freeglut3-dev \
     libgtkglext1-dev \
     libgtkglextmm-x11-1.2-dev \
     libwebp-dev \
     libtbb-dev \
     libdc1394-22-dev \
     libunicap2-dev \
     ffmpeg \
     libopencv-highgui-dev \


git clone --depth=1 -b ${V} --single-branch https://github.com/opencv/opencv.git
git clone --depth=1 -b ${V} --single-branch https://github.com/opencv/opencv_contrib.git
cd opencv
mkdir -p build
cd build

export CXXFLAGS='-mtune=cortex-a53 -march=armv8-a+crc -mcpu=cortex-a53 -mfpu=crypto-neon-fp-armv8'

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_SHARED_LIBS=ON \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_TESTS=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D WITH_EIGEN=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GTK=ON \
      -D WITH_JASPER=ON \
      -D WITH_JPEG=ON \
      -D WITH_OPENEXR=ON \
      -D WITH_PNG=ON \
      -D WITH_TIFF=ON \
      -D WITH_V4L=ON \
      -D WITH_VTK=ON \
      -D WITH_LAPACK=ON \
      -D WITH_LAPACKE=ON \
      -D WITH_PROTOBUF=ON \
      -D WITH_1394=ON \
      -D WITH_EIGEN=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_GPHOTO2=ON \
      -D WITH_QT=ON \
      -D WITH_TBB=ON \
      -D WITH_WEBP=ON \
      -D WITH_UNICAP=ON \
      -D WITH_OPENMP=ON \
      -D WITH_OPENCL=ON \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D ENABLE_CXX11=ON \
      -D ENABLE_CCACHE=ON \
      -D ENABLE_FAST_MATH=ON \
      -D ENABLE_NEON=ON \
      -D ENABLE_VFPV3=ON \
      -D ENABLE_OMIT_FRAME_POINTER=ON \
      -D Tesseract_INCLUDE_DIR=$TESS_INC_DIR \
      -D Tesseract_LIBRARY=$TESS_LIBRARY \
      -D OPENCL_INCLUDE_DIR=/usr/include \
      -D OPENCL_LIBRARY=/usr/lib/arm-linux-gnueabihf/libOpenCL.so \
      .. && make

R=`date "+%Y%m%d"`
GCC_VER=`gcc --version | head -1`

cat << EOF > description-pak
OpenCV for Raspberry Pi with OpenCL features.
Built with $GCC_VER
EOF

export PATH="/usr/lib/gcc/arm-linux-gnueabihf/6:$PATH"

sudo dpkg --purge opencv

sudo -E checkinstall --type=debian \
      --install=no \
      --default \
      --pkgname=opencv \
      --pkgversion=$V \
      --pkgrelease=$R \
      --maintainer=$author \
      --provides=opencv \
      --summary="OpenCV for Raspberry Pi" 




