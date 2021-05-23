# lexical training script
from config_parser import parse_config

def main():
    config = parse_config()
    print(config)

if __name__ == '__main__':
    main()