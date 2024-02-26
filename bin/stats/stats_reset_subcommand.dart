import 'package:agattp/agattp.dart';

import '../abstract_leaf_command.dart';
import '../config.dart';

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

    AgattpConfig config = const AgattpConfig(timeout: 5000);

    if (Config().user.isNotEmpty) {
      config = AgattpConfig(
        timeout: 5000,
        auth: AgattpAuthDigest(
          username: Config().user,
          password: Config().password,
        ),
      );
    }

    final AgattpResponse response = await Agattp(config: config).post(device);

    print(response.statusCode);
    print(response.body);
  }
}
