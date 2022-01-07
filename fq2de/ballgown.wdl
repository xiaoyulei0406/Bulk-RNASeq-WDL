task bg_input {
  File pheno
  File dir
  File outdir
  Array[File] new

  command {
    python /usr/bin/add_ballgownpath.py -p ${dir}/ -i ${pheno} -o ${outdir}/bg_addpath.txt
  }
      output {
		 File bg_addpath = "${outdir}/bg_addpath.txt"
  }
  runtime{
     docker:"rnaseq_scripts:v1"
     cpu:"1"
     memory:"5GB"
  }

}
task ballgown {
  File outdir
  File pheno
#  String vs
#  Float logfc
#  Float fdr  
  Array[File] new
  command {
	 Rscript  /usr/bin/ballgown.r -p ${pheno}  -o ${outdir}/
  }
  output {
        File results_transcripts = "${outdir}/de_rt_all.txt"
        File results_genes = "${outdir}/de_rg_all.txt"
        File sig_transcripts = "${outdir}/de_rt_sig.txt"
        File sig_genes = "${outdir}/de_rg_sig.txt"
  }
  runtime{
     docker:"rnaseq_scripts:v1"
     cpu:"1"
     memory:"5GB"
  }
}

