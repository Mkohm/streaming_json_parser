<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

This dart package parses incomplete or "streaming" JSON which is useful for parsing JSON from a
stream. For example when you want intermediate parsing results while waiting for the complete JSON
to
arrive.

It is not suitable for parsing large JSON documents as a stream since the parser starts
from scratch whenever you call the `parse` method. 

It is based on the code provided by https://github.com/eatonphil/pj and modified slightly to support
parsing incomplete JSON.

## Features

- Parses incomplete JSON

## Getting started

In the `pubspec.yaml`, add the following dependency:

```yaml
dependencies:
  streaming_json_parser: ^0.0.2
```

In your library file add the following import:

```dart
import 'package:streaming_json_parser/streaming_json_parser.dart';
```


## Usage

```dart
import 'package:streaming_json_parser/streaming_json_parser.dart';

parse('{'); // returns {}
parse('{"key": "value", "someOtherIncomplet'); // returns {"key": "value"}
parse('{"key": ["value", "value2'); // returns {"key": ["value", "value2"]}
```
