nextflow.enable.dsl=2

process trim_galore{
    tag "trim_galore $sampleid"
    publishDir "$params.trimed", mode: 'copy'

    input:
    tuple val(sampleid), path(read1), path(read2)

    output:
    tuple val(sampleid), path ("*fq.gz"), emit: reads_trim
    path '*trimming_report.txt', emit: report_trim
    path '*_fastqc.{zip,html}', emit: report_trim_qc 
    //path "v_trim_galore.txt", emit: version//

    script:
    """
    trim_galore --paired --length 25 -q 30 --fastqc -j $task.cpus $read1 $read2 --gzip
    """
}
