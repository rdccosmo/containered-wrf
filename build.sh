#!/bin/bash

# set -euo pipefail
IFS=$'\n\t'

install_szip() {
    git clone https://github.com/erdc/szip $PREFIX/szip
    cd $PREFIX/szip
    ./configure --prefix=$PREFIX
    make
    make install
}

install_zlib() {
    git clone https://github.com/madler/zlib $PREFIX/zlib
    cd $PREFIX/zlib
    ./configure --prefix=$PREFIX
    make
    make install
}

install_hdf5() {
    git clone https://github.com/mortenpi/hdf5 $PREFIX/hdf5
    cd $PREFIX/hdf5
    ./configure \
	--prefix=$PREFIX \
	--with-zlib=$PREFIX \
	--with-szip=$PREFIX \
	--enable-fortran \
	--enable-cxx
    make
    make install
}

install_netcdf_c() {
    curl -L -S https://github.com/Unidata/netcdf-c/archive/v4.5.tar.gz -o $PREFIX/netcdf-4.5.tar.gz
    tar zxvf $PREFIX/netcdf-4.5.tar.gz -C $PREFIX
    rm $PREFIX/netcdf-4.5.tar.gz
    mv $PREFIX/netcdf-c-4.5 $PREFIX/netcdf-c
    cd $PREFIX/netcdf-c
    LD_LIBRARY_PATH=$PREFIX/lib CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib ./configure --prefix=$PREFIX --disable-dap --disable-netcdf-4 --disable-shared
    make
    make install
}

install_netcdf_fortran() {
    curl -L -S https://github.com/Unidata/netcdf-fortran/archive/v4.4.4.tar.gz -o $PREFIX/netcdf-fortran-4.4.4.tar.gz
    tar zxvf $PREFIX/netcdf-fortran-4.4.4.tar.gz -C $PREFIX
    rm $PREFIX/netcdf-fortran-4.4.4.tar.gz
    mv $PREFIX/netcdf-fortran-4.4.4 $PREFIX/netcdf-fortran
    cd $PREFIX/netcdf-fortran
    ./configure --prefix=$PREFIX
    make
    make install
}

install_mpich() {
    curl --max-time 900 -L -S http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz -o $PREFIX/mpich-3.2.tar.gz
    tar zxvf $PREFIX/mpich-3.2.tar.gz -C $PREFIX
    rm $PREFIX/mpich-3.2.tar.gz
    mv $PREFIX/mpich-3.2 $PREFIX/mpich
    cd $PREFIX/mpich
    ./configure --prefix=$PREFIX
    make
    make install
}

install_wrf() {
    wget http://www2.mmm.ucar.edu/wrf/src/WRFV3.6.1.TAR.gz -P $PREFIX
    tar -zxvf $PREFIX/WRFV3.6.1.TAR.gz -C $PREFIX
    rm -f $PREFIX/WRFV3.6.1.TAR.gz
    cd $PREFIX/WRFV3
    echo $WRF_CONFIGURE_OPTION | ./configure
    ./compile em_real
}

install_libpng() {
    curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz -o $PREFIX/libpng-1.2.50.tar.gz
    tar -zxvf $PREFIX/libpng-1.2.50.tar.gz -C $PREFIX
    rm $PREFIX/libpng-1.2.50.tar.gz
    cd $PREFIX/libpng-1.2.50
    CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib ./configure --prefix=$PREFIX
    make
    make install
}

install_jasper() {
    curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz -o $PREFIX/jasper-1.900.1.tar.gz
    tar -zxvf $PREFIX/jasper-1.900.1.tar.gz -C $PREFIX
    rm $PREFIX/jasper-1.900.1.tar.gz
    cd $PREFIX/jasper-1.900.1
    ./configure --prefix=$PREFIX
    make
    make install
}

install_wps() {
	wget http://www2.mmm.ucar.edu/wrf/src/WPSV3.7.TAR.gz -P $PREFIX
	tar zxvf $PREFIX/WPSV3.7.TAR.gz -C $PREFIX
	rm $PREFIX/WPSV3.7.TAR.gz
    cd $PREFIX/WPS
    echo 1 | NCARG_ROOT=$PREFIX PATH=$NCARG_ROOT/bin:$PATH NETCDF=$PREFIX JASPERLIB=$PREFIX/lib JASPERINC=$PREFIX/include ./configure
    ./compile
}

install_arwpost() {
    curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz -o $PREFIX/ARWpost_V3.tar.gz
    tar zxvf $PREFIX/ARWpost_V3.tar.gz -C $PREFIX
    rm $PREFIX/ARWpost_V3.tar.gz
    cd $PREFIX/ARWpost
    echo $ARW_CONFIGURE_OPTION | ./configure --prefix=$PREFIX
    sed -i "s/-ffree-form -O/-ffree-form -O -cpp/" configure.arwp
    sed -i "s/-ffixed-form -O/-ffixed-form -O -cpp/" configure.arwp
    sed -i "s/-lnetcdf/-lnetcdff -lnetcdf/" src/Makefile
    ./compile
}

