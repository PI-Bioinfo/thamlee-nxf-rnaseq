nextflow.enable.dsl=2

process rseqc {
    tag "rseqc $sampleid"
    publishDir "$params.rseqc", mode: 'copy'

    input:
    tuple val(sampleid), path (bam)
    tuple val(sampleid), path (bai)
    path (params.bed12)

    output:
    path "${sampleid}*", emit: report_rseqc
    //path "v_rseqc.txt", emit: version

    script:
    """
    read_distribution.py -i $bam -r ${params.bed12} > ${sampleid}.rseqc.read_distribution.txt
    read_duplication.py -i $bam -o ${sampleid}.rseqc.read_duplication
    inner_distance.py -i $bam -o ${sampleid}.rseqc -r ${params.bed12}
    infer_experiment.py -i $bam -r ${params.bed12} -s 2000000 > ${sampleid}.rseqc.infer_experiment.txt
    junction_saturation.py -i $bam -r ${params.bed12} -o ${sampleid}.rseqc
    bam_stat.py -i $bam > ${sampleid}.rseqc.bam_stat.txt
    junction_annotation.py -i $bam  -r ${params.bed12} -o ${sampleid} 2> ${sampleid}.rseqc.junction_annotation_log.txt
    """
}