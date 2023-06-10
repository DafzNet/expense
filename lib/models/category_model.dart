// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryModel {
  dynamic id;
  String name;
  String description;
  dynamic catIcon;
  
  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.catIcon,
  });

  

  CategoryModel copyWith({
    dynamic id,
    String? name,
    String? description,
    dynamic catIcon,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      catIcon: catIcon ?? this.catIcon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'catIcon': catIcon,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as dynamic,
      name: map['name'] as String,
      description: map['description'] as String,
      catIcon: map['catIcon'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description, catIcon: $catIcon)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.catIcon == catIcon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      catIcon.hashCode;
  }
}
