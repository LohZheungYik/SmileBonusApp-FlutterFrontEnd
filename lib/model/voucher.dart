class Voucher {
  int? id;
  String? name;
  String? description;
  String? code;
  double? cost;
  bool? isRedeemed;
  
  Voucher({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.cost,
    required this.isRedeemed,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] as int,
      name: json['name'],
      description: json['description'],
      code: json['code'],
      cost: json['cost'],
      isRedeemed: json['isRedeemed']
    );
  }

}
