// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'category_model.dart';

class BudgetModel {
  dynamic id;
  double amount;
  double balance;
  CategoryModel? category;
  String? frequency;
  String? note;
  DateTime? date;
  int day;
  int month;
  int year;

  BudgetModel({
    required this.id,
    required this.amount,
    required this.balance,
    this.category,
    this.frequency,
    this.note,
    this.date,
    required this.day,
    required this.month,
    required this.year,
  });
  

  BudgetModel copyWith({
    dynamic? id,
    double? amount,
    double? balance,
    CategoryModel? category,
    String? frequency,
    String? note,
    DateTime? date,
    int? day,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      note: note ?? this.note,
      date: date ?? this.date,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'balance': balance,
      'category': category?.toMap(),
      'frequency': frequency,
      'note': note,
      'date': date?.millisecondsSinceEpoch,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as dynamic,
      amount: map['amount'] as double,
      balance: map['balance'] as double,
      category: map['category'] != null ? CategoryModel.fromMap(map['category'] as Map<String,dynamic>) : null,
      frequency: map['frequency'] != null ? map['frequency'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      date: map['date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int) : null,
      day: map['day'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) => BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(id: $id, amount: $amount, balance: $balance, category: $category, frequency: $frequency, note: $note, date: $date, day: $day, month: $month, year: $year)';
  }

  @override
  bool operator ==(covariant BudgetModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.amount == amount &&
      other.balance == balance &&
      other.category == category &&
      other.frequency == frequency &&
      other.note == note &&
      other.date == date &&
      other.day == day &&
      other.month == month &&
      other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      amount.hashCode ^
      balance.hashCode ^
      category.hashCode ^
      frequency.hashCode ^
      note.hashCode ^
      date.hashCode ^
      day.hashCode ^
      month.hashCode ^
      year.hashCode;
  }
}
