// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'category_model.dart';

class BudgetModel {
  dynamic id;
  double amount;
  CategoryModel? category;
  String? frequency;
  String? note;

  BudgetModel({
    required this.id,
    required this.amount,
    this.category,
    this.frequency,
    this.note,
  });
  

  BudgetModel copyWith({
    dynamic id,
    double? amount,
    CategoryModel? category,
    String? frequency,
    String? note,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'category': category?.toMap(),
      'frequency': frequency,
      'note': note,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as dynamic,
      amount: map['amount'] as double,
      category: map['category'] != null ? CategoryModel.fromMap(map['category'] as Map<String,dynamic>) : null,
      frequency: map['frequency'] != null ? map['frequency'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) => BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BudgetModel(id: $id, amount: $amount, category: $category, frequency: $frequency, note: $note)';
  }

  @override
  bool operator ==(covariant BudgetModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.amount == amount &&
      other.category == category &&
      other.frequency == frequency &&
      other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      amount.hashCode ^
      category.hashCode ^
      frequency.hashCode ^
      note.hashCode;
  }
}
