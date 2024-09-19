# Peak Calling Pipeline

<img width="30%" src="https://raw.githubusercontent.com/nextflow-io/trademark/master/nextflow-logo-bg-light.png" />
<img width="30%" src="https://tower.nf/assets/nf-tower-black.svg" />

A Nextflow pipeline to perform peak calling of ChIP-seq, ATAC-seq or CUT&Tag sequencing data.

>The pipeline was created to run on the [ETH Euler cluster](https://scicomp.ethz.ch/wiki/Euler) and it relies on the server's genome files. Thus, the pipeline needs to be adapted before running it in a different HPC cluster.


## Pipeline steps
1. [MACS callpeak](https://macs3-project.github.io/MACS/docs/callpeak.html)
2. [SEACR](https://github.com/FredHutch/SEACR) _[Optional]_


## Required parameters

**[Peak calling without control samples]**

List of input files in BAM/BED/BedGraph format or other format
required by the peak caller, e.g. '*.bam' or '*.bedgraph'.

``` bash
--input /cluster/work/nme/data/josousa/project/*.bam
```

or

**[Peak calling with control samples]**

A CSV file with the names of the treatment and control files in
BAM/BED/BedGraph format or other format required by the peak caller, e.g. 'design.csv'.

``` bash
--input /cluster/work/nme/data/josousa/project/design.csv

# The CSV file should have the following format:
treatment,control
/cluster/work/nme/data/josousa/project/SEQ01_H3K27me3_rep1.bam,/cluster/work/nme/data/josousa/project/SEQ01_input_rep1.bam
/cluster/work/nme/data/josousa/project/SEQ01_H3K27me3_rep2.bam,/cluster/work/nme/data/josousa/project/SEQ01_input_rep2.bam
/cluster/work/nme/data/josousa/project/SEQ01_H3K27me3_rep3.bam,/cluster/work/nme/data/josousa/project/SEQ01_input_rep3.bam
```

Output directory where the files will be saved.

``` bash
--outdir /cluster/work/nme/data/josousa/project
```


## Genomes
- Reference genome used during alignment. This will provide MACS with the appropriate genome size.

    ```bash
    --genome 'GRCm39'
    ```

    Available genomes:
    ``` bash
        GRCm39 # Default
        GRCm38
        GRCh38
        GRCh37 
        BDGP6
        WBcel235
    ```


## Peak caller optional parameters

- Peak calling tool.
    ```bash
    --peak_caller 'macs' # Default

    # or

    --peak_caller 'seacr'
    ```


## Extra arguments
- Option to add extra arguments to [MACS callpeak](https://macs3-project.github.io/MACS/docs/callpeak.html).
`--macs_callpeak_args`

- Option to add extra arguments to [SEACR](https://github.com/FredHutch/SEACR).
`--seacr_args`


## Acknowledgements
This pipeline was adapted from the Nextflow pipelines created by the [Babraham Institute Bioinformatics Group](https://github.com/s-andrews/nextflow_pipelines) and from the [nf-core](https://nf-co.re/) pipelines. We thank all the contributors for both projects. We also thank the [Nextflow community](https://nextflow.slack.com/join) and the [nf-core community](https://nf-co.re/join) for all the help and support.
