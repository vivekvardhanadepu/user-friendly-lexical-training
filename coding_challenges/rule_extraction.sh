CORPUS="europarl-v7"
SL="spa"
TL="eng"

MIN=1
LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
YASMET=$LEX_TOOLS/yasmet
python3 $SCRIPTS/ngram-count-patterns-maxent2.py data-$SL-$TL/$CORPUS.lex.$SL-$TL data-$SL-$TL/$CORPUS.candidates.$SL-$TL \
            2>data-$SL-$TL/ngrams > data-$SL-$TL/events

echo -n "" > data-$SL-$TL/all-lambdas
cat data-$SL-$TL/events | grep -v -e '\$ 0\.0 #' -e '\$ 0 #' > data-$SL-$TL/events.trimmed
for i in `cat data-$SL-$TL/events.trimmed | cut -f1 | sort -u | sed 's/\([\*\^\$]\)/\\\\\1/g'`; do

	num=`cat data-$SL-$TL/events.trimmed | grep "^$i" | cut -f2 | head -1`
	echo $num > tmp.yasmet.$i;
	cat data-$SL-$TL/events.trimmed | grep "^$i" | cut -f3  >> tmp.yasmet.$i;
	echo "$i"
	cat tmp.yasmet.$i | $YASMET -red $MIN > tmp.yasmet.$i.$MIN; 
	cat tmp.yasmet.$i.$MIN | $YASMET > tmp.lambdas.$i
	cat tmp.lambdas.$i | sed "s/^/$i /g" >> data-$SL-$TL/all-lambdas;
done

rm tmp.*

python3 $SCRIPTS/merge-ngrams-lambdas.py data-$SL-$TL/ngrams data-$SL-$TL/all-lambdas > data-$SL-$TL/rules-all.txt

python3 $SCRIPTS/lambdas-to-rules.py data-$SL-$TL/$CORPUS.lex.$SL-$TL data-$SL-$TL/rules-all.txt > data-$SL-$TL/ngrams-all.txt

python3 $SCRIPTS/ngrams-to-rules-me.py data-$SL-$TL/ngrams-all.txt > $SL-$TL.ngrams-lm-$MIN.xml 2>/tmp/$SL-$TL.$MIN.log