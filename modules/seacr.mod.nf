#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/* ========================================================================================
    PROCESSES
======================================================================================== */
process SEACR {

	container 'docker://josousa/seacr:1.3'

	input:
		path(bedgraph)
		val(outputdir)
		val(seacr_args)

	output:
		path "*bed", emit: bed
		
		publishDir "$outputdir/aligned/seacr", mode: "link", overwrite: true

    script:
		/* ==========
			File names, output name, and suffix
		========== */
		if (bedgraph instanceof List) {

			files_command   = bedgraph[0] + " " + bedgraph[1]
			output_name     = bedgraph[0].toString() - ".bedgraph"
			output_suffix   = ""
			seacr_threshold = ""

		} else {

			files_command = bedgraph
			output_name   = bedgraph.toString() - ".bedgraph"

			if (seacr_args =~ /.*\d.*/){
				arr = seacr_args.split(" ", 2)
				seacr_threshold = arr[0]
            	output_suffix = ".FDR_" + arr[0]
			} else {
				seacr_threshold = "0.01"
           		output_suffix = ".FDR_0.01"
			}

		}

		/* ==========
			Normalization
		========== */
        if(!(seacr_args =~ /.*norm.*|.*non.*/)){
            seacr_normalization = "norm"
        } else {
			seacr_normalization = (seacr_args =~ /norm|non/)[0]
		}

		/* ==========
			Mode
		========== */
        if(!(seacr_args =~ /.*relaxed.*|.*stringent.*/)){
            seacr_mode = "stringent"
        } else {
			seacr_mode = (seacr_args =~ /relaxed|stringent/)[0]
		}

		"""
        bash SEACR_1.3.sh ${files_command} ${seacr_threshold} ${seacr_normalization} ${seacr_mode} "${output_name}${output_suffix}"
    	"""
}