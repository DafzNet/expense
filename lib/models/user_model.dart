import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class LightUser {
  dynamic id;
  String? firstName;
  String? lastName;
  String? email;

  LightUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  LightUser copyWith({
    dynamic id,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return LightUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  factory LightUser.fromMap(Map<String, dynamic> map) {
    return LightUser(
      id: map['id'] as dynamic,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LightUser.fromJson(String source) => LightUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LightUser(id: $id, firstName: $firstName, lastName: $lastName, email: $email)';
  }

  @override
  bool operator ==(covariant LightUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode;
  }
}
