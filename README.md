# user-friendly-lexical-training

**repo moved to [apertium-lexical-training](https://github.com/vivekvardhanadepu/apertium-lexical-training)**

The procedure for lexical selection training is a bit messy, with various scripts involved that require lots of manual tweaking, and many third party tools to be installed, e.g. irstlm, moses, gizapp. The goal of this task is to make the training procedure as streamlined and user-friendly as possible

for more, read https://wiki.apertium.org/wiki/Ideas_for_Google_Summer_of_Code/User-friendly_lexical_selection_training

## tests

This folder contains scripts for automated testing of the helper scripts

## coding challenges _(using for testing)_

In directory coding_challenges,

**Training parallel corpora:**

_(change the relevant paths)_

pre-training: preProcessing.sh

lang-models: make_lang_model.sh

alignment: alignment.sh[using fast_align, [Chris Dyer](http://www.cs.cmu.edu/~cdyer), [Victor Chahuneau](http://victor.chahuneau.fr), and [Noah A. Smith](http://www.cs.cmu.edu/~nasmith). (2013). [A Simple, Fast, and Effective Reparameterization of IBM Model 2](http://www.ark.cs.cmu.edu/cdyer/fast_valign.pdf). In _Proc. of NAACL_.]

rule-extraction: rule_extraction.sh

cache-SL-TL: intermediate output files and logs for debugging

**Typical moses training:**(_without using apertium tools_)

In moses_training,

change the relevant paths and run training_script.sh

Ref: www.statmt.org/moses/?n=Moses.Baseline
