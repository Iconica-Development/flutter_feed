import 'dart:io';

import 'package:dart_feed_utilities_example/example.dart' as example;

void main(List<String> arguments) {
  final options = <String, void Function()>{
    "filters": example.runFilterExample,
  };
  var exampleToRun = options[arguments.firstOrNull];

  if (exampleToRun == null) {
    stdout.writeln(
      "No valid argument received, provide one of the following arguments: "
      "${options.keys.join(",")}",
    );
    exit(1);
  }

  exampleToRun();
}
