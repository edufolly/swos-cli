import 'dart:convert';

import 'package:agattp/agattp.dart';
import 'package:cli_table/cli_table.dart';

import 'abstract_leaf_command.dart';

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
      allowed: <String>['raw', 'raw-json', 'json', 'table'],
      allowedHelp: <String, String>{
        'raw': 'Print the raw output',
        'raw-json': 'Print the raw output as valid JSON',
        'json': 'Print the output as JSON after transformation',
        'table': 'Print the output as a table',
      },
      defaultsTo: 'json',
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

    final String format = argResults?['format'].toString() ?? 'json';

    final AgattpResponse response = await agattp.get(device);

    if (format == 'raw') {
      print(response.body);
      return;
    }

    final String data = firstConvert(response.body).replaceAllMapped(
      RegExp('"?(0x[0-9a-fA-F]+)"?'),
      (Match match) =>
          (int.tryParse(match.group(1).toString()) ?? 0).toString(),
    );

    if (format == 'raw-json') {
      print(data);
      return;
    }

    final List<Map<String, dynamic>> list = transform(json.decode(data));

    if (format == 'json') {
      print(json.encode(list));
      return;
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

    print(table);
  }

  ///
  ///
  ///
  String macFormat(dynamic value) => RegExp('..')
      .allMatches(value.toString())
      .map((Match m) => m.group(0))
      .join(':');

  ///
  ///
  ///
  String shortNumber(dynamic value) {
    final num v = num.parse(value.toString());

    if (v < 1000) {
      return v.toString();
    }

    if (v < 1000000) {
      return '${(v / 1000).toStringAsFixed(1)}K';
    }

    if (v < 1000000000) {
      return '${(v / 1000000).toStringAsFixed(1)}M';
    }

    return '${(v / 1000000000).toStringAsFixed(1)}G';
  }

  ///
  ///
  ///
  String hexToString(dynamic value) => String.fromCharCodes(
        RegExp('..')
            .allMatches(value.toString())
            .map((Match m) => int.parse(m.group(0)!, radix: 16)),
      );

  ///
  ///
  ///
  String millisToString(dynamic value) {
    final Duration d =
        Duration(milliseconds: int.tryParse(value.toString()) ?? -1);

    return <String>[
      if (d.inDays > 0) '${d.inDays} day${d.inDays > 1 ? 's' : ''} ',
      '${(d.inHours % 24).toString().padLeft(2, '0')}:',
      '${(d.inMinutes % 60).toString().padLeft(2, '0')}:',
      (d.inSeconds % 60).toString().padLeft(2, '0'),
    ].join();
  }
}
