# pipeline
pipeline its database
cd Documents/

curl 'ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt' | awk '{FS="\t"} !/^#/ {print $20}' | sed -r 's|(ftp://ftp.ncbi.nlm.nih.gov/genomes/all/)(GCA/)([0-9]{3}/)([0-9]{3}/)([0-9]{3}/)(GCA_.+)|\1\2\3\4\5\6/\6_genomic.fna.gz|' > genomicrefseq_file

wget -i genomicrefseq_file

curl 'ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt' | awk '{FS="\t"} !/^#/ {print $20}' | sed -r 's|(ftp://ftp.ncbi.nlm.nih.gov/genomes/all/)(GCA/)([0-9]{3}/)([0-9]{3}/)([0-9]{3}/)(GCA_.+)|\1\2\3\4\5\6/\6_genomic.gbff.gz|' > genomicgenbank_file

wget -i genomicgenbank_file 

gunzip *.gz
for file in *.gbff
do
	echo ${file}
    python gb.py ${file} "${file}_output.txt"
done

from __future__ import print_function
from Bio import SeqIO
import sys


outfile = open(str(sys.argv[2]), "w")
gb_file = str(sys.argv[1])
i = 0
newline_call = ""
for index, record in enumerate(SeqIO.parse(gb_file, "genbank")):
    print("Processing:\nindex:", str(index), "Id:", record.id)
    for feature in record.features:
        #print(feature)
        line = ""
        line = ("Id:" + record.id + ",type:" + feature.type + ",start:" +
                str(feature.location.start) + ",end:" +
                str(feature.location.end) + ",")
        #print(line)
        for key, value in feature.qualifiers.items():
            #print newline als de eerste key weer terugkomt
            #print(key)
            #if i == 1 and key == newline_call:
            #    print('\n')
            #    outfile.write('\n')
            #if i == 0:
            #    i += 1
            line += key + ":" + " ".join(str(j) for j in value) + ","
        #print(line[:-1])
        outfile.write(line[:-1])
        outfile.write('\n')
outfile.close()

echo "begin script"

for i in genebank/*gb; do
	echo "$/*.gb"

VAR1="$(cat $i | head -n1 |tr ':' ' ' | tr ','  ' ' | awk '{print $2}')"
VAR2="$(cat $i | egrep '(16S|23S)'  | tr ':' ' ' | tr ','  ' ' | cut -c 1-100 | egrep '(16S|23S)'| awk '{print$6, $8, $12}' | tail -n +3 | tr '\n' ' ' | sed 's/16S/\n/g' | awk '{print $2, $4}'| sed \$d | head -n1)"  

echo -e "$VAR1"  "$VAR2" > "$VAR1".txt
done
cat *.txt >> database.txt
cat database.txt | awk 'NF==3' > correctdatabase
echo "einde script"

echo 'begin'

for i in *.fna; do
VAR1="$(cat $i | head -1 | awk '{print $1}' )" 
mv $i $VAR1

done

echo 'end'
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
	 
centrifuge-download -o taxonomy taxonomy
centrifuge-download -o library -m -d "bacteria" refseq > seqid2taxid.map
centrifuge-build --conversion-table ex.conv \
             	--taxonomy-tree ex.tree --name-table ex.name \
             	ex.fa ex
