import '../stats/stats_reset_subcommand.dart';

///
///
///
class HistogramResetSubcommand extends StatsResetSubcommand {
  ///
  ///
  ///
  @override
  String get description => 'Reset the histogram on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/resethist';
}
