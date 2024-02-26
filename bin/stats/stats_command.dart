import 'package:args/command_runner.dart';

import 'stats_list_subcommand.dart';
import 'stats_reset_subcommand.dart';

///
///
///
class StatsCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'stats';

  ///
  ///
  ///
  @override
  String get description => 'Based commands for stats on the SwOS device';

  ///
  ///
  ///
  StatsCommand() {
    addSubcommand(StatsListSubcommand());
    addSubcommand(StatsResetSubcommand());
  }
}
