import 'package:args/command_runner.dart';

import 'system_list_subcommand.dart';
import 'system_reboot_subcommand.dart';

///
///
///
class SystemCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'system';

  ///
  ///
  ///
  @override
  String get description => 'Based system commands on the SwOS device';

  ///
  ///
  ///
  SystemCommand() {
    addSubcommand(SystemListSubcommand());
    addSubcommand(SystemRebootSubcommand());
  }
}
