FROM ubuntu AS standalone

ARG version=11.100
ARG gemmi_version=0.6.5
ARG openbabel_version=3.1.1
ARG biopython_version=1.83

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
        bison \
        build-essential \
        ca-certificates \
        curl \
        flex \
        tcsh \
        wget \
 && apt-get clean\
 && rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda 

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda update -y conda
RUN conda init
RUN conda create -n arpeggio-env python=3.9
RUN /bin/bash /opt/conda/etc/profile.d/conda.sh && \
    conda init &&\
    activate arpeggio-env && \
    conda install -c main --force-reinstall libarchive  && \
    conda install -c conda-forge gemmi=${gemmi_version} && \
    conda install -c conda-forge openbabel=${openbabel_version} && \ 
    conda install -c conda-forge biopython=${biopython_version} 
RUN pip install pdbe-arpeggio


RUN cd /opt \
 && curl -L https://sw-tools.rcsb.org/apps/MAXIT/maxit-v${version}-prod-src.tar.gz | tar xz

ENV RCSBROOT=/opt/maxit-v${version}-prod-src
ENV PATH=${PATH}:${RCSBROOT}/bin

RUN cd ${RCSBROOT} \
 && make \
 && make binary

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

################################################################################

FROM standalone AS server

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
        openjdk-11-jdk-headless \
        maven \
 && rm -rf /var/lib/apt/lists/*

ARG jar=target/maxit-server-*.jar

COPY ${jar} /maxit-server.jar

CMD ["java", "-jar", "/maxit-server.jar"]
