CORPUS="Europarl"
PAIR="es-pt"
SL="es"
TL="pt"
DATA="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges/apertium-$PAIR"

LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
MOSESDECODER="/home/vivek/Documents/FOSS/apertium/mosesdecoder/scripts/training"
TRAINING_LINES=1000


if [ ! -d data-$SL-$TL ]; then 
	mkdir data-$SL-$TL;
fi

# TAG CORPUS
cat "$CORPUS.$PAIR.$SL" | head -n $TRAINING_LINES | apertium -d "$DATA" $SL-$TL-tagger \
	| apertium-pretransfer > data-$SL-$TL/$CORPUS.tagged.$SL;

cat "$CORPUS.$PAIR.$TL" | head -n $TRAINING_LINES | apertium -d "$DATA" $TL-$SL-tagger \
	| apertium-pretransfer > data-$SL-$TL/$CORPUS.tagged.$TL;

N=`wc -l $CORPUS.$PAIR.$SL | cut -d ' ' -f 1`


# REMOVE LINES WITH NO ANALYSES
seq 1 $TRAINING_LINES > data-$SL-$TL/$CORPUS.lines
paste data-$SL-$TL/$CORPUS.lines data-$SL-$TL/$CORPUS.tagged.$SL data-$SL-$TL/$CORPUS.tagged.$TL | grep '<' \
	| cut -f1 > data-$SL-$TL/$CORPUS.lines.new
paste data-$SL-$TL/$CORPUS.lines data-$SL-$TL/$CORPUS.tagged.$SL data-$SL-$TL/$CORPUS.tagged.$TL | grep '<' \
	| cut -f2 > data-$SL-$TL/$CORPUS.tagged.$SL.new
paste data-$SL-$TL/$CORPUS.lines data-$SL-$TL/$CORPUS.tagged.$SL data-$SL-$TL/$CORPUS.tagged.$TL | grep '<' \
	| cut -f3 > data-$SL-$TL/$CORPUS.tagged.$TL.new
mv data-$SL-$TL/$CORPUS.lines.new data-$SL-$TL/$CORPUS.lines
cat data-$SL-$TL/$CORPUS.tagged.$SL.new \
	| sed 's/ /~/g' | sed 's/\$[^\^]*/$ /g' > data-$SL-$TL/$CORPUS.tagged.$SL
cat data-$SL-$TL/$CORPUS.tagged.$TL.new \
	| sed 's/ /~/g' | sed 's/\$[^\^]*/$ /g' > data-$SL-$TL/$CORPUS.tagged.$TL
rm data-$SL-$TL/*.new


# CLEAN CORPUS
perl "$MOSESDECODER/../tokenizer/escape-special-chars.perl" \
								< data-$SL-$TL/$CORPUS.tagged.$SL > data-$SL-$TL/$CORPUS.tagged_esc.$SL
perl "$MOSESDECODER/../tokenizer/escape-special-chars.perl" \
								< data-$SL-$TL/$CORPUS.tagged.$TL > data-$SL-$TL/$CORPUS.tagged_esc.$TL
perl "$MOSESDECODER/clean-corpus-n.perl" data-$SL-$TL/$CORPUS.tagged_esc $SL $TL "data-$SL-$TL/$CORPUS.tag-clean" 1 40;