#######
# take_fdr_0.05.sh

#######
# limit file names for analyses
startnames="171103*"

#######
# set the fdr level
fdrlevel=0.01

###   take short name form long file names -- like fish_skin_pe
names="$( bash <<EOF
echo $(ls $startnames | awk -F'[_]' '{print $2}' | uniq | awk 'BEGIN { ORS = " " } { print } ')
EOF
)"

for i in $names;
do

###   take long name using short name
longnames="$( bash <<EOF
echo $(ls *$i* | awk '{print $1}' | uniq | awk 'BEGIN { ORS = " " } { print } ')
EOF
)"

###   take number of the column named "FDR"
fdr="$( bash <<EOF
echo $(head -1 $longnames | tr -s '\t' '\n' | nl -nln | grep "FDR" | cut -f1)
EOF
)"

###   take number of the column named "ensemblName"
ensemble="$( bash <<EOF
echo $(head -1 $longnames | tr -s '\t' '\n' | nl -nln | grep "ensemblName" | cut -f1)
EOF
)"

###   take number of the column named "eventID"
eventID="$( bash <<EOF
echo $(head -1 $longnames | tr -s '\t' '\n' | nl -nln | grep "eventID" | cut -f1)
EOF
)"

echo $names
echo $longnames
echo $fdr
echo $ensemble
echo $eventID


# take all lines with FDR < fdrlevel   -> sort by ensemble name -> then by FDR
awk -F "\t" -v var="$fdr" -v varr="$fdrlevel" '$var < varr { print } ' $longnames \
| sort -t$'\t' -k$ensemble,$ensemble -k$fdr,$fdr -n >$names.fdr.$fdrlevel.tab

# $names.fdr.$fdrlevel.tab    length parameteres
lengthRow=$(awk -F "\t" '{ print $1}' $names.fdr.$fdrlevel.tab | wc -l)
echo "lengthRow=$lengthRow"
lengthCol=$(head -1 mouse..skin..se.fdr.0.01.tab | tr -s '\t' '\n' | nl -nln | wc -l)
echo "lengthCol=$lengthCol"




#######################################################################################################
#######################################################################################################
####################
########## assessing the strength of the changes

########
# take prefice for young group

NumCond="$( bash <<EOF
echo $(head -1 $names.fdr.$fdrlevel.tab | tr -s '\t' '\n' | awk '/psi"$/' | wc -l)  
EOF
)"
echo $NumCond

Pos="$( bash <<EOF
echo $(head -1 $names.fdr.$fdrlevel.tab | tr -s '\t' '\n' | nl -nln | awk '/psi"$/' | head -1 | awk '{print $1}')  
EOF
)"
echo $Pos

preYoung="$( bash <<EOF
echo $(head -1 $names.fdr.$fdrlevel.tab | tr -s '\t' '\n' | awk '/psi"$/' | head -1 | sed -e 's/\"//g' | sed 's/.\{6\}$//')  
EOF
)"
echo $preYoung

##number of young group
aaa=$(head -1 $names.fdr.$fdrlevel.tab | sed -e 's/\"//g' ) 
preYoungN=$(echo $aaa | tr -s ' ' '\n' | awk "/$preYoung/ && /psi/" | wc -l)
echo $preYoungN

# take prefice for old group
preOld="$( bash <<EOF
echo $(head -1 $names.fdr.$fdrlevel.tab | tr -s '\t' '\n' | awk '/psi"$/' | tail -1 | sed -e 's/\"//g' | sed 's/.\{6\}$//')
EOF
)"
echo $preOld

##number of young group
bbb=$(head -1 $names.fdr.$fdrlevel.tab | sed -e 's/\"//g' ) 
preOldN=$(echo $bbb | tr -s ' ' '\n' | awk "/$preOld/ && /psi/" | wc -l)
echo $preOldN

done


###############
# Calclulatong the strength of the effect

yyy=0
zzz=0
zzz1=0

endY=$(($Pos+$preYoungN-1))
startO=$(($Pos+$preYoungN))
endO=$(($Pos+$preYoungN+$preOldN-1))
echo "ysum">ysum.txt
echo "osum">osum.txt
echo "diff">dif.txt
for j in `seq 2 $lengthRow`;
do
	zzz=0
	zzz1=0
		for i in `seq $Pos $endY`;
		        do
					# echo $Pos
					# echo $endY

					yyy=$(awk -v i=$i -v j=$j 'FNR == j {print $i}' $names.fdr.$fdrlevel.tab)
						# echo "yyy=$yyy"
						if [ "$yyy" == 'NA' ];
						then
							echo "true"

		 					continue
						fi

						# echo "yyy=$yyy"
		                # echo "zzz=$zzz"
						zzz=$(echo "$yyy+$zzz" | bc)
						# echo "zzz after adding = $zzz"


				done
				# echo $zzz
				# echo $preYoungN
				ssss=$(echo "scale=3 ; $zzz / $preYoungN" | bc -l)
				# echo $ssss	
				echo $ssss >>ysum.txt

					

		for i in `seq $startO $endO`;
		        do
					# echo $Pos
					# echo $endY

					yyy=$(awk -v i=$i -v j=$j 'FNR == j {print $i}' $names.fdr.$fdrlevel.tab)
						# echo "yyy=$yyy"
						if [ "$yyy" == 'NA' ];
						then
							echo "true"

		 					continue
						fi

						# echo "yyy=$yyy"
		    			# echo "zzz=$zzz"
						zzz1=$(echo "$yyy+$zzz1" | bc)
						# echo "zzz after adding = $zzz"


				done
				# echo $zzz
				# echo $preYoungN
				ssss1=$(echo "scale=3 ; $zzz1 / $preOldN" | bc -l)
				# echo $ssss	
				echo $ssss1 >>osum.txt

				########
				# calculating changes in AS in %
				dif=$(echo "$(awk -v var="$j" -v var2="1" 'FNR == var {print $var2}' ysum.txt) - $(awk -v var="$j" -v var2="1" 'FNR == var {print $var2}' osum.txt)" | bc)
				echo $dif >>dif.txt

done

paste -d'\t' $names.fdr.$fdrlevel.tab ysum.txt osum.txt dif.txt > last.tab

#######################################################################################################
#######################################################################################################

#############
###   take all uniq "variantType"

# take ensemble values from new table
awk -F "\t" -v var="$ensemble" '{ print $var }' $names.fdr.$fdrlevel.tab >f1.txt

# take eventID values from new table
awk -F "\t" -v var="$eventID" '{ print $var }' $names.fdr.$fdrlevel.tab >f2.txt

# take fdr values from new table
awk -F "\t" -v var="$fdr" '{ print $var }' $names.fdr.$fdrlevel.tab >f3.txt

# make a table with ensemble and eventID
paste f1.txt f2.txt > $names.eventID.txt

# make a table with ensemble, eventID and fdr
paste f1.txt f2.txt f3.txt > $names.eventID.FDR.txt

# sort unique (ensemble and eventID)
awk '{if (NR!=1) {print}}' $names.eventID.txt | sort -k1 | sort -u -t$'\t' -k1 > $names.eventID.unique.txt

# print out unique ensemble names for ensemble and eventID)
cut -f1 $names.eventID.unique.txt | sort | uniq -c | awk '{printf("%s\t%s\n",$2,$1)}' | sort -rn -k2,2 >$names.unique.txt



