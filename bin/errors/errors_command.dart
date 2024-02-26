import 'package:args/command_runner.dart';

import 'errors_list_subcommand.dart';
import 'errors_reset_subcommand.dart';

///
///
///
class ErrorsCommand extends Command<void> {
  ///
  ///
  ///
  @override
  String get name => 'errors';

  ///
  ///
  ///
  @override
  String get description => 'Based commands for errors on the SwOS device';

  ///
  ///
  ///
  ErrorsCommand() {
    addSubcommand(ErrorsListSubcommand());
    addSubcommand(ErrorsResetSubcommand());
  }
}
