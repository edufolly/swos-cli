import 'package:chalkdart/chalk.dart';

import '../abstract_read_command.dart';

///
///
///
class SystemListSubcommand extends AbstractReadCommand {
  ///
  ///
  ///
  @override
  String get name => 'list';

  ///
  ///
  ///
  @override
  String get description => 'List the system on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/sys.b';

  ///
  ///
  ///
  @override
  List<Map<String, dynamic>> transform(dynamic json) {
    final Map<String, dynamic Function(dynamic value)> convert =
        <String, dynamic Function(dynamic value)>{
      'upt': (dynamic value) => (int.tryParse(value.toString()) ?? -1) * 10,
      'mac': macFormat,
      'brd': hexToString,
      'sid': hexToString,
      'id': hexToString,
      'temp': (dynamic value) => int.tryParse(value.toString()),
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
        'upt' => <dynamic>['Uptime', millisToString(row['upt'])],
        'mac' => <dynamic>['MAC Address', row['mac']],
        'brd' => <dynamic>['Model', row['brd']],
        'sid' => <dynamic>['Serial Number', row['sid']],
        'id' => <dynamic>['Identity', row['id']],
        'temp' => <dynamic>[
            'Temperature',
            switch (row['temp']) {
              < 30 => chalk.bgGreenBright,
              < 60 => chalk.bgYellowBright,
              < 90 => chalk.bgRedBright,
              _ => chalk.bgMagentaBright
            }
                .black(' ${row['temp']}°C '),
          ],
        _ => null
      };
}
