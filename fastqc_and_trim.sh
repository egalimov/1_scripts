#!/bin/bash

######
#  Determine working folder

output1="$( bash <<EOF
echo $(pwd )
EOF
)"
echo $output1
folder=$output1


######
#  Determine what is the computer

cd /Users

output2="$( bash <<EOF
echo $(ls -d evgen* )
EOF
)"
echo $output2


case  $output2  in
                evgenigalimov)       
     		    echo "work"
     		    fastqc=/Users/evgenigalimov/Dropbox/21_Bioinf/bin/FastQC/fastqc
				trim=/Users/evgenigalimov/Dropbox/21_Bioinf/bin/Trimmomatic-0.36/trimmomatic-0.36.jar
				trimadapter=/Users/evgenigalimov/Dropbox/21_Bioinf/bin/Trimmomatic-0.36/adapters/adapters.fa
				trim_out=$folder/trim
                    ;;

                evgeniygalimov)       
     		    echo "home"
     		    fastqc=/Users/evgeniygalimov/Dropbox/21_Bioinf/bin/FastQC/fastqc
				trim=/Users/evgeniygalimov/Dropbox/21_Bioinf/bin/Trimmomatic-0.36/trimmomatic-0.36.jar
				trimadapter=/Users/evgeniygalimov/Dropbox/21_Bioinf/bin/Trimmomatic-0.36/adapters/adapters.fa
				trim_out=$folder/trim
                    ;;
esac

cd $folder
##########
# take file names
output="$( bash <<EOF
echo $(ls SRR* | awk -F'[_.]' '{print $1}' | uniq | awk 'BEGIN { ORS = " " } { print } ')
EOF
)"
names=$output



##########
# make folders
cd $folder
mkdir trim
mkdir rep

cd ./trim
mkdir rep2
mkdir t1
mkdir t2
cd ./rep2
mkdir t1
mkdir t2

cd $folder


##########
#  determine PE or SE

output="$( bash <<EOF
echo $(ls SRR* | awk -F'[_.]' '{print $2}' | head -n 1)
EOF
)"
a=$output


case  $output  in
                fastq)       
     		    echo "SE"

     		    for i in $names;
     		    do

     		    $fastqc $i.fastq.gz -o $folder/rep

     		    java -jar $trim SE ${i}.fastq.gz $trim_out/t1/${i}.t1.fastq.gz \
     		    ILLUMINACLIP:$trimadapter:2:30:10 AVGQUAL:28 TRAILING:20 MINLEN:50	

     		    java -jar $trim SE $trim_out//t1/${i}.t1.fastq.gz $trim_out/t2/${i}.t2.fastq.gz HEADCROP:5
                   done

     		    for i in $names;
     		    do

     		    $fastqc $trim_out/t1/${i}.t1.fastq.gz -o $trim_out/rep2/t1
     		    $fastqc $trim_out/t2/${i}.t2.fastq.gz -o $trim_out/rep2/t2

     		    done
                    ;;


                [1-2]*)       
     		    echo "PE"

     		    for i in $names;

     		    do

     		    $fastqc ${i}_1.fastq.gz -o $folder/rep
     		    $fastqc ${i}_2.fastq.gz -o $folder/rep

     		    java -jar $trim PE  ${i}_1.fastq.gz ${i}_2.fastq.gz \
     		    $trim_out/t1/$i.forward.paired.fastq $trim_out/t1/$i.forward.unpaired.fastq \
     		    $trim_out/t1/$i.reverse.paired.fastq $trim_out/t1/$i.reverse.unpaired.fastq \
     		    ILLUMINACLIP:$trimadapter:2:30:10 AVGQUAL:30 TRAILING:20 MINLEN:50

     		    java -jar $trim SE $trim_out/t1/$i.forward.paired.fastq $trim_out/t2/$i.forward.t2.paired.fastq HEADCROP:5
     		    java -jar $trim SE $trim_out/t1/$i.reverse.paired.fastq $trim_out/t2/$i.reverse.t2.paired.fastq HEADCROP:5

     		    done

     		    #cd $folder/trim

     		    for i in $names;

     		    do

     		    $fastqc $trim SE $trim_out/t1/$i.forward.paired.fastq -o $trim_out/rep2
     		    $fastqc $trim SE $trim_out/t1/$i.reverse.paired.fastq -o $trim_out/rep2
     		    $fastqc $trim SE $trim_out/t2/$i.forward.t2.paired.fastq -o $trim_out/rep2
     		    $fastqc $trim SE $trim_out/t2/$i.reverse.t2.paired.fastq -o $trim_out/rep2

     		    done	

                    ;;
esac











