task stringtie_assemble {
	File gtf
	File bam
	String sampleName

	command {
		stringtie -p 10 -G ${gtf} ${bam} -o ${sampleName}.gtf -C ${sampleName}.cov -A  ${sampleName}.tab
	}

	output {
		File gtf = "${sampleName}.gtf"
	}

	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"1"
		memory:"5GB"
	}
	meta {
		author: "Chunlei Yu. This task is for assembling transcripts from sorted bams."
	}
}

task gtfs_combine {
	Array[File] gtfs_t
	Array[File] gtfs_n

	command {
		echo "${sep=' ' gtfs_t} ${sep=' ' gtfs_n}" > gtfs
	}
	
	output {
		File gtfs = "gtfs"
	}
}

task bam_combine {
	Array[File] sortbams_t
	Array[File] sortbams_n

	command {
		echo "${sep=' ' sortbams_t} ${sep=' ' sortbams_n}" > bams
	}
	
	output {
		File bams = "bams"
	}
}

task stringtie_merge {
	Array[File] gtfs
	File gtf
	String name

	command {
		
		stringtie --merge -o ${name}_merge.gtf -p 8 -G ${gtf}  ${sep=' ' gtfs}
	}

	output {
		File mergedgtf = "${name}_merge.gtf"
	}

	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"1"
		memory:"5GB"
	}
	meta {
		author: "Chunlei Yu. This task is for merging transcript files."
	}
}

task extract {
	File bam

	command {
		basename ${bam} | cut -d '.' -f 1
	}

	output {
		String value = read_string(stdout())
	}
}

task StringTieToBallgown  {
	File gtf
	File bam
	File dir
	String sampleName

	command {
		stringtie -e -p 8 -G ${gtf} -b ${dir}/${sampleName} -o ${dir}/${sampleName}/${sampleName}.gtf ${bam} -C ${sampleName}.express.cov
	}

	output {
#		File gtf ="${dir}/${sampleName}/${sampleName}.gtf"
		File ballgown="${dir}/${sampleName}"
		File cov="${sampleName}.cov"
	}

	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"1"
		memory:"5GB"
	}

	meta {
		author: "Chunlei Yu. This task is for processing results for ballgown inputs."
	}
}

task exptocount {

  File dir
	Array[File]  new

  command {
	 prepDE.py -i ${dir}  -g  ${dir}/gene_count_matrix.csv  -t  ${dir}/transcript_count_matrix.csv
  }
  output {
        File gene_count = "${dir}/gene_count_matrix.csv"
        File trans_count = "${dir}/transcript_count_matrix.csv"
  }
  runtime{
     docker:"mrna:latest"
     cpu:"1"
     memory:"5GB"
  }
}

task gffcompare {
	File gtf
	File merge_gtf
	String sampleName

	command {
		gffcompare -r ${gtf} -o ${sampleName}.annotated.gtf ${merge_gtf}
	}

	output {
		File gtf = "${sampleName}.annotated.gtf"
	}

	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"1"
		memory:"5GB"
	}
	meta {
		author: "Chunlei Yu. This task is for estimating abundance, comparing transcripts between merged and reference."
	}
}
