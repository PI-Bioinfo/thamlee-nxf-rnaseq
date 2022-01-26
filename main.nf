nextflow.enable.dsl=2
/* 
 * RNAseq thamlee
 */

// Channels
                //Channel metadata
                metadata    =   Channel.fromPath(params.csvDir)
                                       .splitCsv(header:true)
                                       .map{ row-> tuple("$row.sampleid"), file("$row.read1"), file("$row.read2")}
                                       .set{sample_ch}
                design_csv  =   Channel.fromPath(params.design)
                compare_ch  =   Channel.fromPath(params.compare)  
                //Channel annotations  
                index_ch    =   Channel.fromPath(params.index)
                                       .collect()
                bed12_ch    =   Channel.fromPath(params.bed12)
                                       .collect() 
                gtf_ch      =   Channel.fromPath(params.gtf)
                                       .collect()   
   

// Load functions

include { fastqc } from ('./module/1fastqc')
include { trim_galore } from ('./module/2trim_galore')
include { star } from ('./module/3star')
include { rseqc } from ('./module/4rseqc')
include { qualimap } from ('./module/5qualimap')
include { picard } from ('./module/6picard')
include { preseq } from ('./module/7preseq')
include { dupradar } from ('./module/8dupradar')
include { featurecount } from ('./module/9featureCounts')
include { merge_featurecount } from ('./module/10merge_featurecount')
include { deseq2 } from ('./module/11deseq2')
include { gprofiler } from ('./module/12gprofiler')
include { multiqc } from ('./module/multiqc')

// Worklow

workflow {
    fastqc(sample_ch)
    trim_galore(sample_ch)
    star(trim_galore.out.reads_trim, index_ch)
    rseqc(star.out.bam ,star.out.bai, bed12_ch)
    qualimap(star.out.bam ,star.out.bai, gtf_ch)
    picard(star.out.bam)
    preseq(star.out.bam)
    dupradar(star.out.bam, gtf_ch)
    featurecount(star.out.bam, gtf_ch)
    merge_featurecount(featurecount.out.countout.collect())
    deseq2(merge_featurecount.out.merged_counts, design_csv, compare_ch)
    gprofiler(deseq2.out.results_deseq2)
    multiqc(fastqc.out.report_qc.collect(), trim_galore.out.report_trim.collect(), trim_galore.out.report_trim_qc.collect(), star.out.report_star.collect(), rseqc.out.report_rseqc.collect(), qualimap.out.report_qualimap.collect(), picard.out.report_picard.collect(), preseq.out.report_preseq.collect(), dupradar.out.report_dupradar.collect(), featurecount.out.report_featurecount.collect(), deseq2.out.report_deseq2.collect(), gprofiler.out.report_gprofiler.collect())
}