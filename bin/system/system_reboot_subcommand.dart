import 'package:agattp/agattp.dart';

import '../abstract_leaf_command.dart';

///
///
///
class SystemRebootSubcommand extends AbstractLeafCommand {
  ///
  ///
  ///
  @override
  String get name => 'reboot';

  ///
  ///
  ///
  @override
  String get description => 'Reboot the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/reboot';

  ///
  ///
  ///
  @override
  Future<void> run() async {
    super.run();

    final AgattpResponse response = await agattp.post(device);

    if (response.statusCode != 200) {
      throw Exception('Failed to reboot.');
    }
  }
}
