import '../stats/stats_list_subcommand.dart';

///
///
///
class HistogramListSubcommand extends StatsListSubcommand {
  ///
  ///
  ///
  @override
  String get description => 'List the histogram on the SwOS device';

  ///
  ///
  ///
  @override
  List<dynamic> get headers => <String>[
        'Port',
        '64',
        '65-127',
        '128-255',
        '256-511',
        '512-1023',
        '1024-max',
      ];

  ///
  ///
  ///
  @override
  List<dynamic> buildRow(Map<String, dynamic> row) => <dynamic>[
        (row['prt'] as int) + 1,
        row['p64'],
        row['p65'],
        row['p128'],
        row['p256'],
        row['p512'],
        row['p1k'],
      ];
}
