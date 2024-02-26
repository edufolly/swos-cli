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
      );
  }

  ///
  ///
  ///
  String get path;

  ///
  ///
  ///
  Uri get device {
    final Uri? device = Uri.tryParse(argResults!['device'].toString());

    if (device == null) {
      throw ArgumentError('The device option is a invalid URL');
    }

    return device.replace(path: path);
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
}
