task deseq2 {
  File outdir
  File count
  File pheno

  command {
	 Rscript  /usr/bin/DESeq2.r  -i ${count} -p ${pheno} -o ${outdir}/
  }
  output {
        File res = "${outdir}/deseq_all.txt"
        File diff = "${outdir}/diff_genes.txt"
        File plot_valcano = "${outdir}/valcano.pdf"
        File plot_ma = "${outdir}/MA_plot.pdf"
        File plot_pca = "${outdir}/pca_plot.pdf"
        File plot_heatmap = "{outdir}/heatmap_plot.pdf"
  }
  runtime{
     docker:"rnaseq_scripts:v1"
     cpu:"1"
     memory:"5GB"
  }
}
