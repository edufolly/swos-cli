import 'dart:io';

import 'package:args/command_runner.dart';

import 'config.dart';
import 'errors/errors_command.dart';
import 'histogram/histogram_command.dart';
import 'hosts/hosts_command.dart';
import 'stats/stats_command.dart';
import 'version/version_command.dart';

///
///
///
void main(List<String> arguments) {
  final CommandRunner<void> runner = CommandRunner<void>('swos', 'SwOS CLI')
    ..addCommand(ErrorsCommand())
    ..addCommand(HistogramCommand())
    ..addCommand(HostsCommand())
    ..addCommand(StatsCommand())
    ..addCommand(VersionCommand());

  String user = Platform.environment['SWOS_CLI_USER_FILE'] ?? '';

  if (user.isNotEmpty) {
    final File file = File(user);
    if (file.existsSync()) {
      user = file.readAsStringSync();
    }
  }

  if (user.isEmpty) {
    user = Platform.environment['SWOS_CLI_USER'] ?? '';
  }

  Config().user = user;

  String password = Platform.environment['SWOS_CLI_PASSWORD_FILE'] ?? '';

  if (password.isNotEmpty) {
    final File file = File(password);
    if (file.existsSync()) {
      password = file.readAsStringSync();
    }
  }

  if (password.isEmpty) {
    password = Platform.environment['SWOS_CLI_PASSWORD'] ?? '';
  }

  Config().password = password;

  runner.run(arguments).catchError((dynamic error) {
    stderr.writeln(error);
    exit(64);
  });
}
