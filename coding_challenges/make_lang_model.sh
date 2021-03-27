CORPUS="Europarl"
SL="es"
TL="pt"

# KENLM="/home/vivek/Documents/FOSS/apertium/kenlm/build/bin"

$IRSTLM/bin/build-lm.sh -i data-$SL-$TL/$CORPUS.tag-clean.$SL -o data-$SL-$TL/$CORPUS.tag-clean.$SL.lm.gz -t tmp -l pt_irstlm.log
$IRSTLM/bin/build-lm.sh -i data-$SL-$TL/$CORPUS.tag-clean.$TL -o data-$SL-$TL/$CORPUS.tag-clean.$TL.lm.gz -t tmp -l es_irstlm.log

cd data-$SL-$TL
gunzip $CORPUS.tag-clean.$SL.lm.gz
gunzip $CORPUS.tag-clean.$TL.lm.gz
cd ..

# $KENLM/lmplz -o 5 < data-$SL-$TL/$CORPUS.tag-clean.$SL > data-$SL-$TL/$CORPUS.tag-clean.$SL.arpa
# $KENLM/lmplz -o 5 < data-$SL-$TL/$CORPUS.tag-clean.$TL > data-$SL-$TL/$CORPUS.tag-clean.$TL.arpa