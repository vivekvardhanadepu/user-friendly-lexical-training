CORPUS="news-commentary-v8"
PAIR="eng-spa"
SL="eng"
TL="spa"

MIN=1
LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
YASMET=$LEX_TOOLS/yasmet
python3 $SCRIPTS/ngram-count-patterns-maxent2.py data-$SL-$TL/$CORPUS.lex.$SL-$TL data-$SL-$TL/$CORPUS.candidates.$SL-$TL \
            2>ngrams > events

echo -n "" > all-lambdas
cat events | grep -v -e '\$ 0\.0 #' -e '\$ 0 #' > events.trimmed
for i in `cat events.trimmed | cut -f1 | sort -u | sed 's/\([\*\^\$]\)/\\\\\1/g'`; do

	num=`cat events.trimmed | grep "^$i" | cut -f2 | head -1`
	echo $num > tmp.yasmet.$i;
	cat events.trimmed | grep "^$i" | cut -f3  >> tmp.yasmet.$i;
	echo "$i"
	cat tmp.yasmet.$i | $YASMET -red $MIN > tmp.yasmet.$i.$MIN; 
	cat tmp.yasmet.$i.$MIN | $YASMET > tmp.lambdas.$i
	cat tmp.lambdas.$i | sed "s/^/$i /g" >> all-lambdas;
done

rm tmp.*

python3 $SCRIPTS/merge-ngrams-lambdas.py ngrams all-lambdas > rules-all.txt

python3 $SCRIPTS/lambdas-to-rules.py data-$SL-$TL/$CORPUS.lex.$SL-$TL rules-all.txt > ngrams-all.txt

python3 $SCRIPTS/ngrams-to-rules-me.py ngrams-all.txt > $PAIR.ngrams-lm-$MIN.xml 2>/tmp/$PAIR.$MIN.lög