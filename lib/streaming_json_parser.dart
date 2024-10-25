library streaming_json_parser;

part 'lexer.dart';
part 'parser.dart';

Map<String, dynamic> parse(String jsonString) {
  var tokens = lex(jsonString);
  return parseTokens(tokens, isRoot: true)["value"];
}
