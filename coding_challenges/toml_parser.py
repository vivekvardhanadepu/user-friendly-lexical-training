from tomlkit import parse, dumps

def main():
    with open('parser_test.toml') as test_file:
        data_toml = test_file.read()
        data_json = parse(data_toml)

    # gives error if not parsed well
    assert data_toml == dumps(data_json)

    # outputting as a dictionary
    with open('parser_test.out', 'w') as json_file:
            print(data_json, file=json_file)


if __name__ == '__main__':
    main()