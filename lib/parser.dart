import 'lexer.dart';

List<dynamic> parseArray(List<dynamic> tokens) {
  List<dynamic> jsonArray = [];

  try {
    var t = tokens[0];
    if (t == JSON_RIGHTBRACKET) {
      return [jsonArray, tokens.sublist(1)];
    }

    while (true) {
      var result = parseTokens(tokens);

      var rest;
      var json;
      if (result is Map) {
        json = result['value'];
        rest = result['rest'];
      } else {
        json = result[0];
        rest = result[1];
      }

      jsonArray.add(json);
      t = rest[0];
      if (t == JSON_RIGHTBRACKET) {
        return [jsonArray, rest.sublist(1)];
      } else if (t != JSON_COMMA) {
        throw Exception('Expected comma after object in array');
      } else {
        tokens = rest.sublist(1);
      }
    }
  } catch (e) {
    return [jsonArray, tokens];
  }
}

Map<String, dynamic> parseObject(List<dynamic> tokens) {
  Map<String, dynamic> jsonObject = {};

  try {
    var t = tokens[0];
    if (t == JSON_RIGHTBRACE) {
      return {'value': jsonObject, 'rest': tokens.sublist(1)};
    }

    while (true) {
      var jsonKey = tokens[0];
      if (jsonKey is String) {
        tokens = tokens.sublist(1);
      } else {
        throw Exception('Expected string key, got: $jsonKey');
      }

      if (tokens[0] != JSON_COLON) {
        throw Exception(
            'Expected colon after key in object, got: ${tokens[0]}');
      }

      var result = parseTokens(tokens.sublist(1));
      var jsonValue = result[0];
      tokens = result[1];

      jsonObject[jsonKey] = jsonValue;

      t = tokens[0];
      if (t == JSON_RIGHTBRACE) {
        return {'value': jsonObject, 'rest': tokens.sublist(1)};
      } else if (t != JSON_COMMA) {
        throw Exception('Expected comma after pair in object, got: $t');
      }

      tokens = tokens.sublist(1);
    }
  } catch (e) {
    return {'value': jsonObject, 'rest': tokens};
  }
}

dynamic parseTokens(List<dynamic> tokens, {bool isRoot = false}) {
  var t = tokens[0];

  if (isRoot && t != JSON_LEFTBRACE) {
    throw Exception('Root must be an object');
  }

  if (t == JSON_LEFTBRACKET) {
    return parseArray(tokens.sublist(1));
  } else if (t == JSON_LEFTBRACE) {
    return parseObject(tokens.sublist(1));
  } else {
    return [t, tokens.sublist(1)];
  }
}
