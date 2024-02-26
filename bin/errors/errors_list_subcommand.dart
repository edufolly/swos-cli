import '../stats/stats_list_subcommand.dart';

///
///
///
class ErrorsListSubcommand extends StatsListSubcommand {
  ///
  ///
  ///
  @override
  String get description => 'List the errors on the SwOS device';

  ///
  ///
  ///
  // TODO(edufolly): Create errors table.
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
  // TODO(edufolly): Create errors table.
  @override
  List<dynamic> buildRow(Map<String, dynamic> row) => <dynamic>[
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
