#!/bin/bash

CORPUS="europarl-v7"
PAIR="eng-spa"
SL="eng"
TL="spa"
DATA="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges/apertium-$PAIR"

# LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
# SCRIPTS="$LEX_TOOLS/scripts"
# MOSESDECODER="/home/vivek/Documents/FOSS/apertium/mosesdecoder/scripts/training"
TRAINING_LINES=7000

if [ ! -d cache-$SL-$TL ]; then 
	mkdir cache-$SL-$TL;
fi

# TAG CORPUS
<"$CORPUS.$PAIR.$SL" head -n $TRAINING_LINES | apertium-destxt | apertium -d "$DATA" -f none $SL-$TL-tagger \
	| apertium-pretransfer > cache-$SL-$TL/$CORPUS.tagged.$SL;

<"$CORPUS.$PAIR.$TL" head -n $TRAINING_LINES | apertium-destxt | apertium -d "$DATA" -f none $TL-$SL-tagger \
	| apertium-pretransfer > cache-$SL-$TL/$CORPUS.tagged.$TL;

# N=$(wc -l $CORPUS.$PAIR.$SL | cut -d ' ' -f 1)


# REMOVE LINES WITH NO ANALYSES
seq 1 $TRAINING_LINES > cache-$SL-$TL/$CORPUS.lines
paste cache-$SL-$TL/$CORPUS.lines cache-$SL-$TL/$CORPUS.tagged.$SL cache-$SL-$TL/$CORPUS.tagged.$TL | grep '<' \
	| cut -f1 > cache-$SL-$TL/$CORPUS.lines.new
paste cache-$SL-$TL/$CORPUS.lines cache-$SL-$TL/$CORPUS.tagged.$SL cache-$SL-$TL/$CORPUS.tagged.$TL | grep '<' \
	| cut -f2 > cache-$SL-$TL/$CORPUS.tagged.$SL.new
paste cache-$SL-$TL/$CORPUS.lines cache-$SL-$TL/$CORPUS.tagged.$SL cache-$SL-$TL/$CORPUS.tagged.$TL | grep '<' \
	| cut -f3 > cache-$SL-$TL/$CORPUS.tagged.$TL.new
mv cache-$SL-$TL/$CORPUS.lines.new cache-$SL-$TL/$CORPUS.lines
<cache-$SL-$TL/$CORPUS.tagged.$SL.new \
	sed 's/ /~/g' | sed 's/\$[^\^]*/$ /g' > cache-$SL-$TL/$CORPUS.tagged.$SL
<cache-$SL-$TL/$CORPUS.tagged.$TL.new \
	sed 's/ /~/g' | sed 's/\$[^\^]*/$ /g' > cache-$SL-$TL/$CORPUS.tagged.$TL
rm cache-$SL-$TL/*.new

</dev/null paste -d '||| ' cache-$SL-$TL/$CORPUS.tagged.$TL - - - cache-$SL-$TL/$CORPUS.tagged.$SL \
							> cache-$SL-$TL/$CORPUS.tagged-merged.$SL-$TL
# cat "$CORPUS.$PAIR.$SL" | head -n $TRAINING_LINES | apertium -d "$DATA" $SL-$TL-biltrans \
# 							> cache-$SL-$TL/$CORPUS.biltrans.$SL-$TL

# CLEAN CORPUS
# perl "$MOSESDECODER/../tokenizer/escape-special-chars.perl" \
# 								< cache-$SL-$TL/$CORPUS.tagged.$SL > cache-$SL-$TL/$CORPUS.tagged_esc.$SL
# perl "$MOSESDECODER/../tokenizer/escape-special-chars.perl" \
# 								< cache-$SL-$TL/$CORPUS.tagged.$TL > cache-$SL-$TL/$CORPUS.tagged_esc.$TL
# perl "$MOSESDECODER/clean-corpus-n.perl" cache-$SL-$TL/$CORPUS.tagged_esc $SL $TL "cache-$SL-$TL/$CORPUS.tag-clean" 1 40;