#!/bin/bash

CORPUS="europarl-v7"
PAIR="eng-spa"
SL="eng"
TL="spa"

PROJ_HOME="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges"
LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
FAST_ALIGN="$PROJ_HOME/fast_align/build"
DATA="$PROJ_HOME/apertium-$PAIR"

# ALIGN
$FAST_ALIGN/fast_align -i cache-$SL-$TL/$CORPUS.tagged-merged.$SL-$TL -d -o -v > cache-$SL-$TL/$CORPUS.forward-align.$SL-$TL
$FAST_ALIGN/fast_align -i cache-$SL-$TL/$CORPUS.tagged-merged.$SL-$TL -r -d -o -v > cache-$SL-$TL/$CORPUS.reverse-align.$SL-$TL
$FAST_ALIGN/atools -i cache-$SL-$TL/$CORPUS.forward-align.$SL-$TL -j cache-$SL-$TL/$CORPUS.reverse-align.$SL-$TL \
                 -c grow-diag-final-and > cache-$SL-$TL/$CORPUS.symm-align.$SL-$TL

# head -n $TRAINING_LINES $CORPUS.$PAIR.$SL > tmp1
# head -n $TRAINING_LINES $CORPUS.$PAIR.$TL > tmp2
# head -n $TRAINING_LINES cache-$SL-$TL/$CORPUS.reverse-align.$SL-$TL > tmp3
# paste tmp1 tmp2 tmp3 | sed 's/\t/ ||| /g' > cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL
# rm tmp1 tmp2 tmp3

paste cache-$SL-$TL/$CORPUS.tagged.$TL cache-$SL-$TL/$CORPUS.tagged.$SL cache-$SL-$TL/$CORPUS.forward-align.$SL-$TL \
	| sed 's/\t/ ||| /g' > cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL

# TRIM TAGS
<cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL sed 's/ ||| /\t/g' | cut -f 1 \
	| sed 's/~/ /g' | multitrans -p -t $DATA/$TL-$SL.autobil.bin > tmp1

<cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL sed 's/ ||| /\t/g' | cut -f 2 \
	| sed 's/~/ /g' | multitrans -p -t $DATA/$SL-$TL.autobil.bin> tmp2

<cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL sed 's/ ||| /\t/g' | cut -f 3 > tmp3

# cat cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 2 \
# 	| sed 's/~/ /g' | multitrans -b -t $DATA/$TL-$SL.autobil.bin > cache-$SL-$TL/$CORPUS.clean-biltrans.$PAIR
# sed -i -e '1,2d' cache-$SL-$TL/$CORPUS.clean-biltrans.$PAIR
<cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL sed 's/ ||| /\t/g' | cut -f 2 \
	| sed 's/~/ /g' | lt-proc -b $DATA/$SL-$TL.autobil.bin > cache-$SL-$TL/$CORPUS.clean-biltrans.$SL-$TL

paste tmp1 tmp2 tmp3 | sed 's/\t/ ||| /g' > cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL
rm tmp1 tmp2 tmp3

# SENTENCES
python3 $SCRIPTS/extract-sentences.py cache-$SL-$TL/$CORPUS.phrasetable.$SL-$TL cache-$SL-$TL/$CORPUS.clean-biltrans.$SL-$TL \
                > cache-$SL-$TL/$CORPUS.candidates.$SL-$TL

# FREQUENCY LEXICON
python3 $SCRIPTS/extract-freq-lexicon.py cache-$SL-$TL/$CORPUS.candidates.$SL-$TL > cache-$SL-$TL/$CORPUS.lex.$SL-$TL