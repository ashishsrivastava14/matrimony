/// Wallet Transaction model
class WalletTransaction {
  final String id;
  final String userId;
  final String type; // credit, debit, withdrawal
  final double amount;
  final String description;
  final String status; // pending, approved, rejected
  final DateTime date;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    this.status = 'pending',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  WalletTransaction copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? description,
    String? status,
    DateTime? date,
  }) {
    return WalletTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? 'credit',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
