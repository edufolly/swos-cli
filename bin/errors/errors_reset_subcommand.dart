import '../stats/stats_reset_subcommand.dart';

///
///
///
class ErrorsResetSubcommand extends StatsResetSubcommand {
  ///
  ///
  ///
  @override
  String get description => 'Reset the errors on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/reseterrs';
}
