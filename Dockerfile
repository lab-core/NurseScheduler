# legraina/bcp is built by lab-core/coin (Debian 13, GCC 14 since 2.0)
ARG BASE_IMAGE=legraina/bcp:2.0
FROM ${BASE_IMAGE}

# create a user
RUN useradd -ms /bin/bash dantzig

# Change user
USER dantzig

# Copy sources
COPY --chown=dantzig ./CMakeLists.txt /home/dantzig/ns/CMakeLists.txt
COPY --chown=dantzig ./src/ /home/dantzig/ns/src/
COPY --chown=dantzig ./main/ /home/dantzig/ns/main/

# Set the working directory
WORKDIR /home/dantzig/ns/

## Compile the nurse scheduler
ARG CMAKE_BUILD_TYPE=Release
RUN echo "set(BOOST_DIR /usr/include)" >> CMakeDefinitionsLists.txt && \
    echo "SET(USE_BOOST True)" >> CMakeDefinitionsLists.txt && \
    echo "add_definitions(-DMBCP)" >> CMakeDefinitionsLists.txt && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} .. && \
    make -j4

# Copy everything
COPY --chown=dantzig . /home/dantzig/ns/

# Entrypoint for the nurse scheduler
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "-h" ]
