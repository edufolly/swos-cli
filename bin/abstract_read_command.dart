import 'dart:convert';

import 'package:agattp/agattp.dart';
import 'package:cli_table/cli_table.dart';

import 'abstract_leaf_command.dart';
import 'config.dart';

///
///
///
abstract class AbstractReadCommand extends AbstractLeafCommand {
  ///
  ///
  ///
  AbstractReadCommand() {
    argParser.addOption(
      'format',
      abbr: 'f',
      help: 'The output format',
      allowed: Format.allowed,
      allowedHelp: Format.allowedHelp,
      defaultsTo: Format.defaultValue.value,
    );
  }

  ///
  ///
  ///
  String firstConvert(String data) => data.replaceAllMapped(
        RegExp(r"(\w+):'?([^',}]*)'?([,}])"),
        (Match match) =>
            '"${match.group(1)}": "${match.group(2)}"${match.group(3)}',
      );

  ///
  ///
  ///
  List<dynamic>? get headers => null;

  ///
  ///
  ///
  dynamic buildRow(Map<String, dynamic> row);

  ///
  ///
  ///
  Comparator? get sort => null;

  ///
  ///
  ///
  List<Map<String, dynamic>> transform(dynamic json) => (json as List<dynamic>)
      .map(
        (dynamic item) => (item as Map<dynamic, dynamic>).map(
          (dynamic key, dynamic value) =>
              MapEntry<String, dynamic>(key.toString(), value),
        ),
      )
      .toList();

  ///
  ///
  ///
  @override
  Future<void> run() async {
    super.run();

    print(process(Format.fromString(argResults?['format'])));
  }

  ///
  ///
  ///
  Future<String> process(Format format, {String? device}) async {
    final Uri uri = getUri(device);

    if (Config().verbose) {
      print('GET: $uri');
    }

    final AgattpResponse response = await agattp.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to get data (${response.statusCode}).');
    }

    if (format == Format.raw) {
      return response.body;
    }

    final String data = firstConvert(response.body).replaceAllMapped(
      RegExp('"?(0x[0-9a-fA-F]+)"?'),
      (Match match) =>
          (int.tryParse(match.group(1).toString()) ?? 0).toString(),
    );

    if (format == Format.rawJson) {
      return data;
    }

    final List<Map<String, dynamic>> list = transform(json.decode(data));

    if (format == Format.json) {
      return json.encode(list);
    }

    final Table table = Table(
      style: const TableStyle(
        header: <String>['lightskyblue'],
      ),
      header: headers,
    );

    for (final Map<String, dynamic> row in list) {
      final dynamic bRow = buildRow(row);
      if (bRow != null) {
        table.add(bRow);
      }
    }

    if (sort != null) {
      table.sort(sort);
    }

    return table.toString();
  }
}
