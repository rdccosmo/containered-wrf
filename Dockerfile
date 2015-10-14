FROM rdccosmo/wrf-netcdf

# 32.  x86_64 Linux, gfortran compiler with gcc   (serial) 
ENV WRF_CONFIGURE_OPTION 32
ENV NETCDF $PREFIX
ENV WRF_EM_CORE 1
ENV WRF_NMM_CORE 0

RUN wget http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz && \
    tar zxvf mpich-3.1.4.tar.gz && \
    rm -f mpich-3.1.4.tar.gz && \
    cd mpich-3.1.4 && \
    ./configure --prefix=$PREFIX && \
    make && \
    make install

RUN wget http://www2.mmm.ucar.edu/wrf/src/WRFV3.6.1.TAR.gz && \
    tar -zxvf WRFV3.6.1.TAR.gz && \
    rm -f WRFV3.6.1.TAR.gz && \
    cd WRFV3 && \
    echo $WRF_CONFIGURE_OPTION | ./configure && \
    ./compile em_real

ENV PATH $PREFIX/bin:$PATH
