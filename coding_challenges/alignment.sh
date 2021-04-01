CORPUS="europarl-v7"
PAIR="eng-spa"
SL="eng"
TL="spa"

LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
PROJ_HOME="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges"
FAST_ALIGN="$PROJ_HOME/fast_align/build"
DATA="$PROJ_HOME/apertium-$PAIR"
# TRAINING_LINES=100

# MOSESDECODER="/home/vivek/Documents/FOSS/apertium/mosesdecoder/scripts/training"
# BIN_DIR="/home/vivek/Documents/FOSS/apertium/GIZA++/bin"
# *Absolute path* to the lm that you created with IRSTLM:
# LM="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges/data-$SL-$TL/$CORPUS.tag-clean.$TL.lm"

# ALIGN
$FAST_ALIGN/fast_align -i data-$SL-$TL/$CORPUS.tagged-merged.$SL-$TL -d -o -v > data-$SL-$TL/$CORPUS.forward-align.$SL-$TL
$FAST_ALIGN/fast_align -i data-$SL-$TL/$CORPUS.tagged-merged.$SL-$TL -d -o -v -r > data-$SL-$TL/$CORPUS.reverse-align.$SL-$TL
$FAST_ALIGN/atools -i data-$SL-$TL/$CORPUS.forward-align.$SL-$TL -j data-$SL-$TL/$CORPUS.reverse-align.$SL-$TL\
                 -c grow-diag-final-and

# head -n $TRAINING_LINES $CORPUS.$PAIR.$SL > tmp1
# head -n $TRAINING_LINES $CORPUS.$PAIR.$TL > tmp2
# head -n $TRAINING_LINES data-$SL-$TL/$CORPUS.reverse-align.$SL-$TL > tmp3
# paste tmp1 tmp2 tmp3 | sed 's/\t/ ||| /g' > data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL
# rm tmp1 tmp2 tmp3

paste data-$SL-$TL/$CORPUS.tagged.$SL data-$SL-$TL/$CORPUS.tagged.$TL data-$SL-$TL/$CORPUS.reverse-align.$SL-$TL \
	| sed 's/\t/ ||| /g' > data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL
	
# TRIM TAGS
cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 1 \
	| sed 's/~/ /g' | multitrans -p -t $DATA/$SL-$TL.autobil.bin> tmp1
# sed -i -e '1,2d' tmp1

cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 2 \
	| sed 's/~/ /g' | multitrans -p -t $DATA/$TL-$SL.autobil.bin > tmp2
# sed -i -e '1,2d' tmp2

cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 3 > tmp3

cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 2 \
	| sed 's/~/ /g' | multitrans -b -t $DATA/$TL-$SL.autobil.bin > data-$SL-$TL/$CORPUS.clean-biltrans.$PAIR
# sed -i -e '1,2d' data-$SL-$TL/$CORPUS.clean-biltrans.$PAIR

paste tmp1 tmp2 tmp3 | sed 's/\t/ ||| /g' > data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL
rm tmp1 tmp2 tmp3

# SENTENCES
python3 $SCRIPTS/extract-sentences.py data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL data-$SL-$TL/$CORPUS.clean-biltrans.$PAIR \
                > data-$SL-$TL/$CORPUS.candidates.$SL-$TL

# FREQUENCY LEXICON
python3 $SCRIPTS/extract-freq-lexicon.py data-$SL-$TL/$CORPUS.candidates.$SL-$TL > data-$SL-$TL/$CORPUS.lex.$SL-$TL












# ALIGN
# PYTHONIOENCODING=utf-8
# perl $MOSESDECODER/train-model.perl \
#   -external-bin-dir "$BIN_DIR" \
#   -corpus data-$SL-$TL/$CORPUS.tag-clean \
#   -f $TL -e $SL \
#   -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
#   -lm 0:5:${LM}:0 2>&1

# (if you use mgiza, add the -mgiza argument)


# EXTRACT
# zcat giza.$SL-$TL/$SL-$TL.A3.final.gz | $SCRIPTS/giza-to-moses.awk > data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL