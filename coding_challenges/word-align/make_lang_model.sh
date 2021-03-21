CORPUS="europarl-v7"
SL="eng"
TL="spa"

$IRSTLM/bin/build-lm.sh -i data-$SL-$TL/$CORPUS.tag-clean.$SL -o data-$SL-$TL/$CORPUS.tag-clean.$SL.lm.gz -t tmp -l log1.txt
$IRSTLM/bin/build-lm.sh -i data-$SL-$TL/$CORPUS.tag-clean.$TL -o data-$SL-$TL/$CORPUS.tag-clean.$TL.lm.gz -t tmp -l log2.txt