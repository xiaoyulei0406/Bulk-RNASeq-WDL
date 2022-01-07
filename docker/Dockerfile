FROM rocker/tidyverse:latest
MAINTAINER Chunlei <chunleiyu@1990.gmail>

# System dependencies for required R packages
RUN  rm -f /var/lib/dpkg/available \
  && rm -rf  /var/cache/apt/* \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git

RUN Rscript -e "install.packages(c('devtools','knitr','rmarkdown','shiny','RCurl'), repos = 'https://cran.rstudio.com')"

RUN Rscript -e "source('https://cdn.rawgit.com/road2stat/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('VariantAnnotation','AnnotationHub','org.Hs.eg.db','org.Mm.eg.db','BSgenome.Hsapiens.UCSC.hg19','TxDb.Hsapiens.UCSC.hg19.knownGene','TxDb.Mmusculus.UCSC.mm10.ensGene','optparse','ballgown','genefilter','dplyr','devtools','pheatmap','DESeq2','VSURF','plyr','gplots','cluster','GISTools','glmnet','RColorBrewer'))"

WORKDIR /usr/bin/
ADD ./ballgown.r /usr/bin/
ADD ./deseq2.r /usr/bin/
ADD ./add_ballgownpath.py /usr/bin/

#ENTRYPOINT ["ballgown.r.r"]
CMD ["Rscript", "/usr/bin/ballgown.r"]
CMD ["Rscript", "/usr/bin/deseq2.r"]
CMD ["python","/usr/bin/add_ballgownpath.py"]

# CMD : docker run -v /Users/chunleiyu/Work/data/vcf/CGU_01/:/data/ -t ycl/rnaseq_scripts:v1 Rscript /usr/bin/ballgown.r -p /Users/chunleiyu/Work/data/rnaseq_test/bg_addpath.txt -o /Users/chunleiyu/Work/data/rnaseq_test/de.txt
# CMD : docker run -v /Users/chunleiyu/Work/data/vcf/CGU_01/:/data/ -t ycl/rnaseq_scripts:v1 Rscript /usr/bin/deseq2.r -i /Users/chunleiyu/Work/data/rnaseq_test/gene_read_counts_test.csv -p /Users/chunleiyu/Work/data/rnaseq_test/bg_addpath.txt -o /Users/chunleiyu/Work/data/rnaseq_test/deseq2/