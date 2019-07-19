#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

BWA_VERSION=0.7.17
SAMTOOLS_VERSION=1.9

ESSENTIALS='pkg-config python3.7 libncurses5-dev'

BUILD_PACKAGES='make csh g++ less libboost-all-dev 
 zlib1g-dev ca-certificates wget unzip bzip2 
 libbz2-dev liblzma-dev libcurl4-gnutls-dev 
 libssl-dev libhts-dev'

BWA_URL=https://github.com/lh3/bwa/releases/download/v${BWA_VERSION}/bwa-${BWA_VERSION}.tar.bz2
SAMTOOLS_URL=https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
METASNV_URL=https://git.embl.de/costea/metaSNV/repository/archive.zip?ref=master
# Install build essentials
apt-get update && apt-get install --no-install-recommends -y ${ESSENTIALS} ${BUILD_PACKAGES}

# Build BWA
wget -q ${BWA_URL} && \
    tar xjf bwa-${BWA_VERSION}.tar.bz2 && \
    cd /bwa-${BWA_VERSION}/ && \
    make && \
    mv /bwa-${BWA_VERSION}/bwa /bin/ && \
    cd / && \
    rm -rf /bwa-${BWA_VERSION}*

# Build SAMtools
wget -q ${SAMTOOLS_URL} && \
    tar xjf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd /samtools-${SAMTOOLS_VERSION}/ && \
    make && \
    mv /samtools-${SAMTOOLS_VERSION}/samtools /bin/ && \
    cd / && \
    rm -rf /samtools-${SAMTOOLS_VERSION}*

# Setup Python3
ln -sf $(which python3.7) /usr/bin/python

# Build metaSNV
wget ${METASNV_URL} -O metaSNV.zip && \
    unzip  metaSNV.zip && \
    mv metaSNV-master-c41d2bae01c8402f0633ba1166959a22d2ac2e0b metaSNV && \
    cd metaSNV && \
    make && \
    cd / && \
    ln -s /metaSNV/metaSNV.py /usr/bin/metaSNV.py && \
    rm -rf /metaSNV.zip 

# Install mOTUs
wget https://github.com/motu-tool/mOTUs_v2/archive/master.zip -O mOTUs.zip && \
    unzip mOTUs.zip && \
    mv mOTUs_v2-master mOTUs && \
    cd mOTUs && \
    #python setup.py && \
    ln -s $(pwd)/motus /usr/local/bin/motus && \
    cd / && \
    rm -rf /mOTUs.zip

# Clean up all files used for building
apt-get autoremove --purge --yes ${BUILD_PACKAGES}

# Ensure that the essential libraries are still installed
apt-get install --no-install-recommends --yes ${ESSENTIALS}

# Switch to python3.7 again
ln -sf $(which python3.7) /usr/bin/python
