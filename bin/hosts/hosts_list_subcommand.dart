import 'dart:convert';

import 'package:agattp/agattp.dart';
import 'package:cli_table/cli_table.dart';

import '../abstract_leaf_command.dart';
import '../config.dart';

///
///
///
class HostsListSubcommand extends AbstractLeafCommand {
  ///
  ///
  ///
  @override
  String get name => 'list';

  ///
  ///
  ///
  @override
  String get description => 'List the hosts on the SwOS device';

  ///
  ///
  ///
  @override
  Future<void> run() async {
    super.run();

    Uri? device = Uri.tryParse(argResults!['device'].toString());

    if (device == null) {
      throw ArgumentError('The device option is a invalid URL');
    }

    device = device.replace(path: '/!dhost.b');

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

    final AgattpResponse response = await Agattp(config: config).get(device);

    final String data = responseConvert(response.body);

    switch (argResults?['format'].toString()) {
      case 'json':
        print(data);
      case 'table':
        final List<dynamic> list = json.decode(data);

        final Table table = Table(
          style: const TableStyle(
            header: <String>['lightskyblue'],
          ),
          header: <String>['Port', 'Address', 'Vlan ID'],
        );

        for (final Map<String, dynamic> item in list) {
          table.add(<dynamic>[
            (item['prt'] as int) + 1,
            macConvert(item['adr']),
            item['vid'],
          ]);
        }

        table.sort((dynamic a, dynamic b) => a[0].compareTo(b[0]));

        print(table);
      default:
        throw ArgumentError('The format option is invalid');
    }
  }
}
