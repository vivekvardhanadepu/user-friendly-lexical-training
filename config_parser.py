from tomlkit import parse, dumps

def parse_config(filename='config.toml'):
    with open(filename) as config_file:
        config_toml = config_file.read()
        config = parse(config_toml)

    # gives error if not parsed well
    assert config_toml == dumps(config)
    
    return config

if __name__ == '__main__':
    parse_config()