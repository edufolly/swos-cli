import 'package:args/command_runner.dart';

import 'snmp_list_subcommand.dart';
import 'snmp_set_subcommand.dart';

///
///
///
class SnmpCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'snmp';

  ///
  ///
  ///
  @override
  String get description => 'SNMP commands for the SwOS device';

  ///
  ///
  ///
  SnmpCommand() {
    addSubcommand(SnmpListSubcommand());
    addSubcommand(SnmpSetSubcommand());
  }
}
