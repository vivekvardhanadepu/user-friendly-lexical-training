CORPUS="europarl-v7"
PAIR="spa-eng"
SL="eng"
TL="spa"

LEX_TOOLS="/home/vivek/Documents/FOSS/apertium/apertium-lex-tools"
SCRIPTS="$LEX_TOOLS/scripts"
MOSESDECODER="/home/vivek/Documents/FOSS/apertium/mosesdecoder/scripts/training"
BIN_DIR="/home/vivek/Documents/FOSS/apertium/GIZA++/bin"
# *Absolute path* to the lm that you created with IRSTLM:
LM="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges/data-eng-spa/europarl-v7.tag-clean.spa.lm"

# ALIGN
PYTHONIOENCODING=utf-8
perl $MOSESDECODER/train-model.perl \
  -external-bin-dir "$BIN_DIR" \
  -corpus data-$SL-$TL/$CORPUS.tag-clean \
  -f $TL -e $SL \
  -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
  -lm 0:5:${LM}:0 2>&1

# (if you use mgiza, add the -mgiza argument)


# EXTRACT
zcat giza.$SL-$TL/$SL-$TL.A3.final.gz | $SCRIPTS/giza-to-moses.awk > data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL

# TRIM TAGS
cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 1 \
	| sed 's/~/ /g' | $LEX_TOOLS/process-tagger-output $DATA/$TL-$SL.autobil.bin -p -t > tmp1

cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 2 \
	| sed 's/~/ /g' | $LEX_TOOLS/process-tagger-output $DATA/$SL-$TL.autobil.bin -p -t > tmp2

cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 3 > tmp3

cat data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL | sed 's/ ||| /\t/g' | cut -f 2 \
	| sed 's/~/ /g' | $LEX_TOOLS/process-tagger-output $DATA/$SL-$TL.autobil.bin -b -t > data-$SL-$TL/$CORPUS.clean-biltrans.$PAIR

paste tmp1 tmp2 tmp3 | sed 's/\t/ ||| /g' > data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL
rm tmp1 tmp2 tmp3

# # SENTENCES
python3 $SCRIPTS/extract-sentences.py data-$SL-$TL/$CORPUS.phrasetable.$SL-$TL data-$SL-$TL/$CORPUS.clean-biltrans.$PAIR \
  > data-$SL-$TL/$CORPUS.candidates.$SL-$TL 2>sentences.log

# FREQUENCY LEXICON
python3 $SCRIPTS/extract-freq-lexicon.py data-$SL-$TL/$CORPUS.candidates.$SL-$TL > data-$SL-$TL/$CORPUS.lex.$SL-$TL 2>frequency_lexicon.log