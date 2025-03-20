import 'dart:convert';

List<Expansion> expansionFromJson(String str) => List<Expansion>.from(json.decode(str).map((x) => Expansion.fromJson(x)));

String expansionToJson(List<Expansion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Expansion {
  int expansionId;
  String expansionName;
  String expansionCode;
  String symbol;
  int printedTotal;
  String logo;
  String series;

  Expansion({
    required this.expansionId,
    required this.expansionName,
    required this.expansionCode,
    required this.symbol,
    required this.printedTotal,
    required this.logo,
    required this.series,
  });

  factory Expansion.fromJson(Map<String, dynamic> json) => Expansion(
    expansionId: json["expansion_id"],
    expansionName: json["expansion_name"],
    expansionCode: json["expansion_code"],
    symbol: json["symbol"],
    printedTotal: json["printed_total"],
    logo: json["logo"],
    series: json["series"],
  );

  Map<String, dynamic> toJson() => {
    "expansion_id": expansionId,
    "expansion_name": expansionName,
    "expansion_code": expansionCode,
    "symbol": symbol,
    "printed_total": printedTotal,
    "logo": logo,
    "series": series,
  };
}