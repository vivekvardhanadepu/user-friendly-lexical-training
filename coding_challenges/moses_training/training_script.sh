MOSES="/home/vivek/Documents/FOSS/apertium/mosesdecoder/scripts"
GIZA="/home/vivek/Documents/FOSS/apertium/GIZA++/bin"
MY_ROOT="/home/vivek/Documents/FOSS/apertium/user-friendly-lexical-training/coding_challenges/moses_training"

mkdir corpus
cd corpus 
wget http://www.statmt.org/wmt13/training-parallel-nc-v8.tgz
tar zxvf training-parallel-nc-v8.tgz

## Tokenizing
$MOSES/tokenizer/tokenizer.perl -l fr < training/news-commentary-v8.fr-en.fr > ../news-commentary-v8.fr-en.tok.fr
$MOSES/tokenizer/tokenizer.perl -l en < training/news-commentary-v8.fr-en.en > ../news-commentary-v8.fr-en.tok.en
## True casing
$MOSES/recaser/train-truecaser.perl \
        --model $MY_ROOT/corpus/truecase-model.fr \
        --corpus $MY_ROOT/corpus/news-commentary-v8.fr-en.tok.fr
$MOSES/recaser/train-truecaser.perl \
        --model $MY_ROOT/corpus/truecase-model.en \
        --corpus $MY_ROOT/corpus/news-commentary-v8.fr-en.tok.en
$MOSES/recaser/truecase.perl \
        --model $MY_ROOT/corpus/truecase-model.fr \
        < news-commentary-v8.fr-en.tok.fr > news-commentary-v8.fr-en.true.fr
$MOSES/recaser/truecase.perl \
        --model $MY_ROOT/corpus/truecase-model.en \
        < news-commentary-v8.fr-en.tok.en > news-commentary-v8.fr-en.true.en
$MOSES/training/clean-corpus-n.perl news-commentary-v8.fr-en.true fr en news-commentary-v8.fr-en.clean 1 80

cd ..
mkdir lm
cd lm

# making lang model(should be executed in lm folder)
$MOSES/../bin/lmplz -o 3 < ../corpus/news-commentary-v8.fr-en.true.en > news-commentary-v8.fr-en.arpa.en

# builing binary(should be executed in lm folder)
$MOSES/../bin/build_binary news-commentary-v8.fr-en.arpa.en news-commentary-v8.fr-en.blm.en

cd ..
mkdir working
cd working

# align and train
nohup nice $MOSES/training/train-model.perl -root-dir train \
        -corpus $MY_ROOT/corpus/news-commentary-v8.fr-en.clean \
        -f fr -e en -alignment grow-diag-final-and \
        -reordering msd-bidirectional-fe \
        -lm 0:3:$MY_ROOT/lm/news-commentary-v8.fr-en.blm.en:8 \
        -external-bin-dir $GIZA -cores 3 &> training.out