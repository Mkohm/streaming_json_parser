part of 'streaming_json_parser.dart';

const String JSON_COMMA = ',';
const String JSON_COLON = ':';
const String JSON_LEFTBRACKET = '[';
const String JSON_RIGHTBRACKET = ']';
const String JSON_LEFTBRACE = '{';
const String JSON_RIGHTBRACE = '}';
const String JSON_QUOTE = '"';

const List<String> JSON_WHITESPACE = [' ', '\t', '\b', '\n', '\r'];
const List<String> JSON_SYNTAX = [
  JSON_COMMA,
  JSON_COLON,
  JSON_LEFTBRACKET,
  JSON_RIGHTBRACKET,
  JSON_LEFTBRACE,
  JSON_RIGHTBRACE
];

const int FALSE_LEN = 'false'.length;
const int TRUE_LEN = 'true'.length;
const int NULL_LEN = 'null'.length;

Map<String, dynamic> lexString(String string) {
  String jsonString = '';

  if (string[0] == JSON_QUOTE) {
    string = string.substring(1);
  } else {
    return {'value': null, 'rest': string};
  }

  for (var c in string.split('')) {
    if (c == JSON_QUOTE) {
      return {
        'value': jsonString,
        'rest': string.substring(jsonString.length + 1)
      };
    } else {
      jsonString += c;
    }
  }

  return {'value': jsonString, 'rest': ""};
}

Map<String, dynamic> lexNumber(String string) {
  String jsonNumber = '';
  List<String> numberCharacters =
      List.generate(10, (d) => d.toString()) + ['-', 'e', '.'];

  for (var c in string.split('')) {
    if (numberCharacters.contains(c)) {
      jsonNumber += c;
    } else {
      break;
    }
  }

  String rest = string.substring(jsonNumber.length);

  if (jsonNumber.isEmpty) {
    return {'value': null, 'rest': string};
  }

  if (jsonNumber.contains('.')) {
    return {'value': double.parse(jsonNumber), 'rest': rest};
  }

  return {'value': int.parse(jsonNumber), 'rest': rest};
}

Map<String, dynamic> lexBool(String string) {
  int stringLen = string.length;

  if (stringLen >= TRUE_LEN && string.substring(0, TRUE_LEN) == 'true') {
    return {'value': true, 'rest': string.substring(TRUE_LEN)};
  } else if (stringLen >= FALSE_LEN &&
      string.substring(0, FALSE_LEN) == 'false') {
    return {'value': false, 'rest': string.substring(FALSE_LEN)};
  }

  return {'value': null, 'rest': string};
}

Map<String, dynamic> lexNull(String string) {
  int stringLen = string.length;

  if (stringLen >= NULL_LEN && string.substring(0, NULL_LEN) == 'null') {
    return {'value': null, 'rest': string.substring(NULL_LEN)};
  }

  return {'value': null, 'rest': string};
}

List<dynamic> lex(String string) {
  List<dynamic> tokens = [];

  while (string.isNotEmpty) {
    var result = lexString(string);
    if (result['value'] != null) {
      tokens.add(result['value']);
      string = result['rest'];
      continue;
    }

    result = lexNumber(string);
    if (result['value'] != null) {
      tokens.add(result['value']);
      string = result['rest'];
      continue;
    }

    result = lexBool(string);
    if (result['value'] != null) {
      tokens.add(result['value']);
      string = result['rest'];
      continue;
    }

    result = lexNull(string);
    if (result['value'] != null) {
      tokens.add(result['value']);
      string = result['rest'];
      continue;
    }

    String c = string[0];

    if (JSON_WHITESPACE.contains(c)) {
      // Ignore whitespace
      string = string.substring(1);
    } else if (JSON_SYNTAX.contains(c)) {
      tokens.add(c);
      string = string.substring(1);
    } else {
      throw Exception('Unexpected character: $c');
    }
  }

  return tokens;
}
