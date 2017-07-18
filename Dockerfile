FROM alpine:3.5
LABEL maintainer "Zac Flamig <zflamig@uchicago.edu>"

RUN apk --no-cache add \
	autoconf \
        automake \
        libtool \
	ca-certificates \
	cairo-dev \
	cmake \
	bison \
        gfortran \
        perl-dev \
	curl \
	expat-dev \
	freetype-dev \
	g++ \
	gcc \
	gd \
	jasper-dev \
	jpeg \
	libstdc++ \
	libx11-dev \
        libxmu-dev \
	libxpm-dev \
        libxaw-dev \
        libxml2-dev \
	m4 \
	make \
	musl-dev \
	ncurses-dev \
	perl \
	readline \
	tiff-dev \
	wget \
	zlib-dev 

RUN apk --no-cache add \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        proj4-dev

# szip
RUN wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz \
        && tar xf szip-2.1.1.tar.gz \
        && cd szip-2.1.1 \
        && ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf szip-2.1.1 szip-2.1.1.tar.gz

# HDF5 Installation
RUN wget https://www.hdfgroup.org/package/bzip2/?wpdmdl=4300 \
        && mv "index.html?wpdmdl=4300" hdf5-1.10.1.tar.bz2 \
        && tar xf hdf5-1.10.1.tar.bz2 \
        && cd hdf5-1.10.1 \
        && ./configure --prefix=/usr --enable-cxx --with-zlib=/usr/include,/usr/lib/x86_64-linux-gnu \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf hdf5-1.10.1 \
        && rm -rf hdf5-1.10.1.tar.bz2 \
	&& export HDF5_DIR=/usr

# NetCDF Installation
RUN wget https://github.com/Unidata/netcdf-c/archive/v4.4.1.1.tar.gz \
        && tar xf v4.4.1.1.tar.gz \
        && cd netcdf-c-4.4.1.1 \
        && ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf netcdf-c-4.4.1.1 \
        && rm -rf v4.4.1.1.tar.gz

WORKDIR /grads
RUN wget ftp://cola.gmu.edu/grads/2.1/grads-2.1.1.b0-src.tar.gz \
	&& tar xf grads-2.1.1.b0-src.tar.gz

# Readline Installation
RUN wget http://git.savannah.gnu.org/cgit/readline.git/snapshot/readline-master.tar.gz \
	&& tar xf readline-master.tar.gz \
	&& cd readline-master \
	&& ./configure --prefix=/usr \
	&& make -j4 \
	&& make install \
	&& cd .. \
	&& rm -rf readline-master \
	&& rm -rf readline-master.tar.gz

# Geotiff
RUN wget http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.2.tar.gz \
	&& tar xf libgeotiff-1.4.2.tar.gz \
	&& cd libgeotiff-1.4.2 \
	&& ./configure --prefix=/usr \
        && make -j4 \
        && make install \
        && cd .. \
        && rm -rf libgeotiff-1.4.2.tar.gz libgeotiff-1.4.2

# udunits
RUN wget ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-1.12.11.tar.gz \
	&& tar xf udunits-1.12.11.tar.gz \
	&& cd udunits-1.12.11/src \
	&& export CPPFLAGS="-Df2cFortran -fPIC" \
	&& ./configure --prefix=/usr \
        && make \
        && make install \
        && cd ../.. \
        && rm -rf udunits-1.12.11 udunits-1.12.11.tar.gz

RUN wget http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/g2clib-1.6.0.tar \
	&& tar xf g2clib-1.6.0.tar \
	&& cd g2clib-1.6.0 \
	&& make \
	&& cp libg2c_v1.6.0.a /usr/lib/libgrib2c.a \
	&& cp grib2.h /usr/include \
	&& cd .. \
	&& rm -rf g2clib-1.6.0 g2clib-1.6.0.tar

RUN wget ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng12/libpng-1.2.57.tar.gz \
	&& tar xf libpng-1.2.57.tar.gz \
	&& cd libpng-1.2.57 \
	&& ./configure --prefix=/usr \
	&& make \
        && make install \
        && ls -al \
        && cd .. \
        && rm -rf libpng-1.2.57 libpng-1.2.57.tar.gz

RUN wget https://github.com/libgd/libgd/archive/gd-2.2.4.tar.gz \
	&& tar xf gd-2.2.4.tar.gz \
	&& cd libgd-gd-2.2.4 \
	&& ls -al \
	&& ./bootstrap.sh \
	&& ./configure --prefix=/usr \
        && make \
        && make install \
        && ls -al \
        && cd .. \
        && rm -rf libgd-gd-2.2.4.tar.gz gd-2.2.4

RUN wget ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng15/libpng-1.5.28.tar.gz \
        && tar xf libpng-1.5.28.tar.gz \
        && cd libpng-1.5.28 \
        && ./configure --prefix=/usr \
        && make \
        && make install \
        && ls -al \
        && cd .. \
        && rm -rf libpng-1.5.28 libpng-1.5.28.tar.gz

RUN export SUPPLIBS=$HOME/supplibs && mkdir -p $HOME/supplibs/lib && mkdir -p $HOME/supplibs/include \
	&& ln -sf /lib/* $HOME/supplibs/lib/. \
	&& ln -sf /include/* $HOME/supplibs/include/. \
	&& ln -sf /usr/lib/* $HOME/supplibs/lib/. \
        && ln -sf /usr/include/* $HOME/supplibs/include/. \
	&& ls -al $HOME/supplibs/ && cd grads-2.1.1.b0 \
	&& ls -al /root/supplibs/lib/ \
	&& sed -i.bak -e "s/SET_LIB_VAR/SET_DYNLIB_VAR/g" configure.ac \
	&& autoreconf -i \
	&& ./configure \
	&& make \
	&& make install


CMD /bin/sh
