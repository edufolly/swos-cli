import 'package:agattp/agattp.dart';
import 'package:args/command_runner.dart';

import 'config.dart';

///
///
///
enum Format {
  raw('raw', help: 'Print the raw output'),
  rawJson('raw-json', help: 'Print the raw output as valid JSON'),
  json('json', help: 'Print the output as JSON after transformation'),
  table('table', help: 'Print the output as a table');

  final String value;
  final String help;

  ///
  ///
  ///
  const Format(this.value, {required this.help});

  ///
  ///
  ///
  static Format get defaultValue => Format.json;

  ///
  ///
  ///
  static Format fromString(dynamic value) => switch (value.toString()) {
        'raw' => Format.raw,
        'raw-json' => Format.rawJson,
        'table' => Format.table,
        _ => defaultValue,
      };

  ///
  ///
  ///
  static List<String> get allowed =>
      Format.values.map((Format format) => format.value).toList();

  ///
  ///
  ///
  static Map<String, String> get allowedHelp => Format.values.asMap().map(
        (_, Format format) =>
            MapEntry<String, String>(format.value, format.help),
      );
}

///
///
///
abstract class AbstractLeafCommand extends Command<void> {
  ///
  ///
  ///
  AbstractLeafCommand() {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Print verbose output',
        callback: (bool verbose) => Config().verbose = verbose,
      )
      ..addOption(
        'user',
        abbr: 'u',
        help: 'The username to use when connecting to the SwOS device',
        callback: (String? user) {
          if (user?.isNotEmpty ?? false) {
            Config().user = user!;
          }
        },
      )
      ..addOption(
        'password',
        abbr: 'p',
        help: 'The password to use when connecting to the SwOS device',
        callback: (String? password) {
          if (password?.isNotEmpty ?? false) {
            Config().password = password!;
          }
        },
      )
      ..addOption(
        'device',
        abbr: 'd',
        help: 'The URL address of the SwOS device',
        valueHelp: 'http://10.0.10.90',
        mandatory: true,
      );
  }

  ///
  ///
  ///
  String get path;

  ///
  ///
  ///
  Agattp get agattp {
    AgattpConfig config = AgattpConfig(timeout: Config().timeout);

    if (Config().user.isNotEmpty) {
      config = AgattpConfig(
        timeout: Config().timeout,

        auth: AgattpAuthDigest(
          username: Config().user,
          password: Config().password,
        ),
      );
    }

    return Agattp(config: config);
  }

  ///
  ///
  ///
  Uri getUri([String? d]) {
    final Uri? device =
        Uri.tryParse(argResults?['device'].toString() ?? d ?? '');

    if (device == null) {
      throw ArgumentError('The device option is a invalid URL');
    }

    return device.replace(path: path);
  }

  ///
  ///
  ///
  @override
  void run() {
    if (argResults?['device'] == null ||
        argResults!['device'].toString().isEmpty) {
      throw ArgumentError('The device option is required');
    }
  }

  ///
  ///
  ///
  String macFormat(dynamic value) => RegExp('..')
      .allMatches(value.toString())
      .map((Match m) => m.group(0))
      .join(':');

  ///
  ///
  ///
  String shortNumber(dynamic value) {
    final num v = num.parse(value.toString());

    if (v < 1000) {
      return v.toString();
    }

    if (v < 1000000) {
      return '${(v / 1000).toStringAsFixed(1)}K';
    }

    if (v < 1000000000) {
      return '${(v / 1000000).toStringAsFixed(1)}M';
    }

    return '${(v / 1000000000).toStringAsFixed(1)}G';
  }

  ///
  ///
  ///
  String hexToString(dynamic value) => String.fromCharCodes(
        RegExp('..')
            .allMatches(value.toString())
            .map((Match m) => int.parse(m.group(0)!, radix: 16)),
      );

  ///
  ///
  ///
  String stringToHex(dynamic value) => value
      .toString()
      .codeUnits
      .map((int e) => e.toRadixString(16).padLeft(2, '0'))
      .join();

  ///
  ///
  ///
  String millisToString(dynamic value) {
    final Duration d =
        Duration(milliseconds: int.tryParse(value.toString()) ?? -1);

    return <String>[
      if (d.inDays > 0) '${d.inDays} day${d.inDays > 1 ? 's' : ''} ',
      '${(d.inHours % 24).toString().padLeft(2, '0')}:',
      '${(d.inMinutes % 60).toString().padLeft(2, '0')}:',
      (d.inSeconds % 60).toString().padLeft(2, '0'),
    ].join();
  }

  ///
  ///
  ///
  bool intToBool(dynamic value) => value.toString() == '1';

  ///
  ///
  ///
  String boolToHex(bool b) => b ? '0x01' : '0x00';
}
