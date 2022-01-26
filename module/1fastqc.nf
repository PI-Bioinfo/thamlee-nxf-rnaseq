nextflow.enable.dsl=2

process fastqc {
    tag "fatsqc $sampleid"
    publishDir "$params.fastqc", mode: 'copy'

    input:
    tuple val(sampleid), path(read1), path(read2)

    output:
    path '*_fastqc.{zip,html}', emit: report_qc
    path 'v_fastqc.txt', emit: version

    script:
    """
    fastqc --version &> v_fastqc.txt
    fastqc --quiet --threads $task.cpus $read1
    fastqc --quiet --threads $task.cpus $read2
    """
}