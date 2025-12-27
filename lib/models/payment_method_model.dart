class PaymentMethod {
  int? id;
  String name;
  int userId; // references users.id

  PaymentMethod({
    this.id,
    required this.name,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'],
      name: map['name'],
      userId: map['user_id'],
    );
  }
}
