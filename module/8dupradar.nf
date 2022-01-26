nextflow.enable.dsl=2
params.strandedness = 0

process dupradar {
    tag "dupradar $sampleid"
    publishDir "$params.dupradar", mode: 'copy'

    input:
    tuple val(sampleid), path(bam)
    path (params.gtf)

    output:
    path "*.{txt,pdf}", emit: report_dupradar
    // path "v_dupRadar.txt"

    script:

    """
    dupRadar.r $bam ${params.gtf} ${params.strandedness} paired ${task.cpus}
    Rscript -e "write(x=as.character(packageVersion('dupRadar')))"
    """

}

