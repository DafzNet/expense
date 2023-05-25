// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExpenseModel {
  dynamic id;
  String title;
  DateTime date;
  double amount;
  String? note;
  String? fundSource;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    this.note,
    this.fundSource,
  });

  ExpenseModel copyWith({
    dynamic? id,
    String? title,
    DateTime? date,
    double? amount,
    String? note,
    String? fundSource,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      fundSource: fundSource ?? this.fundSource,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'note': note,
      'fundSource': fundSource,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as dynamic,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as double,
      note: map['note'] != null ? map['note'] as String : null,
      fundSource: map['fundSource'] != null ? map['fundSource'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpenseModel(id: $id, title: $title, date: $date, amount: $amount, note: $note, fundSource: $fundSource)';
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
      other.fundSource == fundSource;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      note.hashCode ^
      fundSource.hashCode;
  }


  double get percentage{
    return amount.toDouble();
  }
}
