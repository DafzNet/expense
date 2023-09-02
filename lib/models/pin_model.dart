// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Pin {
  String pin;

  Pin(
    this.pin
  );

  Pin copyWith({
    String? pin,
  }) {
    return Pin(
      pin ?? this.pin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pin': pin,
    };
  }

  factory Pin.fromMap(Map<String, dynamic> map) {
    return Pin(
      map['pin'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pin.fromJson(String source) => Pin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pin(pin: $pin)';

  @override
  bool operator ==(covariant Pin other) {
    if (identical(this, other)) return true;
  
    return 
      other.pin == pin;
  }

  @override
  int get hashCode => pin.hashCode;
}
