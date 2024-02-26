import 'package:agattp/agattp.dart';

import '../abstract_leaf_command.dart';

///
///
///
class StatsResetSubcommand extends AbstractLeafCommand {
  ///
  ///
  ///
  @override
  String get name => 'reset';

  ///
  ///
  ///
  @override
  String get description => 'Reset the stats on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/resetstats';

  ///
  ///
  ///
  @override
  Future<void> run() async {
    super.run();

    final AgattpResponse response = await agattp.post(device);

    if (response.statusCode != 200) {
      throw Exception('Failed to reset.');
    }
  }
}
