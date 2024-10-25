library streaming_json_parser;

import 'lexer.dart';
import 'parser.dart';

Map<String, dynamic> parse(String jsonString) {
  var tokens = lex(jsonString);
  return parseTokens(tokens, isRoot: true)["value"];
}
