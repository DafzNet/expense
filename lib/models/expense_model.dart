// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'budget.dart';
import 'category_model.dart';
import 'income_model.dart';

class ExpenseModel {
  dynamic id;
  String title;
  DateTime date;
  double amount;
  String? note;
  int? month;
  CategoryModel? category;
  IncomeModel? income;
  BudgetModel? budget;
  
  ExpenseModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    this.note,
    this.month,
    this.category,
    this.income,
    this.budget,
  });

  ExpenseModel copyWith({
    dynamic id,
    String? title,
    DateTime? date,
    double? amount,
    String? note,
    int? month,
    CategoryModel? category,
    IncomeModel? income,
    BudgetModel? budget,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      month: month ?? this.month,
      category: category ?? this.category,
      income: income ?? this.income,
      budget: budget ?? this.budget,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'note': note,
      'month': month,
      'category': category?.toMap(),
      'income': income?.toMap(),
      'budget': budget?.toMap(),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as dynamic,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as double,
      note: map['note'] != null ? map['note'] as String : null,
      month: map['month'] != null ? map['month'] as int : null,
      category: map['category'] != null ? CategoryModel.fromMap(map['category'] as Map<String,dynamic>) : null,
      income: map['income'] != null ? IncomeModel.fromMap(map['income'] as Map<String,dynamic>) : null,
      budget: map['budget'] != null ? BudgetModel.fromMap(map['budget'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpenseModel(id: $id, title: $title, date: $date, amount: $amount, note: $note, month: $month, category: $category, income: $income, budget: $budget)';
  }

  @override
  bool operator ==(covariant ExpenseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.amount == amount &&
      other.note == note &&
      other.month == month &&
      other.category == category &&
      other.income == income &&
      other.budget == budget;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      note.hashCode ^
      month.hashCode ^
      category.hashCode ^
      income.hashCode ^
      budget.hashCode;
  }


  double get percentage{
    return amount.toDouble();
  }
}
