#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

install_szip() {
    determine_prefix $PREFIX
    # if [ ! -f $prefix/Build_WRF/LIBRARIES/szip-2.1.1.tar.gz ]; then
    #     curl --max-time 900 -L -S http://www.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz -o $prefix/Build_WRF/LIBRARIES/szip-2.1.1.tar.gz
    # 	if [ $? -eq 1 ]; then
    # 	    return 1
    # 	fi
    # fi
    # tar zxvf $prefix/Build_WRF/LIBRARIES/szip-2.1.1.tar.gz
    # rm $prefix/Build_WRF/LIBRARIES/szip-2.1.1.tar.gz
    git clone https://github.com/erdc/szip $PREFIX/szip
    cd $PREFIX/szip
    ./configure --prefix=$PREFIX
    make
    make install
}

install_zlib() {
    determine_prefix $PREFIX
    # if [ ! -f $prefix/Build_WRF/LIBRARIES/zlib-1.2.7.tar.gz ]; then
    #     curl -L -S http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz -o $prefix/Build_WRF/LIBRARIES/zlib-1.2.7.tar.gz
    # 	if [ $? -eq 1 ]; then
    # 	    return 1
    # 	fi
    # fi
    # tar xzvf $prefix/Build_WRF/LIBRARIES/zlib-1.2.7.tar.gz
    # rm $prefix/Build_WRF/LIBRARIES/zlib-1.2.7.tar.gz
    # cd zlib-1.2.7
    # ./configure --prefix=$prefix
    # make
    # make install
    # cd
    # if [ ! -d $prefix/zlib ]; then
        git clone https://github.com/madler/zlib $PREFIX/zlib
    # fi
    cd $PREFIX/zlib
    ./configure --prefix=$PREFIX
    make
    make install
}

