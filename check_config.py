# parses the config, check if the tools are present

from tomlkit import parse, dumps
import os

# urls of the required tools and data
corpora_url = ""
lex_tools_url = ""
fast_align_url = ""
langs_url = ""

def parse_config(filename='config.toml'):
    with open(filename) as config_file:
        config_toml = config_file.read()
        config = parse(config_toml)

    # gives error if not parsed well
    assert config_toml == dumps(config)

    if not os.path.isfile(config['CORPUS_SL']):
        print(config['CORPUS_SL'], "is not a file. Provide a valid file or to download,\n look", corpora_url)

    if not os.path.isfile(config['CORPUS_TL']):
        print(config['CORPUS_TL'], "is not a file. Provide a valid file or to download,\n look", corpora_url)

    if not os.path.isdir(config['LEX_TOOLS']):
        print(config['LEX_TOOLS'], "is not a directory. Provide a valid directory or to install,\n follow", lex_tools_url)

    if not os.path.isdir(config['FAST_ALIGN']):
        print(config['FAST_ALIGN'], "is not a directory. Provide a valid directory or to install,\n follow", fast_align_url)

    if not os.path.isdir(config['LANG_DATA']):
        print(config['LANG_DATA'], "is not a directory. Provide a valid directory or to install,\n follow", langs_url)

    
    
    return config

if __name__ == '__main__':
    parse_config()