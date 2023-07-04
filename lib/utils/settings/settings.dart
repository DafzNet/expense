// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SettingsObj {
  dynamic id;
  String currencyCode;
  String currencySymbol;
  String currencySymbolPosition;

  DateTime? reminder;


  SettingsObj({
    required this.id,
    this.currencyCode = 'NGN',
    this.currencySymbol = '₦',
    this.currencySymbolPosition = 'Left',
    this.reminder,
  });

  @override
  int get hashCode {
    return id.hashCode ^
      currencyCode.hashCode ^
      currencySymbol.hashCode ^
      currencySymbolPosition.hashCode ^
      reminder.hashCode;
  }

  SettingsObj copyWith({
    dynamic id,
    String? currencyCode,
    String? currencySymbol,
    String? currencySymbolPosition,
    DateTime? reminder,
  }) {
    return SettingsObj(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencySymbolPosition: currencySymbolPosition ?? this.currencySymbolPosition,
      reminder: reminder ?? this.reminder,
    );
  }

  factory SettingsObj.fromMap(Map<String, dynamic> map) {
    return SettingsObj(
      id: map['id'] as dynamic,
      currencyCode: map['currencyCode'] as String,
      currencySymbol: map['currencySymbol'] as String,
      currencySymbolPosition: map['currencySymbolPosition'] as String,
      reminder: map['reminder'] != null ? DateTime.fromMillisecondsSinceEpoch(map['reminder'] as int) : null,
    );
  }

  factory SettingsObj.fromJson(String source) => SettingsObj.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'currencySymbolPosition': currencySymbolPosition,
      'reminder': reminder?.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SettingsObj(id: $id, currencyCode: $currencyCode, currencySymbol: $currencySymbol, currencySymbolPosition: $currencySymbolPosition, reminder: $reminder)';
  }

  @override
  bool operator ==(covariant SettingsObj other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.currencyCode == currencyCode &&
      other.currencySymbol == currencySymbol &&
      other.currencySymbolPosition == currencySymbolPosition &&
      other.reminder == reminder;
  }
}
