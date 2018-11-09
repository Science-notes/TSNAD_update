# TSNAD
 
 Neoantigen prediction from WGS or WES.    
   
 Authors: Zhan Zhou, Xingzheng Lyu, Jingcheng Wu.  
 Date: November 2018  
 Version: 1.1  
 License: TSNAD is released under GNU license  

## Introduction  

An integrated software for cancer somatic mutation and tumour-specific neoantigen detection.  

## Requirements
TSNAD uses the following software and libraries:  
  	
1. [Trimmomatic](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip)  
2. [bwa](https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2/download)  
3. [samtools](https://sourceforge.net/projects/samtools/files/latest/download)     
4. [GATK](https://github.com/broadinstitute/gatk/releases/download/4.0.11.0/gatk-4.0.11.0.zip)   
5. [VEP](https://github.com/Ensembl/ensembl-vep/archive/release/94.zip)   
6. [hisat2](http://ccb.jhu.edu/software/hisat2/dl/hisat2-2.1.0-Linux_x86_64.zip)   
7. [stringtie](http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.5.Linux_x86_64.tar.gz)
8. JAVA     
9. Python    
10. Perl   
  
1-6 tools are better put in the folder Tools/.   

## Installation of each module
1. Trimmomatic   

		unzip Trimmomatic-*.zip

2. bwa

		tar -xjvf bwa-*.tar.bz2
		cd bwa-*
		make

3. samtools
	
		sudo apt-get install libncurses5-dev
		sudo apt-get install libbz2-dev
		sudo apt-get install liblzma-dev
		tar -xjvf samtools-*.tar.bz2
		cd samtools-*
		./configure
		make
		sudo make install

4. GATK

		unzip gatk-*.zip
		sudo apt install openjdk-8-jdk-headless
	
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/1000G_phase1.snps.high_confidence.b37.vcf.gz
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/1000G_phase1.snps.high_confidence.b37.vcf.idx.gz
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.idx.gz
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/Mills_and_1000G_gold_standard.indels.b37.vcf.gz
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/Mills_and_1000G_gold_standard.indels.b37.vcf.idx.gz
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.gz  
		wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.fai.gz  
	
	uncompress all the downloaded files
	
5. VEP

		unzip ensembl-vep-release-*.zip
		cd ensembl-vep-release-*
		perl INSTALL.pl
	
	download the API, download the cache 242 *homo_sapiens_merged_vep_94_GRCh37.tar.gz*.
	
	if it is not help, try following step:
		
		cd 
		mkdir src
		cd src
		wget ftp://ftp.ensembl.org/pub/ensembl-api.tar.gz
		wget https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.6.924.tar.gz
		tar -xvf ensembl-api.tar.gz
		tar -xvf BioPerl-1.6.924.tar.gz
		
		PERL5LIB=${PERL5LIB}:${HOME}/src/bioperl-1.6.924
		PERL5LIB=${PERL5LIB}:${HOME}/src/ensembl/modules
		PERL5LIB=${PERL5LIB}:${HOME}/src/ensembl-compara/modules
		PERL5LIB=${PERL5LIB}:${HOME}/src/ensembl-variation/modules
		PERL5LIB=${PERL5LIB}:${HOME}/src/ensembl-funcgen/modules
		export PERL5LIB
		
		sudo perl -MCPAN -e shell
		install Bio::PrimarySeqI
		install DBI
		
6. Hisat

		unzip hisat2-*.zip
		cd hisat2-*
		wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37.tar.gz	

## Usage 
1. configure the file *somatic_mutation_sequencing_parameters.config* ,replace the folder path in your own.
	
		trimmomatic_folder /home/biopharm/Software/tsnad/update/Tools/Trimmomatic-0.38/trimmomatic-0.38.jar
		bwa_folder /home/biopharm/Software/tsnad/update/Tools/bwa-0.7.17/
		samtools_folder /home/biopharm/Software/tsnad/update/Tools/samtools-1.9/
		picardtools_folder /home/biopharm/Software/tsnad/update/Tools/Picardtools/picard.jar
		gatk_folder /home/biopharm/Software/tsnad/update/Tools/gatk-4.0.8.1/gatk-package-4.0.8.1-local.jar
		VEP_folder /home/biopharm/Software/tsnad/update/Tools/ensembl-vep-release-93/
		headcrop 10
		inputs_folder /home/biopharm/TSNAD_update_sample/
		ref_human_folder /home/biopharm/Software/tsnad/update/Tools/gatk-4.0.8.1/hg38/Homo_sapiens_assembly38.fasta
		ref_1000G_folder /home/biopharm/Software/tsnad/update/Tools/gatk-4.0.8.1/hg38/1000G_phase1.snps.high_confidence.hg38.vcf
		ref_Mills_folder /home/biopharm/Software/tsnad/update/Tools/gatk-4.0.8.1/hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf
		ref_dbsnp_folder /home/biopharm/Software/tsnad/update/Tools/gatk-4.0.8.1/hg38/dbsnp_144.hg38_adj.vcf
		outputs_folder /home/biopharm/Software/tsnad/update/results/
		leading 3
		minlen 35
		needRevisedData True
		normal_f 0
		normal_reads 6
		slidingwindow 4:15
		threadNum 6
		trailing 3
		tumor_alt 5
		tumor_f 0.05
		tumor_reads 10
		typeNum 2
		laneNum 1
		partNum 2

then 

	python  somatic_mutation_sequencing_pipeline.py

2. configure the file *antigen_predicting_parameters.config* ,

		A1 02:07
		A2 26:01
		B1 39:01
		B2 50:01
		C1 06:02
		C2 07:02
		Input_file /home/biopharm/Research/NAJ/NAG1606001/output/annovar_results/mutect_call_missenseMutation.txt
		Outputs_folder /home/biopharm/Research/NAJ/NAG1606001/output/netMHCpan_results/
		netMHCpan_folder /home/biopharm/Software/netMHCpan/netMHCpan-2.8/
		peptide_length 8,9,10,11
		strong_binding 150
		weak_binding 500

then 

	python antigen_predicting_pipeline.py

## Update log

### V1.0 
1. GUI for neoantigen prediction  
2. Two parts: one for somatic mutation detection, another for HLA-peptide prediction.

### V1.1
1. Trimmomatic v0.35 -> v0.38  
2. BWA v0.7.12 -> v0.7.17  
3. Samtools v1.3 -> v1.9  
4. Picard v1.140 -> embedded in GATK 
5. GATK v3.5 -> v4.0.11.0  
6. Annovar -> VEP v94  
 

  
 
