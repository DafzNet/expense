// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense/models/vault.dart';

class IncomeModel {
  dynamic id;
  String? name;
  String? source;
  double amount;
  double balance;
  DateTime date;
  int? day;
  int? month;
  int? year;
  String? deductions;
  VaultModel? incomeVault;
  String? note;

  IncomeModel({
    required this.id,
    this.name,
    this.source,
    required this.amount,
    required this.balance,
    required this.date,
    this.day,
    this.month,
    this.year,
    this.deductions,
    this.incomeVault,
    this.note,
  });


  IncomeModel copyWith({
    dynamic id,
    String? name,
    String? source,
    double? amount,
    double? balance,
    DateTime? date,
    int? day,
    int? month,
    int? year,
    String? deductions,
    VaultModel? incomeVault,
    String? note,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      date: date ?? this.date,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      deductions: deductions ?? this.deductions,
      incomeVault: incomeVault ?? this.incomeVault,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'source': source,
      'amount': amount,
      'balance': balance,
      'date': date.millisecondsSinceEpoch,
      'day': day,
      'month': month,
      'year': year,
      'deductions': deductions,
      'incomeVault': incomeVault?.toMap(),
      'note': note,
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map['id'] as dynamic,
      name: map['name'] != null ? map['name'] as String : null,
      source: map['source'] != null ? map['source'] as String : null,
      amount: map['amount'] as double,
      balance: map['balance'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      day: map['day'] != null ? map['day'] as int : null,
      month: map['month'] != null ? map['month'] as int : null,
      year: map['year'] != null ? map['year'] as int : null,
      deductions: map['deductions'] != null ? map['deductions'] as String : null,
      incomeVault: map['incomeVault'] != null ? VaultModel.fromMap(map['incomeVault'] as Map<String,dynamic>) : null,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IncomeModel.fromJson(String source) => IncomeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IncomeModel(id: $id, name: $name, source: $source, amount: $amount, balance: $balance, date: $date, day: $day, month: $month, year: $year, deductions: $deductions, incomeVault: $incomeVault, note: $note)';
  }

  @override
  bool operator ==(covariant IncomeModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.source == source &&
      other.amount == amount &&
      other.balance == balance &&
      other.date == date &&
      other.day == day &&
      other.month == month &&
      other.year == year &&
      other.deductions == deductions &&
      other.incomeVault == incomeVault &&
      other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      source.hashCode ^
      amount.hashCode ^
      balance.hashCode ^
      date.hashCode ^
      day.hashCode ^
      month.hashCode ^
      year.hashCode ^
      deductions.hashCode ^
      incomeVault.hashCode ^
      note.hashCode;
  }
}
