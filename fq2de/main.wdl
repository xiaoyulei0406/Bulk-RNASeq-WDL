import "qc.wdl" as qctool
import "hisat2.wdl" as aligntool
import "stringtie.wdl" as expresstool
import "ballgown.wdl" as ballgown
import "deseq2.wdl" as deseq2

workflow RNAflow {
	Array[Array[File]] sample_info
	Array[Array[String]] vs_list
	File hisat2_index
	File ref_fa
	File gtf
	File pheno

	scatter (i in range(length(sample_info))) {
		call qctool.mkdir as mksample {
			input: sampleName=sample_info[i][0]
		}
		call qctool.fastqc as qc1 {
			input: Fq=sample_info[i][1], path=mksample.path
		}
		call qctool.fastqc as qc2 {
			input: Fq=sample_info[i][2], path=mksample.path
		}
		call aligntool.hisat as align {
			input: fq1=sample_info[i][1],fq2=sample_info[i][2],Ref=hisat2_index,sampleName=sample_info[i][0]
		}
		call aligntool.samtobam as sb {
			input: sam=align.sam
		}
		call aligntool.samindex as si {
			input: bam=sb.bam
		}
		call expresstool.stringtie_assemble {
			input: bam=sb.bam,gtf=gtf,sampleName=sample_info[i][0]
		}
	}

	call expresstool.stringtie_merge {
		input: gtfs = stringtie_assemble.gtf, gtf=gtf, name="AllSample"
	}
	call qctool.mkdir as ballgowndir {
		input: sampleName="ballgown"
	}
#	Array[File] sortbams_t =sb_tumor.bam
#	Array[File] sortbams_n =sb_normal.bam

	Array[File] sortbams =sb.bam

	scatter (bam in sortbams) {
		call expresstool.extract as extract {
			input: bam = bam
		}
		call expresstool.StringTieToBallgown as s2bg{
			input: gtf=stringtie_merge.mergedgtf, bam = bam, dir = ballgowndir.path, sampleName=extract.value
		}
	}
	call expresstool.exptocount {
		input: dir=ballgowndir.path, new= s2bg.cov
	}
	call qctool.mkdir as diffdir {
		input: sampleName="Diff_analysis"
	}
	call ballgown.bg_input {
		input: pheno = pheno, dir = ballgowndir.path, outdir = diffdir.path, new=s2bg.cov
	}
	call ballgown.ballgown {
		input: pheno = bg_input.bg_addpath, outdir = diffdir.path, new=s2bg.cov
	}
	call deseq2.deseq2 {
		input: count = exptocount.gene_count, pheno = pheno, outdir = diffdir.path
	}
}
