CORPUS="europarl-v7"
SL="eng"
TL="spa"

# KENLM="/home/vivek/Documents/FOSS/apertium/kenlm/build/bin"

$IRSTLM/bin/build-lm.sh -i data-$SL-$TL/$CORPUS.tag-clean.$SL -o data-$SL-$TL/$CORPUS.tag-clean.$SL.lm.gz -t tmp -l eng_irstlm.log
$IRSTLM/bin/build-lm.sh -i data-$SL-$TL/$CORPUS.tag-clean.$TL -o data-$SL-$TL/$CORPUS.tag-clean.$TL.lm.gz -t tmp -l spa_irstlm.log

# $KENLM/lmplz -o 5 < data-$SL-$TL/$CORPUS.tag-clean.$SL > data-$SL-$TL/$CORPUS.tag-clean.$SL.arpa
# $KENLM/lmplz -o 5 < data-$SL-$TL/$CORPUS.tag-clean.$TL > data-$SL-$TL/$CORPUS.tag-clean.$TL.arpa