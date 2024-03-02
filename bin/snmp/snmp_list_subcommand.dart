import 'package:chalkdart/chalkstrings.dart';

import '../abstract_read_command.dart';

///
///
///
class SnmpListSubcommand extends AbstractReadCommand {
  ///
  ///
  ///
  @override
  String get name => 'list';

  ///
  ///
  ///
  @override
  String get description => 'List the SNMP on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/snmp.b';

  ///
  ///
  ///
  @override
  List<Map<String, dynamic>> transform(dynamic json) {
    final Map<String, dynamic Function(dynamic value)> convert =
        <String, dynamic Function(dynamic value)>{
      'en': intToBool,
      'com': hexToString,
      'ci': hexToString,
      'loc': hexToString,
    };

    return (json as Map<String, dynamic>)
        .entries
        .map(
          (MapEntry<String, dynamic> entry) => <String, dynamic>{
            entry.key: convert.containsKey(entry.key)
                ? convert[entry.key]!.call(entry.value)
                : entry.value,
          },
        )
        .toList();
  }

  ///
  ///
  ///
  @override
  dynamic buildRow(Map<String, dynamic> row) => switch (row.keys.first) {
        'en' => <dynamic>[
            'Enabled',
            row['en']
                ? chalk.bgGreenBright.black('Yes')
                : chalk.bgRedBright.black('No'),
          ],
        'com' => <dynamic>['Community', row['com']],
        'ci' => <dynamic>['Contact Info', row['ci']],
        'loc' => <dynamic>['Location', row['loc']],
        _ => null
      };
}
