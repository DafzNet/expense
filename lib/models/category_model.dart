// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryModel {
  dynamic id;
  String name;
  bool hidden;
  String description;
  
  CategoryModel({
    required this.id,
    required this.name,
    this.hidden = false,
    required this.description,
  });

  

  CategoryModel copyWith({
    dynamic? id,
    String? name,
    bool? hidden,
    String? description,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      hidden: hidden ?? this.hidden,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hidden': hidden,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as dynamic,
      name: map['name'] as String,
      hidden: map['hidden'] as bool,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, hidden: $hidden, description: $description)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.hidden == hidden &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      hidden.hashCode ^
      description.hashCode;
  }
}
