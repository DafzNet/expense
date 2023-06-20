// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Settings {
  
  bool useCustomCurrency;
  String currencyCode;
  String currencySymbolPosition;

  DateTime? reminder;
  String? accountabilityEmail;


  Settings({
    this.useCustomCurrency = false,
    this.currencyCode = 'NGN',
    required this.currencySymbolPosition,
    this.reminder,
    this.accountabilityEmail,
  });
  

  Settings copyWith({
    bool? useCustomCurrency,
    String? currencyCode,
    String? currencySymbolPosition,
    DateTime? reminder,
    String? accountabilityEmail,
  }) {
    return Settings(
      useCustomCurrency: useCustomCurrency ?? this.useCustomCurrency,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbolPosition: currencySymbolPosition ?? this.currencySymbolPosition,
      reminder: reminder ?? this.reminder,
      accountabilityEmail: accountabilityEmail ?? this.accountabilityEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'useCustomCurrency': useCustomCurrency,
      'currencyCode': currencyCode,
      'currencySymbolPosition': currencySymbolPosition,
      'reminder': reminder?.millisecondsSinceEpoch,
      'accountabilityEmail': accountabilityEmail,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      useCustomCurrency: map['useCustomCurrency'] as bool,
      currencyCode: map['currencyCode'] as String,
      currencySymbolPosition: map['currencySymbolPosition'] as String,
      reminder: map['reminder'] != null ? DateTime.fromMillisecondsSinceEpoch(map['reminder'] as int) : null,
      accountabilityEmail: map['accountabilityEmail'] != null ? map['accountabilityEmail'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) => Settings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Settings(useCustomCurrency: $useCustomCurrency, currencyCode: $currencyCode, currencySymbolPosition: $currencySymbolPosition, reminder: $reminder, accountabilityEmail: $accountabilityEmail)';
  }

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) return true;
  
    return 
      other.useCustomCurrency == useCustomCurrency &&
      other.currencyCode == currencyCode &&
      other.currencySymbolPosition == currencySymbolPosition &&
      other.reminder == reminder &&
      other.accountabilityEmail == accountabilityEmail;
  }

  @override
  int get hashCode {
    return useCustomCurrency.hashCode ^
      currencyCode.hashCode ^
      currencySymbolPosition.hashCode ^
      reminder.hashCode ^
      accountabilityEmail.hashCode;
  }
}
