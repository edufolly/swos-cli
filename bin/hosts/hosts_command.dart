import 'package:args/command_runner.dart';

import 'hosts_list_subcommand.dart';

///
///
///
class HostsCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'hosts';

  ///
  ///
  ///
  @override
  String get description => 'Based commands for hosts on the SwOS device';

  ///
  ///
  ///
  HostsCommand() {
    addSubcommand(HostsListSubcommand());
  }
}
