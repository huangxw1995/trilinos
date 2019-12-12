FROM peridigm/netcdf

MAINTAINER John T. Foster <johntfosterjr@gmail.com>

ENV HOME /root

RUN apt-get -yq install gfortran \
                        python \ 
                        libblas-dev \
                        liblapack-dev \
                        libboost-dev \
                        cmake  \
                        git \
                        libyaml-cpp0.5 \
                        libyaml-cpp-dev

#Build Trilinos
RUN git clone https://github.com/trilinos/Trilinos.git trilinos; \
    mkdir trilinos/build

WORKDIR trilinos/build
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/trilinos/ \
          -DMPI_BASE_DIR:PATH=/usr \
          -DCMAKE_BUILD_TYPE:STRING=Release \
          -DCMAKE_CXX_FLAGS:STRING="-Wno-unused -std=c++11" \
          -DCMAKE_Fortran_COMPILER:STRING="mpif90" \
          -DBUILD_SHARED_LIBS:BOOL=OFF \
          -DTrilinos_WARNINGS_AS_ERRORS_FLAGS:STRING="" \
          -DTrilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
          -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
          -DTrilinos_ENABLE_ALL_FORWARD_DEP_PACKAGES:BOOL=OFF \
          -DTrilinos_ENABLE_Teuchos:BOOL=ON \
          -DTrilinos_ENABLE_Shards:BOOL=ON \
          -DTrilinos_ENABLE_Sacado:BOOL=ON \
          -DTrilinos_ENABLE_Epetra:BOOL=ON \
          -DTrilinos_ENABLE_EpetraExt:BOOL=ON \
          -DTrilinos_ENABLE_Ifpack:BOOL=ON \
          -DTrilinos_ENABLE_AztecOO:BOOL=ON \
          -DTrilinos_ENABLE_Belos:BOOL=ON \
          -DTrilinos_ENABLE_Phalanx:BOOL=ON \
          -DPhalanx_EXPLICIT_TEMPLATE_INSTANTIATION:BOOL=ON \
          -DTrilinos_ENABLE_Zoltan:BOOL=ON \
          -DTrilinos_ENABLE_SEACAS:BOOL=ON \
          -DTrilinos_ENABLE_NOX:BOOL=ON \
          -DTrilinos_ENABLE_Pamgen:BOOL=ON \
          -DTrilinos_ENABLE_SEACASPLT=OFF \
          -DTrilinos_ENABLE_SEACASBlot=OFF \
          -DTrilinos_ENABLE_SEACASFastq=OFF \
          -DTrilinos_ENABLE_EXAMPLES:BOOL=OFF \
          -DTrilinos_ENABLE_TESTS:BOOL=OFF \
          -DTPL_ENABLE_MATLAB:BOOL=OFF \
          -DTPL_ENABLE_Matio:BOOL=OFF \
          -DTPL_ENABLE_Netcdf:BOOL=ON \
          -DNetcdf_INCLUDE_DIRS:PATH=/usr/local/netcdf/include \
          -DNetcdf_LIBRARY_DIRS:PATH=/usr/local/netcdf/lib \
          -DTPL_ENABLE_MPI:BOOL=ON \
          -DTPL_ENABLE_BLAS:BOOL=ON \
          -DTPL_ENABLE_LAPACK:BOOL=ON \
          -DTPL_ENABLE_Boost:BOOL=ON \
          -DTPL_Boost_INCLUDE_DIRS:PATH=/usr/include/boost \
          -DTPL_ENABLE_QT:BOOL=OFF \
          -DTPL_ENABLE_X11:BOOL=OFF \
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF \
          -DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF \
          -DTrilinos_ENABLE_MueLu:BOOL=ON \
          -DTeuchosCore_ENABLE_yaml-cpp:BOOL=ON \
          -DTPL_ENABLE_yaml-cpp:BOOL=ON \
          -Dyaml-cpp_INCLUDE_DIRS:PATH=/usr/include/yaml-cpp \
          -DTPL_yaml-cpp_LIBRARIES:FILEPATH=/usr/lib/x86_64-linux-gnu/libyaml-cpp.so.0.5 \
          ..

RUN make -j8 && make install
WORKDIR /
RUN rm -rf trilinos

