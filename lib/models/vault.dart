// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VaultModel {
  dynamic id;
  String title;
  String? location; //where is this vault located: cash, box, bank
  
  VaultModel({
    required this.id,
    required this.title,
    this.location,
  });


  VaultModel copyWith({
    dynamic id,
    String? title,
    String? location,
  }) {
    return VaultModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'location': location,
    };
  }

  factory VaultModel.fromMap(Map<String, dynamic> map) {
    return VaultModel(
      id: map['id'] as dynamic,
      title: map['title'] as String,
      location: map['location'] != null ? map['location'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VaultModel.fromJson(String source) => VaultModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VaultModel(id: $id, title: $title, location: $location)';

  @override
  bool operator ==(covariant VaultModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.location == location;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ location.hashCode;
}
