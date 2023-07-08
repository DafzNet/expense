// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense/models/plan_model.dart';

class PlanExpModel {
  dynamic id;
  PlannerModel planner;
  String name;
  DateTime? date;
  double price;
  int scaleOfPref;
  int satisfaction;

  PlanExpModel({
    required this.id,
    required this.planner,
    required this.name,
    this.date,
    required this.price,
    required this.scaleOfPref,
    required this.satisfaction,
  });


  PlanExpModel copyWith({
    dynamic? id,
    PlannerModel? planner,
    String? name,
    DateTime? date,
    double? price,
    int? scaleOfPref,
    int? satisfaction,
  }) {
    return PlanExpModel(
      id: id ?? this.id,
      planner: planner ?? this.planner,
      name: name ?? this.name,
      date: date ?? this.date,
      price: price ?? this.price,
      scaleOfPref: scaleOfPref ?? this.scaleOfPref,
      satisfaction: satisfaction ?? this.satisfaction,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'planner': planner.toMap(),
      'name': name,
      'date': date?.millisecondsSinceEpoch,
      'price': price,
      'scaleOfPref': scaleOfPref,
      'satisfaction': satisfaction,
    };
  }

  factory PlanExpModel.fromMap(Map<String, dynamic> map) {
    return PlanExpModel(
      id: map['id'] as dynamic,
      planner: PlannerModel.fromMap(map['planner'] as Map<String,dynamic>),
      name: map['name'] as String,
      date: map['date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int) : DateTime.now(),
      price: map['price'] as double,
      scaleOfPref: map['scaleOfPref'] as int,
      satisfaction: map['satisfaction'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanExpModel.fromJson(String source) => PlanExpModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlanExpModel(id: $id, planner: $planner, name: $name, date: $date, price: $price, scaleOfPref: $scaleOfPref, satisfaction: $satisfaction)';
  }

  @override
  bool operator ==(covariant PlanExpModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.planner == planner;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      planner.hashCode ^
      name.hashCode ^
      date.hashCode ^
      price.hashCode ^
      scaleOfPref.hashCode ^
      satisfaction.hashCode;
  }
}
