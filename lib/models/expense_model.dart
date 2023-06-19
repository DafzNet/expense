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
  int day;
  int month;
  int year;
  CategoryModel? category;
  IncomeModel? income;
  BudgetModel? budget;
  
  ExpenseModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    this.note,
    required this.day,
    required this.month,
    required this.year,
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
    int? day,
    int? month,
    int? year,
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
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
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
      'day': day,
      'month': month,
      'year': year,
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
      day: map['day'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
      category: map['category'] != null ? CategoryModel.fromMap(map['category'] as Map<String,dynamic>) : null,
      income: map['income'] != null ? IncomeModel.fromMap(map['income'] as Map<String,dynamic>) : null,
      budget: map['budget'] != null ? BudgetModel.fromMap(map['budget'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpenseModel(id: $id, title: $title, date: $date, amount: $amount, note: $note, day: $day, month: $month, year: $year, category: $category, income: $income, budget: $budget)';
  }

  @override
  bool operator ==(covariant ExpenseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      note.hashCode ^
      day.hashCode ^
      month.hashCode ^
      year.hashCode ^
      category.hashCode ^
      income.hashCode ^
      budget.hashCode;
  }


  double get percentage{
    return amount.toDouble();
  }
}
