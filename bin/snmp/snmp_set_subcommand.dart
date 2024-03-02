import 'dart:convert';

import 'package:agattp/agattp.dart';

import '../abstract_leaf_command.dart';
import '../config.dart';
import 'snmp_list_subcommand.dart';

///
///
///
class SnmpSetSubcommand extends AbstractLeafCommand {
  ///
  ///
  ///
  @override
  String get name => 'set';

  ///
  ///
  ///
  @override
  String get description => 'Set the SNMP on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/snmp.b';

  ///
  ///
  ///
  SnmpSetSubcommand() {
    argParser
      ..addOption(
        'enable',
        abbr: 'e',
        help: 'Enable or disable SNMP',
        valueHelp: 'true|false',
        allowed: <String>['true', 'false'],
        allowedHelp: <String, String>{
          'true': 'Enable SNMP',
          'false': 'Disable SNMP',
        },
      )
      ..addOption(
        'community',
        abbr: 'c',
        help: 'The SNMP community string',
        valueHelp: 'public',
      )
      ..addOption(
        'contact',
        abbr: 'C',
        help: 'The contact information',
        valueHelp: 'John Doe',
      )
      ..addOption(
        'location',
        abbr: 'l',
        help: 'The location information',
        valueHelp: 'Home',
      );
  }

  ///
  ///
  ///
  @override
  Future<void> run() async {
    super.run();

    final String device = argResults!['device'].toString();

    final String jsonText =
        await SnmpListSubcommand().process(Format.rawJson, device: device);

    final Map<String, dynamic> map = json.decode(jsonText);

    final String enable = boolToHex(
      bool.tryParse(argResults!['enable']) ?? intToBool(map['en'] ?? 0),
    );

    final String community =
        (argResults?['community']?.toString().isNotEmpty ?? false)
            ? stringToHex(argResults?['community'])
            : map['com'];

    final String contact = argResults?['contact'] != null
        ? stringToHex(argResults?['contact'])
        : map['ci'];

    final String location = argResults?['location'] != null
        ? stringToHex(argResults?['location'])
        : map['loc'];

    final String body =
        "{en:$enable,com:'$community',ci:'$contact',loc:'$location'}";

    final Uri uri = getUri();

    if (Config().verbose) {
      print('POST: $uri');
    }

    final AgattpResponse response = await agattp.post(
      uri,
      headers: <String, String>{
        'Content-Length': '${body.length}',
        'Content-Type': 'text/plain',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set SNMP (${response.statusCode}).');
    }
  }
}
