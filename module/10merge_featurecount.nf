nextflow.enable.dsl=2

params.bam_suffix = "_Aligned.sortedByCoord.out.bam"

process merge_featurecount {
    tag "merge_featurecount"
    publishDir "$params.merge_featurecount", mode: 'copy'

    input:
    path (countout)

    output:
    path 'merged_gene_counts.txt', emit: merged_counts
    path 'gene_lengths.txt', emit: gene_lengths

    script:
    gene_ids = "<(tail -n +2 ${countout[0]} | cut -f1,7 )"
    counts_bam = countout.collect{filename ->
    // Remove first line and take 8th column (counts)
    "<(tail -n +2 ${filename} | sed 's:${params.bam_suffix}::' | cut -f8)"}.join(" ")

    """
    paste $gene_ids $counts_bam > merged_gene_counts.txt
    tail -n +2 ${countout[0]} | cut -f1,6 > gene_lengths.txt
    """
}