FROM ubuntu:latest

RUN apt update -y && apt upgrade -y
RUN apt-get install -y wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install tzdata

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y autoconf automake autotools-dev libtool pkg-config
RUN apt-get install -y build-essential checkinstall \
             libx11-dev libxext-dev zlib1g-dev libpng-dev \
             libjpeg-dev libfreetype6-dev libxml2-dev

RUN wget http://www.fftw.org/fftw-3.3.10.tar.gz && \
	tar -zxvf fftw-3.3.10.tar.gz && \
	cd fftw-3.3.10 && \
	./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --enable-threads \
            --enable-sse2    \
            --enable-avx     && make && make install

RUN wget https://download.imagemagick.org/ImageMagick/download/ImageMagick-7.1.0-8.tar.gz && \
	tar -zxvf ImageMagick-7.1.0-8.tar.gz && cd ImageMagick-7.1.0-8 && \
	./configure --with-fftw && make && make install && ldconfig /usr/local/lib
