class Expense {
  int? id;
  double amount;
  String? note;
  DateTime date;
  int userId;
  int categoryId;
  int paymentMethodId;

  Expense({
    this.id,
    required this.amount,
    this.note,
    required this.date,
    required this.userId,
    required this.categoryId,
    required this.paymentMethodId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
      'user_id': userId,
      'category_id': categoryId,
      'payment_method_id': paymentMethodId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    final dynamic rawAmount = map['amount'];
    double parsedAmount;
    if (rawAmount == null) {
      parsedAmount = 0.0;
    } else if (rawAmount is int) {
      parsedAmount = rawAmount.toDouble();
    } else if (rawAmount is double) {
      parsedAmount = rawAmount;
    } else {
      parsedAmount = double.tryParse(rawAmount.toString()) ?? 0.0;
    }

    return Expense(
      id: map['id'],
      amount: parsedAmount,
      note: map['note'],
      date: DateTime.parse(map['date']),
      userId: map['user_id'],
      categoryId: map['category_id'],
      paymentMethodId: map['payment_method_id'],
    );
  }
}
