#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/* ========================================================================================
    INPUT FILES
======================================================================================== */
params.input = null

if (!params.input) {
    error "Input not specified. Use --input to specify the input."
}

input_files = file(params.input)


/* ========================================================================================
    OUTPUT DIRECTORY
======================================================================================== */
params.outdir = false
if(params.outdir){
    outdir = params.outdir
} else {
    outdir = '.'
}


/* ========================================================================================
    PARAMETERS
======================================================================================== */
params.genome              = 'GRCm39' // Default genome

params.macs_callpeak_args  = ''
params.seacr_args          = ''
params.peak_caller         = 'macs'


/* ========================================================================================
    MESSAGES
======================================================================================== */
// Validate peak callers
assert params.peak_caller == 'macs' || params.peak_caller == 'seacr' : "Invalid peak caller option: >>${params.peak_caller}<<. Valid options are: 'macs' or 'seacr'\n\n"
println ("Using peak caller: " + params.peak_caller)


/* ========================================================================================
    FILES CHANNEL
======================================================================================== */
include { makeFilesChannel; getFileBaseNames } from './modules/files.mod.nf'

// Loading the design csv file
if(args[0].endsWith('.csv')){

    Channel.fromPath(args)
    	   .splitCsv(header: true, sep: ',')
           .map { row -> [ file(row.treatment, checkIfExists: true), file(row.control, checkIfExists: true) ] }
           .set { files_ch }

} else {

    Channel.fromPath(args)
           .set { files_ch }

}


/* ========================================================================================
    WORKFLOW
======================================================================================== */
if (params.peak_caller == 'macs'){

    include { MACS_CALLPEAK } from './modules/macs.mod.nf' params(genome: genome)

}
else if (params.peak_caller == 'seacr'){

    include { SEACR } from './modules/seacr.mod.nf'
    
}

workflow {

    main:
        if (params.peak_caller == 'macs'){
            MACS_CALLPEAK  (files_ch, outdir, params.macs_callpeak_args)
        }
        else if (params.peak_caller == 'seacr'){
            SEACR          (files_ch, outdir, params.seacr_args)
        }

}