install_hdf5() {
    determine_prefix $PREFIX
    # if [ ! -f $prefix/Build_WRF/LIBRARIES/hdf5-1.10.1.tar.bz2 ]; then
    #     curl --max-time 900 -L -S https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.1.tar.bz2 -o $prefix/Build_WRF/LIBRARIES/hdf5-1.10.1.tar.bz2
    # 	if [ $? -eq 1 ]; then
    # 	    return 1
    # 	fi
    # fi
    # tar jxvf $prefix/Build_WRF/LIBRARIES/hdf5-1.10.1.tar.bz2
    # rm $prefix/Build_WRF/LIBRARIES/hdf5-1.10.1.tar.bz2
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

install_netcdf() {
    determine_prefix $PREFIX
    # if [ ! -f $prefix/Build_WRF/LIBRARIES/netcdf-4.1.3.tar.gz ]; then
    #     curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz -o $prefix/Build_WRF/LIBRARIES/netcdf-4.1.3.tar.gz
    # 	if [ $? -eq 1 ]; then
    # 	    return 1
    # 	fi
    # fi
    # tar xzvf $prefix/Build_WRF/LIBRARIES/netcdf-4.1.3.tar.gz
    # rm $prefix/Build_WRF/LIBRARIES/netcdf-4.1.3.tar.gz
    # git clone https://github.com/Unidata/netcdf-c $PREFIX/netcdf-c
    curl -L -S https://github.com/Unidata/netcdf-c/archive/v4.4.1.1.tar.gz -o $PREFIX/netcdf-4.4.1.tar.gz
    tar zxvf $PREFIX/netcdf-4.4.1.tar.gz -C $PREFIX
    rm $PREFIX/netcdf-4.4.1.tar.gz
    mv $PREFIX/netcdf-c-4.4.1.1 $PREFIX/netcdf-c
	# git clone https://github.com/Unidata/netcdf-c $PREFIX/netcdf-c \
    cd $PREFIX/netcdf-c
    LD_LIBRARY_PATH=$PREFIX/lib CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib ./configure --prefix=$PREFIX --disable-dap --disable-netcdf-4 --disable-shared
    make
    make install
}

install_mpich() {
    determine_prefix $PREFIX
    if [ ! -f $prefix/mpich-3.1.4.tar.gz ]; then
        curl --max-time 900 -L -S http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz -o $PREFIX/Build_WRF/mpich-2.tar.gz
    	if [ $? -eq 1 ]; then
    	    return 1
    	fi
    fi
    tar zxvf $PREFIX/mpich-3.2.tar.gz -C $PREFIX
    rm $PREFIX/mpich-3.2.tar.gz
    mv $PREFIX/mpich-3.2 $PREFIX/mpich
    cd $PREFIX/mpich
    ./configure --prefix=$PREFIX
    make
    make install
}

install_wrf() {
    determine_prefix $PREFIX
    if [ ! -f $PREFIX/WRFV3.6.1.TAR.gz ]; then
        wget http://www2.mmm.ucar.edu/wrf/src/WRFV3.6.1.TAR.gz -P $PREFIX
    	if [ $? -eq 1 ]; then
    	    return 1
    	fi
    fi
    tar -zxvf $PREFIX/WRFV3.6.1.TAR.gz -C $PREFIX
    rm -f $PREFIX/WRFV3.6.1.TAR.gz
    cd $PREFIX/WRFV3
    echo $WRF_CONFIGURE_OPTION | ./configure
    ./compile em_real
}

install_libpng() {
    determine_prefix $PREFIX
    curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz -o $PREFIX/libpng-1.2.50.tar.gz
    tar -zxvf $PREFIX/libpng-1.2.50.tar.gz -C $PREFIX
    rm $PREFIX/libpng-1.2.50.tar.gz
    cd $PREFIX/libpng-1.2.50
    CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib ./configure --prefix=$PREFIX
    make
    make install
}

install_jasper() {
    determine_prefix $PREFIX
    curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz -o $PREFIX/jasper-1.900.1.tar.gz
    tar -zxvf $PREFIX/jasper-1.900.1.tar.gz -C $PREFIX
    rm $PREFIX/jasper-1.900.1.tar.gz
    cd $PREFIX/jasper-1.900.1
    ./configure --prefix=$PREFIX
    make \
    make install
}

install_wps() {
    determine_prefix $PREFIX
	wget http://www2.mmm.ucar.edu/wrf/src/WPSV3.7.TAR.gz -P $PREFIX
	tar zxvf $PREFIX/WPSV3.7.TAR.gz -C $PREFIX
	rm $PREFIX/WPSV3.7.TAR.gz
    cd $PREFIX/WPS
    echo 1 | NCARG_ROOT=$PREFIX PATH=$NCARG_ROOT/bin:$PATH NETCDF=$PREFIX JASPERLIB=$PREFIX/lib JASPERINC=$PREFIX/include ./configure
    ./compile
}

install_arwpost() {
    determine_prefix
    curl --max-time 900 -L -S http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz -o $PREFIX/ARWpost_V3.tar.gz
    && tar zxvf $PREFIX/ARWpost_V3.tar.gz -C $PREFIX
    && rm $PREFIX/ARWpost_V3.tar.gz
    && cd $PREFIX/ARWpost
    && echo $ARW_CONFIGURE_OPTION | ./configure --prefix=$PREFIX
    && sed -i "s/-ffree-form -O/-ffree-form -O -cpp/" configure.arwp
    && sed -i "s/-ffixed-form -O/-ffixed-form -O -cpp/" configure.arwp
    && sed -i "s/-lnetcdf/-lnetcdff -lnetcdf/" src/Makefile
    && ./compile
}

install_g2lib() {
    determine_prefix $PREFIX
    curl --max-time 900 -L -S http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/g2lib-1.4.0.tar  -o $PREFIX/g2lib-1.4.0.tar
    tar xvf $PREFIX/g2lib-1.4.0.tar
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
    determine_prefix $PREFIX
    curl --max-time 900 -L -S http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/w3lib-2.0.2.tar  -o $PREFIX/w3lib-2.0.2.tar
    tar xvf $PREFIX/w3lib-2.0.2.tar
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
    determine_prefix $PREFIX
    curl --max-time 900 -L -S http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/cnvgrib-1.4.1.tar  -o $PREFIX/cnvgrib-1.4.1.tar
    tar xvf $PREFIX/cnvgrib-1.4.1.tar
    rm $PREFIX/cnvgrib-1.4.1.tar
    cd cnvgrib-1.4.1
    sed -i "s:#.*$::g" makefile
    sed -i "s/g95/gfortran/g" makefile
    sed -i "s|LIBS =.*|LIBS = -L"$PREFIX/lib" -lg2 -lw3 -ljasper -lpng -lz|" makefile
    sed -i "/LIBS =.*/{n;N;N;d}" makefile
    sed -i "s|INC =.*|INC = -I"$PREFIX/include" -I"$PREFIX/g2lib-1.4.0" -I"$PREFIX/include/jasper"|" makefile
    make
}

install_grads() {
    determine_prefix $PREFIX
    curl --max-time 900 -L -S http://ufpr.dl.sourceforge.net/project/opengrads/grads2/2.0.2.oga.2/Linux/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz  -o $PREFIX/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz
    tar xvf $PREFIX/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz
    rm $PREFIX/grads-2.0.2.oga.2-bundle-x86_64-unknown-linux-gnu.tar.gz
}

install_pygrads() {
    determine_prefix $PREFIX
    curl --max-time 900 -L -S https://ufpr.dl.sourceforge.net/project/opengrads/python-grads/1.1.9/pygrads-1.1.9.tar.gz -o $PREFIX/pygrads-1.1.9.tar.gz
    tar zxvf pygrads-1.1.9.tar.gz
    rm $PREFIX/pygrads-1.1.9.tar.gz
    cd $PREFIX/pygrads-1.1.9
    python setup.py install --prefix $PREFIX
}

install_libgeos() {
    determine_prefix $PREFIX
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
    determine_prefix $PREFIX
    wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -P $PREFIX
    bash $PREFIX/Anaconda2-4.2.0-Linux-x86_64.sh -b -p $PREFIX/anaconda
    rm $PREFIX/Anaconda2-4.2.0-Linux-x86_64.sh
    # && echo 'export PATH="~/anaconda/bin:$PATH"' >> $PREFIX/.bashrc
    # && source $PREFIX/.bashrc
    $PREFIX/anaconda/bin/conda update -f conda
}

install_pyproj() {
    determine_prefix $PREFIX
    git clone https://github.com/jswhit/pyproj $PREFIX/pyproj
	cd $PREFIX/pyproj
    # https://stackoverflow.com/questions/15608236/eclipse-and-google-app-engine-importerror-no-module-named-sysconfigdata-nd-u
    # sudo ln -s /usr/lib/python2.7/plat-*/_sysconfigdata_nd.py /usr/lib/python2.7/
    python setup.py build
    python setup.py install --prefix $PREFIX
}

install_basemap() {
    determine_prefix $PREFIX
    git clone https://github.com/matplotlib/basemap $PREFIX/basemap \
    && cd $PREFIX/basemap \
    && python setup.py install --prefix $PREFIX
}

install_catopy() {
    determine_prefix $PREFIX
	git clone https://github.com/SciTools/Cartopy $PREFIX/cartopy
	cd $PREFIX/cartopy
	python setup.py build_ext -I$PREFIX/include -L$PREFIX/lib
	python setup.py install --prefix $PREFIX
}

install_all() {
    install_szip $1
    install_zlib $1
    install_hdf5 $1
    install_netcdf $1
    install_mpich $1
    install_wrf $1
    install_libpng $1
    install_jasper $1
    install_wps $1
    install_arwpost $1
    install_g2lib $1
    install_w3lib $1
    install_cnvgrib $1
    install_grads $1
    install_pygrads
    install_libgeos $1
    install_anaconda $prefix
    install_pyproj $prefix
    install_basemap $prefix
    install_catopy $prefix
}

determine_prefix() {
    export prefix=${1:-$PWD}
}

# wrfinit() {
#     export HOME=/home/wrf
#     determine_prefix $1
#     export PREFIX=$prefix
#     export BUILDDIR=$prefix/Build_WRF
#     export DIR=$prefix
#     export CC=gcc
#     export CXX=g++
#     export CPP="/lib/cpp -P"
#     export FC=gfortran
#     export FCFLAGS=-m64
#     export F77=gfortran
#     export FFLAGS=-m64

#     export PATH=$prefix/bin:$PATH
#     export NETCDF=$prefix
#     ulimit -s unlimited


#     export WRF_CONFIGURE_OPTION=34
#     export WRF_EM_CORE=1
#     export WRF_NMM_CORE=0

#     export LD_LIBRARY_PATH_WRF=$prefix/lib/
#     export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_WRF
#     export NCARG_ROOT=$prefix

#     export ARW_CONFIGURE_OPTION=3

#     export GRADS=$DIR/grads-2.0.2.oga.2/Contents
#     export GRADDIR=$GRADS/Resources/SupportData
#     export GASCRP=$GRADS/Resources/Scripts
#     export PATH=$GRADS:$GRADS/gribmap:$PATH

#     export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
#     export PATH=$prefix/bin:$NCARG_ROOT/bin:$DIR/WRFV3/run:$DIR/WPS:$DIR/ARWpost/:$DIR/cnvgrib-1.4.1:$GRADS:$GRADS/gribmap:$PATH
# }

if [ ! -d /home/wrf/data ]; then
    mkdir /home/wrf/data
fi

prefix=/home/wrf
install_all $prefix

# sed -i "s/geog_data_path = .*/geog_data_path = '\/home\/wrf\/data\/'/" /home/wrf/Build_WRF/LIBRARIES/WPS/namelist.wps

