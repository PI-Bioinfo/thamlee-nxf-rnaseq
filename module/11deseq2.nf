nextflow.enable.dsl=2

params.deseq2_fdr = 0.05
params.deseq2_lfc = 0.585

process deseq2 {
    tag "deseq2"
    publishDir "$params.deseq2", mode: 'copy'

    input:
    path(merged_counts)
    path (design_csv)
    path (compare_ch)
    
    output:
    path "*.{xlsx,jpg}", emit: download
    path "*_DESeq_results.tsv", emit: results_deseq2
    path "*{heatmap,plot,matrix}.tsv", emit: report_deseq2
    //path "v_DESeq2.txt", emit: version

    script:
    """ 
    DESeq2.r $merged_counts $design_csv $params.deseq2_fdr $params.deseq2_lfc $compare_ch
    Rscript -e "write(x=as.character(packageVersion('DESeq2')))"
    """
}