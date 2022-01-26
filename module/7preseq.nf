nextflow.enable.dsl=2

process preseq {
    tag "preseq $sampleid"
    publishDir "$params.preseq", mode: 'copy'

    input:
    tuple val(sampleid), path(bam)

    output:
    path ("${sampleid}*"), emit: report_preseq

    script:
    """ 
    preseq lc_extrap -v -B $bam -o ${sampleid}.ccurve.txt
    """
}