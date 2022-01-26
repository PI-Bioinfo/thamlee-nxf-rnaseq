nextflow.enable.dsl=2

process picard {
    tag "picard $sampleid"
    publishDir "$params.picard", mode: 'copy'

    input:
    tuple val(sampleid), path (bam) 

    output:
    path ("${sampleid}*"), emit: report_picard

    script:
    """ 
    picard MarkDuplicates \\
        INPUT=$bam \\
        OUTPUT=${sampleid}.markDups.bam \\
        METRICS_FILE=${sampleid}.markDups_metrics.txt \\
        REMOVE_DUPLICATES=false \\
        ASSUME_SORTED=true \\
        PROGRAM_RECORD_ID='null' \\
        VALIDATION_STRINGENCY=LENIENT
    """
}