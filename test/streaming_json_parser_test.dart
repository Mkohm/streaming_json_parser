import 'package:flutter_test/flutter_test.dart';
import 'package:streaming_json_parser/streaming_json_parser.dart';

void main() {
  group('Lexing tests', () {
    test('Lex string', () {
      var result = lexString('"hello"');
      expect(result['value'], 'hello');
      expect(result['rest'], '');
    });

    test('Lex number', () {
      var result = lexNumber('12345');
      expect(result['value'], 12345);
      expect(result['rest'], '');
    });

    test('Lex boolean', () {
      var result = lexBool('true');
      expect(result['value'], true);
      expect(result['rest'], '');
    });

    test('Lex null', () {
      var result = lexNull('null');
      expect(result['value'], null);
      expect(result['rest'], '');
    });

    test('Lex complex string', () {
      var result = lex('"hello": 123, "world": true');
      expect(result, ['hello', ':', 123, ',', 'world', ':', true]);
    });
  });

  group('Parsing tests', () {
    test('Parse array', () {
      var tokens = ['[', 1, ',', 2, ',', 3, ']'];
      var result = parseTokens(tokens);
      expect(result[0], [1, 2, 3]);
    });

    test('Parse object', () {
      var tokens = ['{', 'key', ':', 'value', '}'];
      var result = parseTokens(tokens);
      expect(result['value'], {'key': 'value'});
    });

    test('Parse complex object', () {
      var tokens = ['{', 'name', ':', 'John', ',', 'age', ':', 30, '}'];
      var result = parseTokens(tokens, isRoot: true);
      expect(result["value"], {'name': 'John', 'age': 30});
    });
  });

  group("lexing and parsing tests", () {
    test("lex and parse", () {
      var jsonString = '{"name": "John", "age": 30}';
      var tokens = lex(jsonString);
      var result = parseTokens(tokens, isRoot: true);
      expect(result["value"], {'name': 'John', 'age': 30});
    });

    test("lex and parse list of json objects", () {
      var jsonString = '{"recipes": [{"name": "fish"}, {"name": "pancakes"}]}';
      var tokens = lex(jsonString);
      var result = parseTokens(tokens, isRoot: true);
      expect(result["value"], {
        'recipes': [
          {'name': 'fish'},
          {'name': 'pancakes'}
        ]
      });
    });

    test("lex and parse complex json object", () {
      var jsonString =
          '{"name": "John", "age": 30, "isStudent": true, "grades": [90, 80, 70]}';
      var tokens = lex(jsonString);
      var result = parseTokens(tokens, isRoot: true);
      expect(result["value"], {
        'name': 'John',
        'age': 30,
        'isStudent': true,
        'grades': [90, 80, 70]
      });
    });
  });

  group("lex and parse streaming json", () {
    test("lex and parse streaming json", () {
      var jsonString = '{"name": "John"';
      var tokens = lex(jsonString);
      var result = parseTokens(tokens, isRoot: true);
      expect(result["value"], {
        'name': 'John',
      });
    });

    test("lex and parse streaming json", () {
      var jsonString = '{"name": "John", "age": 30}';
      var tokens = lex(jsonString);
      var result = parseTokens(tokens, isRoot: true);
      expect(result["value"], {
        'name': 'John',
        'age': 30,
      });
    });
  });

  group("parsing tests", () {
    test("parse example 1", () {
      var result = parse("{");
      expect(result, {});
    });

    test("parse example 2", () {
      var result = parse('{"key": "value", "someOtherIncomplet');
      expect(result, {"key": "value"});
    });

    test("parse example 3", () {
      var result = parse('{"key": ["value", "value2');
      expect(result, {
        "key": ["value", "value2"]
      });
    });
  });
}
