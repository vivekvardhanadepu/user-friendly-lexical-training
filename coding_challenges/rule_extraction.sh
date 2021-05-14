#!/bin/bash

CORPUS="europarl-v7"
SL="eng"
TL="spa"

MIN=1
LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
YASMET=$LEX_TOOLS/yasmet

python3 $SCRIPTS/ngram-count-patterns-maxent2.py cache-$SL-$TL/$CORPUS.lex.$SL-$TL cache-$SL-$TL/$CORPUS.candidates.$SL-$TL \
            2>cache-$SL-$TL/ngrams > cache-$SL-$TL/events

echo -n "" > cache-$SL-$TL/all-lambdas
<cache-$SL-$TL/events grep -v -e '\$ 0\.0 #' -e '\$ 0 #' > cache-$SL-$TL/events.trimmed
<cache-$SL-$TL/events.trimmed cut -f1 | sort -u | sed 's/\([\*\^\$]\)/\\\\\1/g' > tmp.sl
# OLDIFS=$IFS; IFS='\n';
# for i in $(cat tmp.sl); do
while read i; do
	# IFS=$OLDIFS
	num=$(<cache-$SL-$TL/events.trimmed grep "^$i" | cut -f2 | head -1)
	echo "$num" > "tmp.yasmet.$i";
	<cache-$SL-$TL/events.trimmed grep "^$i" | cut -f3  >> "tmp.yasmet.$i";
	echo "$i"
	<"tmp.yasmet.$i" $YASMET -red $MIN > "tmp.yasmet.$i.$MIN"; 
	<"tmp.yasmet.$i.$MIN" $YASMET > "tmp.lambdas.$i"
	<"tmp.lambdas.$i" sed "s/ /\t/g" | sed "s/^/$i\t/g" >> cache-$SL-$TL/all-lambdas;
	# IFS='\n';
done < tmp.sl
# IFS=$OLDIFS

rm tmp.*

python3 $SCRIPTS/merge-ngrams-lambdas.py cache-$SL-$TL/ngrams cache-$SL-$TL/all-lambdas > cache-$SL-$TL/rules-all.txt

python3 $SCRIPTS/lambdas-to-rules.py cache-$SL-$TL/$CORPUS.lex.$SL-$TL cache-$SL-$TL/rules-all.txt > cache-$SL-$TL/ngrams-all.txt

python3 $SCRIPTS/ngrams-to-rules-me.py cache-$SL-$TL/ngrams-all.txt > $SL-$TL.ngrams-lm-$MIN.xml 2> cache-$SL-$TL/$SL-$TL.$MIN.log
