// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'category_model.dart';

class BudgetModel {
  dynamic id;
  String name;
  double amount;
  double balance;
  CategoryModel? category;
  String? note;
  DateTime? startDate;
  DateTime? endDate;
  int day;
  int month;
  int year;

  BudgetModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.balance,
    this.category,
    this.note,
    this.startDate,
    this.endDate,
    required this.day,
    required this.month,
    required this.year,
  });
  

  BudgetModel copyWith({
    dynamic id,
    String? name,
    double? amount,
    double? balance,
    CategoryModel? category,
    String? note,
    DateTime? startDate,
    DateTime? endDate,
    int? day,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      category: category ?? this.category,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'balance': balance,
      'category': category?.toMap(),
      'note': note,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as dynamic,
      name: map['name'] as String,
      amount: map['amount'] as double,
      balance: map['balance'] as double,
      category: map['category'] != null ? CategoryModel.fromMap(map['category'] as Map<String,dynamic>) : null,
      note: map['note'] != null ? map['note'] as String : null,
      startDate: map['startDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int) : null,
      endDate: map['endDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int) : null,
      day: map['day'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) => BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, amount: $amount, balance: $balance, category: $category, note: $note, startDate: $startDate, endDate: $endDate, day: $day, month: $month, year: $year)';
  }

  @override
  bool operator ==(covariant BudgetModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      amount.hashCode ^
      balance.hashCode ^
      category.hashCode ^
      note.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      day.hashCode ^
      month.hashCode ^
      year.hashCode;
  }
}
