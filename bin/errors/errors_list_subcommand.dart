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
  @override
  List<dynamic> get headers => <String>[
        'Port',
        'Rx Pauses',
        'Rx MAC\nErrors',
        'Rx FCS\nErrors',
        'Rx Jabber',
        'Rx Runts',
        'Rx Fragments',
        'Rx Overruns',
        'Tx Pauses',
        'Tx Underruns',
        'Tx Collisions',
        'Tx Multiple\nCollisions',
        'Tx Excessive\nCollisions',
        'Tx Late\nCollisions',
        'Tx Deferred',
      ];

  ///
  ///
  ///
  @override
  dynamic buildRow(Map<String, dynamic> row) => <dynamic>[
        (row['prt'] as int) + 1,
        row['rpp'],
        row['rte'],
        row['rfcs'],
        row['rae'],
        row['rr'],
        row['fr'],
        row['rov'],
        row['tpp'],
        row['tur'],
        row['tcl'],
        row['tmc'],
        row['tec'],
        row['tlc'],
        row['tdf'],
      ];
}
