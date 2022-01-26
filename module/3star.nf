nextflow.enable.dsl=2

process star {
    tag "star $sampleid"
    publishDir "$params.star", mode: 'copy'

    input:
    tuple val(sampleid), path (reads_trim) 
    path ("${params.index}")

    output:
    tuple val(sampleid), path("${sampleid}_Aligned.sortedByCoord.out.bam"), emit: bam
    tuple val(sampleid), path("${sampleid}_Aligned.sortedByCoord.out.bam.{bai,csi}"), emit: bai
    path ("*.out"), emit: report_star
    path ("*Log.final.out"), emit: log
    path "*SJ.out.tab"
    tuple val(sampleid), path("*Unmapped*"), emit: unmapped optional true
    //path "v_star.txt", emit: version//

    script:
    """ 
    STAR --readFilesIn $reads_trim \
    --genomeDir ${params.index} \
    --outFileNamePrefix ${sampleid}_ \
    --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat

    samtools index ${sampleid}_Aligned.sortedByCoord.out.bam
    """
}  