# pipeline
pipeline its database
echo "begin" 

for i in correctdatabase ; do 
VAR1="$(cat $i | awk '{print $2}')"
VAR2="$(cat $i | awk '{print $3}')" 
VAR3="$(cat $i | awk '{print $1}')"
VAR4="$(($VAR2-$VAR1))"
echo "$VAR3"

for j in '>'*; do

VAR5="$(cat $j| head -1 | awk '{print $1}'| tr -d '>')" 
#VAR6="$(($VAR5 == $VAR3))"
#VAR5="$(find '>'* -type f -print | xargs grep '$VAR3')"
echo $VAR5
echo $VAR
if [ "$VAR5" == "$VAR3" ]; then 
echo ">$VAR3" > $VAR3+ITSsequentie.txt
cat $j | head -c $VAR2 | tail -c $VAR4 | tr -d '\n' >> $VAR3+ITSsequentie.txt


else
echo "No Match" 
fi


#dd if=$VAR5 ibs=1 skip=$VAR1 count=$VAR4

done
done
echo "end"

cat *ITSsequentie.txt >> ex.fa
rm *ITSsequentie.txt
