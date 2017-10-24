FROM ubuntu:latest
MAINTAINER Rodrigo Cosme <rdccosmo@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN \
    apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:ubuntugis/ppa \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated \
        gfortran \
        gfortran-5-multilib \
        csh \
        build-essential \
        libcloog-ppl1 \
        m4 \
        wget \
        ncl-ncarg \
        libgrib2c-dev \
        libjpeg-dev \
        libudunits2-dev \
        python \
        python-pip \
        python-tk \
        python-matplotlib \
        python-matplotlib-data \
        python-imaging \
        python-numpy \
        python-scipy \
        python-systemd \
        libsystemd-dev \
        curl \
        imagemagick \
        libjpeg-dev \
        libopenjpeg-dev \
        libopenjpeg5 \
        libg2-dev \
        libg20 \
        libjasper-dev \
        libjasper1 \
        libx11-6 \
        libxaw7 \
        libmagickwand-dev \
        git \
        autotools-dev \
        autoconf \
        libproj9 \
		libproj-dev \
        proj-bin \
        python-gdal \
        libgdal-dev \
        gdal-bin \
    && rm -rf /var/lib/apt/lists/*

ENV PREFIX /home/wrf
WORKDIR /home/wrf
ENV DEBIAN_FRONTEND noninteractive
ENV CC gcc
ENV CPP /lib/cpp -P
ENV CXX g++
ENV FC gfortran
ENV FCFLAGS -m64
ENV F77 gfortran
ENV FFLAGS -m64
ENV NETCDF $PREFIX
ENV NETCDFPATH $PREFIX
ENV WRF_CONFIGURE_OPTION 34
ENV WRF_EM_CORE 1
ENV WRF_NMM_CORE 0
ENV LD_LIBRARY_PATH_WRF $PREFIX/lib/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH_WRF
ENV NCARG_ROOT=$PREFIX
ENV JASPERLIB=$PREFIX/lib
ENV JASPERINC=$PREFIX/include
ENV GRADS=$PREFIX/grads-2.0.2.oga.2/Contents
ENV GRADDIR=$GRADS/Resources/SupportData
ENV GASCRP=$GRADS/Resources/Scripts
ENV ARW_CONFIGURE_OPTION 3
ENV PYTHONPATH $PREFIX/lib/python2.7/site-packages
ENV PATH $PATH:$PREFIX/bin:$NCARG_ROOT/bin:$GRADS:$GRADS/gribmap:$PREFIX/cnvgrib-1.4.1:$PREFIX/WPS:$PREFIX/WRFV3:$PREFIX/WPS:$PREFIX/AWRpost
RUN mkdir -p /home/wrf && \
    mkdir -p $PYTHONPATH && \
    useradd wrf -d /home/wrf && \
    chown -R wrf:wrf /home/wrf
RUN ulimit -s unlimited
COPY requirements.yml $PREFIX
RUN pip install --upgrade pip pip
RUN pip install --upgrade pip setuptools
RUN pip install -r requirements.yml
COPY build.sh $PREFIX
USER wrf
RUN ./build.sh
COPY scripts $PREFIX
COPY entrypoint.sh $PREFIX
ENTRYPOINT ./entrypoint.sh

VOLUME /home/wrf/data
VOLUME /home/wrf/cron
