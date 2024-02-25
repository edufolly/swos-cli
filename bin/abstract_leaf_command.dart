import 'package:args/command_runner.dart';

import 'config.dart';

///
///
///
abstract class AbstractLeafCommand extends Command<void> {
  ///
  ///
  ///
  AbstractLeafCommand() {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Print verbose output',
        callback: (bool verbose) => Config().verbose = verbose,
      )
      ..addOption(
        'user',
        abbr: 'u',
        help: 'The username to use when connecting to the SwOS device',
        callback: (String? user) {
          if (user?.isNotEmpty ?? false) {
            Config().user = user!;
          }
        },
      )
      ..addOption(
        'password',
        abbr: 'p',
        help: 'The password to use when connecting to the SwOS device',
        callback: (String? password) {
          if (password?.isNotEmpty ?? false) {
            Config().password = password!;
          }
        },
      )
      ..addOption(
        'device',
        abbr: 'd',
        help: 'The URL address of the SwOS device',
        valueHelp: 'http://10.0.10.90',
        mandatory: true,
      )
      ..addOption(
        'format',
        abbr: 'f',
        help: 'The output format',
        allowed: <String>['json', 'table'],
        defaultsTo: 'json',
      );
  }

  ///
  ///
  ///
  @override
  void run() {
    if (argResults?['device'] == null ||
        argResults!['device'].toString().isEmpty) {
      throw ArgumentError('The device option is required');
    }
  }

  ///
  ///
  ///
  String responseConvert(String data) => data
      .replaceAllMapped(
        RegExp(r"(\w+):'?([^',}]*)'?([,}])"),
        (Match match) =>
            '"${match.group(1)}": "${match.group(2)}"${match.group(3)}',
      )
      .replaceAllMapped(
        RegExp('"(0x[0-9a-fA-F]+)"'),
        (Match match) =>
            (int.tryParse(match.group(1).toString()) ?? 0).toString(),
      );

  ///
  ///
  ///
  String macConvert(dynamic data) => List<String>.generate(
        data.toString().length ~/ 2,
        (int i) => data.toString().substring(i * 2, i * 2 + 2),
      ).join(':');

  ///
  ///
  ///
  String textFormat(String data) {

    return 'vazio';
  }

}
