task hisat{
	File fq1
	File fq2
	File Ref
	String sampleName

	command {
		hisat2 -p 16 -x ${Ref} -1 ${fq1} -2 ${fq2} -S ${sampleName}.sam
	}

	output {
		File sam = "${sampleName}.sam"
	}
	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"3"
		memory:"20GB"
	}
}

task samtobam {
	File sam

	command <<<
		samtools view -bS ${sam} | samtools sort -o ${sam}_sort.bam
		rm ${sam} 
	>>>

	output {
		File bam = "${sam}_sort.bam"
	}

	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"3"
		memory:"10GB"
	}
}

task samindex {
	File bam

	command <<<
		samtools index ${bam} > ${bam}.bai
		samtools flagstat ${bam} > ${bam}.alignment.flagstat
		samtools stats ${bam} > ${bam}.alignment.stat
	>>>

	output {
		File bamindex = "${bam}.bai"
		File flagstat = "${bam}.alignment.flagstat"
		File stat = "${bam}.alignment.stat"
	}

	runtime {
		docker:"aws_tool:2.1.4"
		cpu:"1"
		memory:"10GB"
	}
}

