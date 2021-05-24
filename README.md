# user-friendly-lexical-training

The procedure for lexical selection training is a bit messy, with various scripts involved that require lots of manual tweaking, and many third party tools to be installed, e.g. irstlm, moses, gizapp. The goal of this task is to make the training procedure as streamlined and user-friendly as possible

for more, read https://wiki.apertium.org/wiki/Ideas_for_Google_Summer_of_Code/User-friendly_lexical_selection_training

## coding challenges *(using for testing)*

In directory coding_challenges,

**Training parallel corpora:**

*(change the relevant paths)*

pre-training: preProcessing.sh

lang-models: make_lang_model.sh

alignment: alignment.sh[using fast_align, [Chris Dyer](http://www.cs.cmu.edu/~cdyer), [Victor Chahuneau](http://victor.chahuneau.fr), and [Noah A. Smith](http://www.cs.cmu.edu/~nasmith). (2013). [A Simple, Fast, and Effective Reparameterization of IBM Model 2](http://www.ark.cs.cmu.edu/cdyer/fast_valign.pdf). In *Proc. of NAACL*.]

rule-extraction: rule_extraction.sh

cache-SL-TL: intermediate output files and logs for debugging

**Typical moses training:**(*without using apertium tools*)

In moses_training,

change the relevant paths and run training_script.sh

Ref: www.statmt.org/moses/?n=Moses.Baseline

**Simple TOML parser**

parser: toml_parser.py

parser test: parser_test.toml

parser test output: parser_test.out

Right now, it takes toml file, checks the syntax, converts and outputs it as a dictionary
