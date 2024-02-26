import 'package:args/command_runner.dart';

import 'histogram_list_subcommand.dart';
import 'histogram_reset_subcommand.dart';

///
///
///
class HistogramCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'histogram';

  ///
  ///
  ///
  @override
  String get description => 'Based commands for histogram on the SwOS device';

  ///
  ///
  ///
  HistogramCommand() {
    addSubcommand(HistogramListSubcommand());
    addSubcommand(HistogramResetSubcommand());
  }
}
