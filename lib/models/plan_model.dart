// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense/models/budget.dart';

class PlannerModel {
  dynamic id;
  String? name;
  BudgetModel? budget;
  String? description;
  PlannerModel({
    required this.id,
    this.name,
    this.budget,
    this.description,
  });



  PlannerModel copyWith({
    dynamic? id,
    String? name,
    BudgetModel? budget,
    String? description,
  }) {
    return PlannerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      budget: budget ?? this.budget,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'budget': budget?.toMap(),
      'description': description,
    };
  }

  factory PlannerModel.fromMap(Map<String, dynamic> map) {
    return PlannerModel(
      id: map['id'] as dynamic,
      name: map['name'] != null ? map['name'] as String : null,
      budget: map['budget'] != null ? BudgetModel.fromMap(map['budget'] as Map<String,dynamic>) : null,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlannerModel.fromJson(String source) => PlannerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlannerModel(id: $id, name: $name, budget: $budget, description: $description)';
  }

  @override
  bool operator ==(covariant PlannerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      budget.hashCode ^
      description.hashCode;
  }
}
