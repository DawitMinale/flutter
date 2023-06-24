import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final DateTime createdOn;
  final String imagePath;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.createdOn,
    required this.imagePath,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      amount,
      date,
      createdOn,
      imagePath,
    ];
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    DateTime? createdOn,
    String? imagePath,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      createdOn: createdOn ?? this.createdOn,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toString(),
      'date': date.millisecondsSinceEpoch,
      'category': category,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'imagePath': imagePath,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: double.tryParse(map['amount']) ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      category: map['category'],
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      imagePath: map['imagePath'],
    );
  }

  @override
  bool get stringify => true;
}
