class Customer {
  final int id;
  final String account;
  final String? password;
  final String type;

  Customer(
      {required this.id,
      required this.account,
      this.password,
      required this.type});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      account: json['name'],
      type: json['type'],
    );
  }
}
