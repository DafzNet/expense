// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SettingsObj {
  dynamic id;
  String currencyCode;
  String currencySymbol;
  String currencySymbolPosition;

  DateTime? reminder;
  bool pin;


  SettingsObj({
    required this.id,
    this.currencyCode = 'NGN',
    this.currencySymbol = '₦',
    this.currencySymbolPosition = 'Left',
    this.reminder,
    this.pin = false
  });

  @override
  int get hashCode {
    return id.hashCode ^
      currencyCode.hashCode ^
      currencySymbol.hashCode ^
      currencySymbolPosition.hashCode ^
      reminder.hashCode ^
      pin.hashCode;
  }

  SettingsObj copyWith({
    dynamic? id,
    String? currencyCode,
    String? currencySymbol,
    String? currencySymbolPosition,
    DateTime? reminder,
    bool? pin,
  }) {
    return SettingsObj(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencySymbolPosition: currencySymbolPosition ?? this.currencySymbolPosition,
      reminder: reminder ?? this.reminder,
      pin: pin ?? this.pin,
    );
  }

  factory SettingsObj.fromMap(Map<String, dynamic> map) {
    return SettingsObj(
      id: map['id'] as dynamic,
      currencyCode: map['currencyCode'] as String,
      currencySymbol: map['currencySymbol'] as String,
      currencySymbolPosition: map['currencySymbolPosition'] as String,
      reminder: map['reminder'] != null ? DateTime.fromMillisecondsSinceEpoch(map['reminder'] as int) : null,
      pin: map['pin']??false as bool,
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
      'pin': pin,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SettingsObj(id: $id, currencyCode: $currencyCode, currencySymbol: $currencySymbol, currencySymbolPosition: $currencySymbolPosition, reminder: $reminder, pin: $pin)';
  }

  @override
  bool operator ==(covariant SettingsObj other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }
}
