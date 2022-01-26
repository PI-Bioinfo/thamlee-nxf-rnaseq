nextflow.enable.dsl=2

process qualimap {
    tag "qualimap $sampleid"
    publishDir "$params.qualimap", mode: 'copy'

    input:
    tuple val(sampleid), path(bam)
    tuple val(sampleid), path(bai)
    path (params.gtf)

    output:
    path "${sampleid}*", emit: report_qualimap
    //path "v_qualimap.txt", emit: version

    script:
    """ 
    qualimap rnaseq -bam $bam -gtf ${params.gtf} -outfile ${sampleid}.pdf

    """
}