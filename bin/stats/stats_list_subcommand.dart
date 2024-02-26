import '../abstract_read_command.dart';

///
///
///
class StatsListSubcommand extends AbstractReadCommand {
  ///
  ///
  ///
  @override
  String get name => 'list';

  ///
  ///
  ///
  @override
  String get description => 'List the stats on the SwOS device';

  ///
  ///
  ///
  @override
  String get path => '/!stats.b';

  ///
  ///
  ///
  @override
  String firstConvert(String data) => data.replaceAllMapped(
        RegExp(r'(\w+):'),
        (Match match) => '"${match.group(1)}":',
      );

  // rrb => Rx Rate
  // trb => Tx Rate
  // rrp => Rx Packet Rate
  // trp => Tx Packet Rate
  // rb => Rx Bytes
  // tb => Tx Bytes
  // rtp => Rx Total Packets
  // ttp => Tx Total Packets

  // rup => Rx Unicasts
  // tup => Tx Unicasts
  // rbp => Rx Broadcasts
  // tbp => Tx Broadcasts
  // rmp => Rx Multicasts
  // tmp => Tx Multicasts
  // tq => Tx Queue
  // tqb => Tx Queue Bytes (kb)

  /*
  rb: Bytes recebidos (Received Bytes).
rbh: Bytes recebidos por porta.
tur: Taxa de utilização de recursos.
rup: Pacotes recebidos (Received Packets).
tdf: Tempo de espera para envio de dados.
rbp: Bytes recebidos por porta.
rmp: Máximo de pacotes recebidos.
p64: Pacotes de 64 bytes.
p65: Pacotes de 65 bytes.
p128: Pacotes de 128 bytes.
p256: Pacotes de 256 bytes.
p512: Pacotes de 512 bytes.
p1k: Pacotes de 1 kilobyte.
tb: Bytes transmitidos (Transmitted Bytes).
tbh: Bytes transmitidos por porta.
tup: Utilização de porta.
tec: Erros de transmissão.
tmp: Máximo de pacotes transmitidos.
tbp: Bytes transmitidos por porta.
tmc: Média de utilização de CPU.
tpp: Pacotes transmitidos.
rpp: Pacotes recebidos.
rov: Outros pacotes.
rr: Reset de rede.
fr: Reenvio de fluxo.
rae: Erros de ARP.
rte: Erros de transmissão de roteamento.
rfcs: Fluxo de controle de reinicialização de recebimento.
tcl: Pacotes perdidos.
tlc: Pacotes atrasados.
rtp: Pacotes retransmitidos.
ttp: Pacotes transmitidos.
rrb: Bytes recebidos de roteamento.
trb: Bytes transmitidos de roteamento.
rrp: Pacotes recebidos de roteamento.
trp: Pacotes transmitidos de roteamento.
ruph: Pacotes recebidos de roteamento por porta.
rmph: Máximo de pacotes recebidos de roteamento por porta.
rbph: Bytes recebidos de roteamento por porta.
tuph: Pacotes transmitidos de roteamento por porta.
tmph: Máximo de pacotes transmitidos de roteamento por porta.
tbph: Bytes transmitidos de roteamento por porta.
tq: Pacotes em fila.
tqb: Bytes em fila.
   */

  ///
  ///
  ///
  @override
  List<Map<String, dynamic>> transform(dynamic json) {
    final Map<String, List<int>> map = (json as Map<dynamic, dynamic>).map(
      (dynamic key, dynamic value) => MapEntry<String, List<int>>(
        key.toString(),
        (value as List<dynamic>)
            .map((dynamic e) => int.tryParse(e.toString()) ?? -1)
            .toList(),
      ),
    );

    final Map<String, int> multiplier = <String, int>{
      'rrb': 100,
      'trb': 100,
    };

    final List<String> keys = map.keys.toList();

    final List<Map<String, dynamic>> list = <Map<String, dynamic>>[];

    for (int index = 0; index < map[keys.first]!.length; index++) {
      final Map<String, dynamic> row = <String, dynamic>{'prt': index};

      for (final String key in keys) {
        row[key] = map[key]![index] * (multiplier[key] ?? 1);
      }

      list.add(row);
    }

    return list;
  }

  ///
  ///
  ///
  @override
  List<dynamic> get headers => <String>[
        'Port',
        'Rx Rate',
        'Tx Rate',
        'Rx Package\nRate',
        'Tx Package\nRate',
        'Rx Bytes',
        'Tx Bytes',
        'Rx Total\nPackets',
        'Tx Total\nPackets',
      ];

  ///
  ///
  ///
  @override
  List<dynamic> buildRow(Map<String, dynamic> row) => <dynamic>[
        (row['prt'] as int) + 1,
        shortNumber(row['rrb']),
        shortNumber(row['trb']),
        row['rrp'],
        row['trp'],
        shortNumber(row['rb']),
        shortNumber(row['tb']),
        shortNumber(row['rtp']),
        shortNumber(row['ttp']),
      ];
}