install_g2lib() {
    curl --max-time 900 -L -S http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/g2lib-1.4.0.tar  -o $PREFIX/g2lib-1.4.0.tar
    tar xvf $PREFIX/g2lib-1.4.0.tar -C $PREFIX
    rm $PREFIX/g2lib-1.4.0.tar
    cd $PREFIX/g2lib-1.4.0
    sed -i "s:#.*$::g" makefile
    sed -i "s/DEFS=.*/DEFS=-DLINUX/g" makefile
    sed -i "s/g95/gfortran/g" makefile
    sed -i "s/CC=.*/CC=gcc/g" makefile
    sed -i "s|INCDIR=.*|INCDIR=-I"$PREFIX/include" -I"$PREFIX/include/jasper"|g" makefile
    sed -i "s/ARFLAGS=.*/ARFLAGS=rUv/" makefile
    sed -i "s/-ruv//" makefile
    make
    cp libg2.a $PREFIX/lib
}

install_w3lib() {
    curl --max-time 900 -L -S http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/w3lib-2.0.2.tar  -o $PREFIX/w3lib-2.0.2.tar
    tar xvf $PREFIX/w3lib-2.0.2.tar -C $PREFIX
    rm $PREFIX/w3lib-2.0.2.tar
    cd $PREFIX/w3lib-2.0.2
    sed -i "s:#.*$::g" Makefile
    sed -i "s/g95/gfortran/g" Makefile
    sed -i "s/CC.*= cc/CC = gcc/g" Makefile
    sed -i "s/ARFLAGS =.*/ARFLAGS = rUv/" Makefile
    sed -i "s/-ruv//" Makefile
    make
    cp libw3.a $PREFIX/lib
}

install_cnvgrib() {
    curl --max-time 900 -L -S http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/cnvgrib-1.4.1.tar  -o $PREFIX/cnvgrib-1.4.1.tar
    tar xvf $PREFIX/cnvgrib-1.4.1.tar -C $PREFIX
    rm $PREFIX/cnvgrib-1.4.1.tar
    cd $PREFIX/cnvgrib-1.4.1
    sed -i "s:#.*$::g" makefile
    sed -i "s/g95/gfortran/g" makefile
    sed -i "s|LIBS =.*|LIBS = -L"$PREFIX/lib" -lg2 -lw3 -ljasper -lpng -lz|" makefile
    sed -i "/LIBS =.*/{n;N;N;d}" makefile
    sed -i "s|INC =.*|INC = -I"$PREFIX/include" -I"$PREFIX/g2lib-1.4.0" -I"$PREFIX/include/jasper"|" makefile
    make
}

install_grads() {
    curl --max-time 900 -L -S http://ufpr.dl.sourceforge.net/project/opengrads/grads2/2.0.2.oga.2/Linux/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz  -o $PREFIX/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz
    tar xvf $PREFIX/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz -C $PREFIX
    rm $PREFIX/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz
}

install_pygrads() {
    curl --max-time 900 -L -S https://ufpr.dl.sourceforge.net/project/opengrads/python-grads/1.1.9/pygrads-1.1.9.tar.gz -o $PREFIX/pygrads-1.1.9.tar.gz
    tar zxvf $PREFIX/pygrads-1.1.9.tar.gz -C $PREFIX
    rm $PREFIX/pygrads-1.1.9.tar.gz
    cd $PREFIX/pygrads-1.1.9
    python setup.py install --prefix $PREFIX
}

install_libgeos() {
	curl -L -S https://github.com/OSGeo/geos/archive/3.6.2.tar.gz -o $PREFIX/geos-3.6.2.tar.gz
	tar zxvf $PREFIX/geos-3.6.2.tar.gz -C $PREFIX
	rm $PREFIX/geos-3.6.2.tar.gz
	mv $PREFIX/geos-3.6.2 $PREFIX/geos
    cd $PREFIX/geos
    ./autogen.sh
    ./configure --prefix=$PREFIX
    make
    make install
}

install_anaconda() {
    wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -P $PREFIX
    bash $PREFIX/Anaconda2-4.2.0-Linux-x86_64.sh -b -p $PREFIX/anaconda
    rm $PREFIX/Anaconda2-4.2.0-Linux-x86_64.sh
    $PREFIX/anaconda/bin/conda update -f conda
}

install_pyproj() {
    git clone https://github.com/jswhit/pyproj $PREFIX/pyproj
	cd $PREFIX/pyproj
    # https://stackoverflow.com/questions/15608236/eclipse-and-google-app-engine-importerror-no-module-named-sysconfigdata-nd-u
    # sudo ln -s /usr/lib/python2.7/plat-*/_sysconfigdata_nd.py /usr/lib/python2.7/
    python setup.py build
    python setup.py install --prefix $PREFIX
}

install_basemap() {
    git clone https://github.com/matplotlib/basemap $PREFIX/basemap \
    && cd $PREFIX/basemap \
    && python setup.py install --prefix $PREFIX
}

install_cartopy() {
	git clone https://github.com/SciTools/Cartopy $PREFIX/cartopy
	cd $PREFIX/cartopy
	python setup.py build_ext -I$PREFIX/include -L$PREFIX/lib
	python setup.py install --prefix $PREFIX
}

install_all() {
    install_szip
    install_zlib
    install_hdf5
    install_netcdf_c
    install_netcdf_fortran
    install_mpich
    install_wrf
    install_libpng
    install_jasper
    install_wps
    install_arwpost
    install_g2lib
    install_w3lib
    install_cnvgrib
    install_grads
    install_pygrads
    install_libgeos
    install_anaconda
    install_pyproj
    install_basemap
    install_cartopy
}

if [ ! -d /home/wrf/data ]; then
    mkdir /home/wrf/data
fi

install_all


