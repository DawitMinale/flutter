import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime createdOn;

  Budget({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdOn,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      amount,
      createdOn,
    ];
  }

  Budget copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? createdOn,
  }) {
    return Budget(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toString(),
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      title: map['title'],
      amount: double.tryParse(map['amount']) ?? 0.0,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
    );
  }

  @override
  bool get stringify => true;
}
