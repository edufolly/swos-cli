import '../abstract_read_command.dart';

///
///
///
class StatsListSubcommand extends AbstractReadCommand {
  ///
  ///
  ///
  @override
  String get name => 'list';

  ///
  ///
  ///
  @override
  String get description => 'List the stats on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/!stats.b';

  ///
  ///
  ///
  @override
  String firstConvert(String data) => data.replaceAllMapped(
        RegExp(r'(\w+):'),
        (Match match) => '"${match.group(1)}":',
      );

  ///
  ///
  ///
  @override
  List<Map<String, dynamic>> transform(dynamic json) {
    final Map<String, List<int>> map = (json as Map<dynamic, dynamic>).map(
      (dynamic key, dynamic value) => MapEntry<String, List<int>>(
        key.toString(),
        (value as List<dynamic>)
            .map((dynamic e) => int.tryParse(e.toString()) ?? -1)
            .toList(),
      ),
    );

    final Map<String, int> multiplier = <String, int>{
      'rrb': 100,
      'trb': 100,
    };

    final List<String> keys = map.keys.toList();

    final List<Map<String, dynamic>> list = <Map<String, dynamic>>[];

    for (int index = 0; index < map[keys.first]!.length; index++) {
      final Map<String, dynamic> row = <String, dynamic>{'prt': index};

      for (final String key in keys) {
        row[key] = map[key]![index] * (multiplier[key] ?? 1);
      }

      list.add(row);
    }

    return list;
  }

  ///
  ///
  ///
  @override
  List<dynamic> get headers => <String>[
        'Port',
        'Rx Rate',
        'Tx Rate',
        'Rx Package\nRate',
        'Tx Package\nRate',
        'Rx Bytes',
        'Tx Bytes',
        'Rx Total\nPackets',
        'Tx Total\nPackets',
      ];

  ///
  ///
  ///
  @override
  dynamic buildRow(Map<String, dynamic> row) => <dynamic>[
        (row['prt'] as int) + 1,
        shortNumber(row['rrb']),
        shortNumber(row['trb']),
        row['rrp'],
        row['trp'],
        shortNumber(row['rb']),
        shortNumber(row['tb']),
        shortNumber(row['rtp']),
        shortNumber(row['ttp']),
      ];
}
