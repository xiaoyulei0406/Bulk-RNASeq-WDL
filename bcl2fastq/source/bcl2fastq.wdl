task bcl2fastq {
	File runfolder
	File samplesheet

	command {
		bcl2fastq --runfolder-dir ${runfolder} \
		--output-dir ./ \
		--sample-sheet ${samplesheet} \
		--ignore-missing-bcls --ignore-missing-filter \
		--ignore-missing-controls --ignore-missing-positions
	}
	runtime{
		docker:"bcl2fastq:latest"
		cpu:"20"
		memory:"50G"
	}
}

workflow b2f {
	File runfolder
	File samplesheet
	call bcl2fastq {
		input: runfolder=runfolder, samplesheet = samplesheet
	}
}
