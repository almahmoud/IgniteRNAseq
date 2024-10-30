FROM bioconductor/bioconductor_docker:devel

USER rstudio

WORKDIR /home/rstudio

COPY --chown=rstudio:rstudio . /home/rstudio/

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); BiocManager::install(ask=FALSE)" && \
    Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); devtools::install('.', dependencies=TRUE, build_vignettes=TRUE, repos = BiocManager::repositories())" && \
    wget "https://zenodo.org/records/12751214/files/filtered_sorted.bam?download=1" -O filtered_sorted.bam && \
    wget "https://zenodo.org/records/12751214/files/filtered_sorted.bam.bai?download=1" -O filtered_sorted.bam.bai && \
    wget "https://zenodo.org/records/12751214/files/subset_GRCh38.fa.gz?download=1" -O subset_GRCh38.fa.gz && \
    gunzip subset_GRCh38.fa.gz && \
    wget "https://zenodo.org/records/12770737/files/sce_lib10.qs?download=1" -O sce_lib10.qs && \
    wget "https://zenodo.org/records/12770737/files/sce_lib90.qs?download=1" -O sce_lib90.qs && \
    sudo apt-get update && sudo apt-get install -y samtools minimap2 && wget -O- https://github.com/attractivechaos/k8/releases/download/v1.2/k8-1.2.tar.bz2 | tar -jx && \
    sudo ln -s /home/rstudio/k8-1.2/k8-x86_64-Linux /bin/k8 && sudo ln -s /home/rstudio/k8-1.2/k8-x86_64-Linux /home/rstudio/k8 && \
    Rscript -e "basilisk::basiliskRun(env = FLAMES:::flames_env, fun = function(){})"

USER root
