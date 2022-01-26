nextflow.enable.dsl=2

params.fc_extra_attributes = 'gene_name'
params.fc_group_features = 'gene_id'
params.fc_count_type = 'exon'
params.strandedness = 0

process featurecount {
    tag "featurecount $sampleid"
    publishDir "$params.featurecount", mode: 'copy'

    input:
    tuple val(sampleid), path (bam)
    path (params.gtf)

    output:
    path ("${sampleid}.featureCounts.txt"), emit: countout
    path "${sampleid}.featureCounts.txt.summary", emit: report_featurecount

    script:
    extraAttributes = params.fc_extra_attributes ? "--extraAttributes ${params.fc_extra_attributes}" : ''
    
    """ 
    featureCounts -a ${params.gtf} -g ${params.fc_group_features} -t ${params.fc_count_type} -s ${params.strandedness} -p -o ${sampleid}.featureCounts.txt $extraAttributes $bam 

    """
}