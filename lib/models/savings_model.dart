import 'dart:convert';

import 'package:expense/models/vault.dart';

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

  int? startDay;
  int? startMonth;
  int? startYear;

  int targetDay;
  int targetMonth;
  int targetYear;

  String? motivation;
  VaultModel? vault;
  
  TargetSavingModel({
    required this.id,
    this.targetPurpose,
    required this.targetAmount,
    required this.currentAmount,
    this.lastAddedAmount,
    required this.noOfMonth,
    required this.dateCreated,
    required this.targetDate,
    this.startDay,
    this.startMonth,
    this.startYear,
    required this.targetDay,
    required this.targetMonth,
    required this.targetYear,
    this.motivation,
    this.vault,
  });


  TargetSavingModel copyWith({
    dynamic? id,
    String? targetPurpose,
    double? targetAmount,
    double? currentAmount,
    double? lastAddedAmount,
    int? noOfMonth,
    DateTime? dateCreated,
    DateTime? targetDate,
    int? startDay,
    int? startMonth,
    int? startYear,
    int? targetDay,
    int? targetMonth,
    int? targetYear,
    String? motivation,
    VaultModel? vault,
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
      startDay: startDay ?? this.startDay,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      targetDay: targetDay ?? this.targetDay,
      targetMonth: targetMonth ?? this.targetMonth,
      targetYear: targetYear ?? this.targetYear,
      motivation: motivation ?? this.motivation,
      vault: vault ?? this.vault,
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
      'startDay': startDay,
      'startMonth': startMonth,
      'startYear': startYear,
      'targetDay': targetDay,
      'targetMonth': targetMonth,
      'targetYear': targetYear,
      'motivation': motivation,
      'vault': vault?.toMap(),
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
      startDay: map['startDay'] != null ? map['startDay'] as int : null,
      startMonth: map['startMonth'] != null ? map['startMonth'] as int : null,
      startYear: map['startYear'] != null ? map['startYear'] as int : null,
      targetDay: map['targetDay'] as int,
      targetMonth: map['targetMonth'] as int,
      targetYear: map['targetYear'] as int,
      motivation: map['motivation'] != null ? map['motivation'] as String : null,
      vault: map['vault'] != null ? VaultModel.fromMap(map['vault'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TargetSavingModel.fromJson(String source) => TargetSavingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TargetSavingModel(id: $id, targetPurpose: $targetPurpose, targetAmount: $targetAmount, currentAmount: $currentAmount, lastAddedAmount: $lastAddedAmount, noOfMonth: $noOfMonth, dateCreated: $dateCreated, targetDate: $targetDate, startDay: $startDay, startMonth: $startMonth, startYear: $startYear, targetDay: $targetDay, targetMonth: $targetMonth, targetYear: $targetYear, motivation: $motivation, vault: $vault)';
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
      other.startDay == startDay &&
      other.startMonth == startMonth &&
      other.startYear == startYear &&
      other.targetDay == targetDay &&
      other.targetMonth == targetMonth &&
      other.targetYear == targetYear &&
      other.motivation == motivation &&
      other.vault == vault;
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
      startDay.hashCode ^
      startMonth.hashCode ^
      startYear.hashCode ^
      targetDay.hashCode ^
      targetMonth.hashCode ^
      targetYear.hashCode ^
      motivation.hashCode ^
      vault.hashCode;
  }
}
