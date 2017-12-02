

startnames="17*"

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



###   take number of the column named "variantType"
number="$( bash <<EOF
echo $(head -1 $longnames | tr -s '\t' '\n' | nl -nln | grep "variantType" | cut -f1)
EOF
)"


###   take all uniq "variantType"
awk -F "\t" -v var="$number" '{ print $var }' $longnames | awk '{if (NR!=1) {print}}' | sort | uniq | sed -e 's/\"//g' | tr '+' $'\n'| sort | uniq | grep -v "^$" >$i.spl_var.txt

done




