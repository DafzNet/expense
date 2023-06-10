import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TargetSavingModel {

  dynamic id;
  String? targetPurpose;

  double targetAmount;
  double currentAmount;
  double? lastAddedAmount;
  int noOfMonth;

  DateTime dateCreated;
  DateTime targetDate;

  String? motivation;
  String? platform;
  
  TargetSavingModel({
    required this.id,
    this.targetPurpose,
    required this.targetAmount,
    required this.currentAmount,
    this.lastAddedAmount,
    required this.noOfMonth,
    required this.dateCreated,
    required this.targetDate,
    this.motivation,
    this.platform,
  });


  TargetSavingModel copyWith({
    dynamic id,
    String? targetPurpose,
    double? targetAmount,
    double? currentAmount,
    double? lastAddedAmount,
    int? noOfMonth,
    DateTime? dateCreated,
    DateTime? targetDate,
    String? motivation,
    String? platform,
  }) {
    return TargetSavingModel(
      id: id ?? this.id,
      targetPurpose: targetPurpose ?? this.targetPurpose,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      lastAddedAmount: lastAddedAmount ?? this.lastAddedAmount,
      noOfMonth: noOfMonth ?? this.noOfMonth,
      dateCreated: dateCreated ?? this.dateCreated,
      targetDate: targetDate ?? this.targetDate,
      motivation: motivation ?? this.motivation,
      platform: platform ?? this.platform,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'targetPurpose': targetPurpose,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'lastAddedAmount': lastAddedAmount,
      'noOfMonth': noOfMonth,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'targetDate': targetDate.millisecondsSinceEpoch,
      'motivation': motivation,
      'platform': platform,
    };
  }

  factory TargetSavingModel.fromMap(Map<String, dynamic> map) {
    return TargetSavingModel(
      id: map['id'] as dynamic,
      targetPurpose: map['targetPurpose'] != null ? map['targetPurpose'] as String : null,
      targetAmount: map['targetAmount'] as double,
      currentAmount: map['currentAmount'] as double,
      lastAddedAmount: map['lastAddedAmount'] != null ? map['lastAddedAmount'] as double : null,
      noOfMonth: map['noOfMonth'] as int,
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      targetDate: DateTime.fromMillisecondsSinceEpoch(map['targetDate'] as int),
      motivation: map['motivation'] != null ? map['motivation'] as String : null,
      platform: map['platform'] != null ? map['platform'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TargetSavingModel.fromJson(String source) => TargetSavingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TargetSavingModel(id: $id, targetPurpose: $targetPurpose, targetAmount: $targetAmount, currentAmount: $currentAmount, lastAddedAmount: $lastAddedAmount, noOfMonth: $noOfMonth, dateCreated: $dateCreated, targetDate: $targetDate, motivation: $motivation, platform: $platform)';
  }

  @override
  bool operator ==(covariant TargetSavingModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.targetPurpose == targetPurpose &&
      other.targetAmount == targetAmount &&
      other.currentAmount == currentAmount &&
      other.lastAddedAmount == lastAddedAmount &&
      other.noOfMonth == noOfMonth &&
      other.dateCreated == dateCreated &&
      other.targetDate == targetDate &&
      other.motivation == motivation &&
      other.platform == platform;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      targetPurpose.hashCode ^
      targetAmount.hashCode ^
      currentAmount.hashCode ^
      lastAddedAmount.hashCode ^
      noOfMonth.hashCode ^
      dateCreated.hashCode ^
      targetDate.hashCode ^
      motivation.hashCode ^
      platform.hashCode;
  }
}
