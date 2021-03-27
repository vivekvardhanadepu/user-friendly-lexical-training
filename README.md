# user-friendly-lexical-training

The procedure for lexical selection training is a bit messy, with various scripts involved that require lots of manual tweaking, and many third party tools to be installed, e.g. irstlm, moses, gizapp. The goal of this task is to make the training procedure as streamlined and user-friendly as possible

## coding challenges

In directory coding_challenges,

**Parallel corpus:**

europarl-v7.spa-eng.eng

europarl-v7.spa-eng.spa

**Scripts:**

*(change the relevant paths)*

pre-training: preProcessing.sh

lang-models: make_lang_model.sh

alignment and training: alignment.sh

relevant logs in `.log`

**Typical moses training:**(*without using apertium tools*)

In moses_training,

change the relevant paths and run training_script.sh

Ref: www.statmt.org/moses/?n=Moses.Baseline

**Simple TOML parser**

parser: toml-parser.sh

parser test: parser_test.toml

Right now, it does basic syntax check and tests whether apertium, python, lttoolbox and apertium-lex-tools(specific version) are installed or not
