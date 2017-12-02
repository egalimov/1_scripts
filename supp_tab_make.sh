

cond=cond1
sourcefile=stab.txt
aged=aged1


l1="sample$'\t'f1'\t'f2'\t'condition_norm'\t'condition_long"   #  read with echo -e


########
#Support table name
species="$( bash <<EOF
echo $(grep "species" $sourcefile | awk '{print $2}')
EOF
)"
echo $species 

tissue="$( bash <<EOF
echo $(grep "tissue" $sourcefile | awk '{print $2}')
EOF
)"
echo $tissue 

lib="$( bash <<EOF
echo $(grep "lib" $sourcefile | awk '{print $2}')
EOF
)"
echo $lib 




###   take short name form long file names -- like fish_skin_pe
s1="$( bash <<EOF
echo $(grep "$cond" $sourcefile | awk '{print $2}')
EOF
)"
echo $s1 #| tr ' ' $'\n' | awk 'BEGIN{OFS=","}{$2=$2}2' > mycsvfile.csv

num="$( bash <<EOF
echo $(grep "$cond" $sourcefile | tr '\t' $'\n' | wc -l)
EOF
)"
echo $num #| tr ' ' $'\n' | awk 'BEGIN{OFS=","}{$2=$2}2' > mycsvfile.csv



echo "$(echo "sample")"$'\t'"$(echo "f1")"$'\t'"$(echo "f2")"$'\t'"$(echo "condition_norm")"$'\t'"$(echo "condition_long")" > ${species}_${tissue}_${lib}_support.tab
for i in `seq 2 $num`;
do


s1="$( bash <<EOF
echo $(grep "$cond" $sourcefile | awk -v var="$i" '{print $var}')
EOF
)"
echo $s1

s2="$( bash <<EOF
echo $(grep "^$s1" $sourcefile | awk -F'[/]' '{print $8}')
EOF
)"
echo $s2


s3="$( bash <<EOF
echo $(grep "$aged" $sourcefile | awk -v var="$i" '{print $var}')
EOF
)"
echo $s3

echo "$(echo $(grep "$cond" $sourcefile | awk -v var="$i" '{print $var}'))"$'\t'"$(echo ${s2}.R1.fastq.gz)"$'\t'"$(echo ${s2}.R2.fastq.gz)"$'\t'"$(echo "$s3")"$'\t'"$(echo "NA")" >>${species}_${tissue}_${lib}_support.tab
#echo "$(echo "$(grep "^$s1" $sourcefile)")"$'\t'"$(echo ${s2}_1.fastq.gz)"$'\t'"$(echo ${s2}_1.fastq.gz)"$'\t'"$(echo "$s3")"$'\t'"$(echo "NA")" >>o.txt



done
