#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/* ========================================================================================
    PROCESSES
======================================================================================== */
process MACS_CALLPEAK {

	container 'docker://josousa/macs:3.0.1'

	input:
		path(files)
		val(outputdir)
		val(macs_callpeak_args)

	output:
		path "*_peaks.xls",        emit: peaks_xls,				optional: true
		path "*_peaks.narrowPeak", emit: peaks_narrowPeak,		optional: true
		path "*_summits.bed",      emit: summits_bed,			optional: true
		path "*_model.r",          emit: model_r,				optional: true
		path "*_peaks.gappedPeak", emit: peaks_gappedPeak,		optional: true
		path "*_peaks.broadPeak",  emit: peaks_broadPeakPeak,	optional: true
		path "*_pileup.bdg",       emit: pileup_bdg,			optional: true
		path "*_lambda.bdg",       emit: lambda_bdg,			optional: true

		publishDir "$outputdir/aligned/macs", mode: "link", overwrite: true

    script:
		/* ==========
			File names and output name
		========== */
		if (files instanceof List) {
			files_command = "-t " + files[0] + " -c " + files[1]
			output_name   = files[0].toString()[0..<files[0].toString().lastIndexOf('.')]
		} else {
			files_command = "-t " + files
			output_name   = files.toString()[0..<files.toString().lastIndexOf('.')]
		}

		/* ==========
			Effective genome size
		========== */
        def gsize
        if (params.genome == 'GRCh37' || params.genome == 'GRCh38') {
            gsize = 'hs'
        } else if (params.genome == 'GRCm38' || params.genome == 'GRCm39') {
            gsize = 'mm'
        } else if (params.genome == 'WBcel235') {
            gsize = 'ce'
        } else if (params.genome == 'BDGP6') {
            gsize = 'dm'
        } else {
            error "Unsupported genome: ${params.genome}"
        }

		"""
		macs3 callpeak ${files_command} -g ${gsize} -n ${output_name} $macs_callpeak_args
    	"""
}