import 'package:flutter/material.dart';

class Debt {
  String name;
  String reason;
  double amount;
  bool owesMe;
  bool isSettled;
  DateTime dateAdded;

  Debt(
      {@required this.name,
      this.reason = '',
      @required this.amount,
      @required this.owesMe,
      this.isSettled = false,
      this.dateAdded}) {
    dateAdded = DateTime.now();
  }

  factory Debt.fromJson(Map jsonMap) {
    return Debt(
      name: jsonMap['name'],
      reason: jsonMap['reason'],
      amount: jsonMap['amount'],
      owesMe: jsonMap['owesMe'],
      isSettled: jsonMap['isSettled'],
      dateAdded: DateTime.parse(jsonMap['dateAdded']),
    );
  }

  Map toJson() => {
        'name': name,
        'reason': reason,
        'amount': amount,
        'owesMe': owesMe,
        'isSettled': isSettled,
        'dateAdded': dateAdded.toIso8601String(),
      };
}
