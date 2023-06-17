// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VaultModel {
  dynamic id;
  String name;
  double amountInVault;
  String? type; //where is this vault located: cash, box, bank
  DateTime dateCreated;

  VaultModel({
    required this.id,
    required this.name,
    required this.amountInVault,
    this.type,
    required this.dateCreated
  });


  VaultModel copyWith({
    dynamic id,
    String? name,
    double? amountInVault,
    String? type,
    DateTime? dateCreated,
  }) {
    return VaultModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amountInVault: amountInVault ?? this.amountInVault,
      type: type ?? this.type,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amountInVault': amountInVault,
      'type': type,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
    };
  }

  factory VaultModel.fromMap(Map<String, dynamic> map) {
    return VaultModel(
      id: map['id'] as dynamic,
      name: map['name'] as String,
      amountInVault: map['amountInVault'] as double,
      type: map['type'] != null ? map['type'] as String : null,
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory VaultModel.fromJson(String source) => VaultModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VaultModel(id: $id, name: $name, amountInVault: $amountInVault, type: $type, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(covariant VaultModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.amountInVault == amountInVault &&
      other.type == type &&
      other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      amountInVault.hashCode ^
      type.hashCode ^
      dateCreated.hashCode;
  }
}
