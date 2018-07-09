#!/bin/bash -l
#!/usr/bin/env python 



#Building indexes for Hisat2 
#/home/ucbtega/bin/hisat2-2.1.0/hisat2-build --ss C.elegans.WBce1235.ss --exon C.elegans.WBce1235.exon \
#/home/ucbtega/genomes/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa /home/ucbtega/Scratch/Heintz/index/Caenorhabditis_elegans.WBcel235.dna.toplevel



fastqc=/home/ucbtega/bin/FastQC/fastqc
hisat=/home/ucbtega/bin/hisat2-2.1.0/hisat2
samtools=/home/ucbtega/bin/samtools-1.4.1/samtools
trim=/home/ucbtega/bin/Trimmomatic-0.36/Trimmomatic-0.36.jar
stringtie=/home/ucbtega/bin/stringtie-1.3.3b.OSX_x86_64/stringtie


genome=/home/ucbtega/genomes/C.elegans.WBce1235/
gtf=/home/ucbtega/genomes/C.elegans.WBce1235/Caenorhabditis_elegans.WBcel235.89.gtf
gff=/home/ucbtega/genomes/C.elegans.WBce1235/Caenorhabditis_elegans.WBcel235.89.gff3

trim_out=/home/ucbtega/Scratch/Heintz/trim_out/
temp_out=/home/ucbtega/Scratch/Heintz/temp/
hisat2_out=/home/ucbtega/Scratch/Heintz/hisat_out/


for i in D3r1 D3r2 D15r1 D15r2;

do

$hisat --no-softclip --dta-cufflinks --dta -x /home/ucbtega/Scratch/Heintz/index/Caenorhabditis_elegans.WBcel235.dna.toplevel \
        -1 $trim_out/$i/out.$i.forward.paired.fastq \
        -2 $trim_out/$i/out.$i.reverse.paired.fastq -S $hisat2_out/$i/$i.sam 2> $hisat2_out/$i/$i.log

	echo "unmapped reads" > $hisat2_out/$i/$i.stat
	grep "*" $hisat2_out/$i/$i.sam | wc -l	>> $hisat2_out/$i/$i.stat
	echo "mapped in properly paires" >> $hisat2_out/$i/$i.stat
	grep -v '^@' $hisat2_out/$i/$i.sam | awk '$2 == 99 || $2 == 147 || $2 == 163 || $2 == 83' | wc -l >> $hisat2_out/$i/$i.stat
	echo "mapped in properly paires and uniq" >> $hisat2_out/$i/$i.stat
	grep -v '^@' $hisat2_out/$i/$i.sam | awk '$2 == 99 || $2 == 147 || $2 == 163 || $2 == 83' | grep -w NH:i:1 | wc -l >> $hisat2_out/$i/$i.stat
	
	grep -v '^@' $hisat2_out/$i/$i.sam | awk '$2 == 99 || $2 == 147 || $2 == 163 || $2 == 83' | grep -w NH:i:1 | cat ../head.txt - >  $hisat2_out/$i/$i.uniq.sam
	#samtools view -Sb $hisat2_out/$i/$i.uniq.sam > $hisat2_out/$i/$i.uniq.bam
	#samtools sort $hisat2_out/$i/$i.uniq.bam $hisat2_out/$i/$i.uniq.sorted
	#samtools index $hisat2_out/$i/$i.uniq.sorted.bam
	
	#python $dexseq_count -p yes -s no $gff $hisat2_out/$i/$i.uniq.sam $dexseq/$i.txt
	#python $htseq -f bam -s no -m intersection-strict $hisat2_out/$i.bam $gtf > $htseq_out/$i.count.tab
done
vbcbvvbcbsdfsfsdf
s
dfsd