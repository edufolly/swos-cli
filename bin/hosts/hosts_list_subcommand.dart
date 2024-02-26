import '../abstract_read_command.dart';

///
///
///
class HostsListSubcommand extends AbstractReadCommand {
  ///
  ///
  ///
  @override
  String get name => 'list';

  ///
  ///
  ///
  @override
  String get description => 'List the hosts on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/!dhost.b';

  ///
  ///
  ///
  @override
  List<dynamic> get headers => <String>['Port', 'Address', 'Vlan ID'];

  ///
  ///
  ///
  @override
  List<dynamic> buildRow(Map<String, dynamic> row) => <dynamic>[
        (row['prt'] as int) + 1,
        macFormat(row['adr']),
        row['vid'],
      ];

  ///
  ///
  ///
  @override
  Comparator? get sort => (dynamic a, dynamic b) =>
      // ignore: avoid_dynamic_calls
      a[0].compareTo(b[0]);
}
