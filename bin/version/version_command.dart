import 'package:args/command_runner.dart';

import '../config.dart';

///
///
///
class VersionCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'version';

  ///
  ///
  ///
  @override
  String get description => 'Prints the version of the SwOS CLI';

  ///
  ///
  ///
  @override
  void run() {
    print('SwOS CLI version: ${Config.version}');
  }
}
