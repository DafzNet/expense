// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense/dbs/versions.dart';

import '../firebase/db/vesion/version.dart';

/// The VersionModel class represents a model for storing version numbers of different database tables.

class VersionModel {
  dynamic id;

  int expenseDbVersion;
  int incomeDbVersion;
  int budgetDbVersion;
  int categoryDbVersion;
  int savingsDbVersion;
  int vaultDbVersion;
  int plannerDbVersion;
  int plannerExpDbVersion;
  int settingsDbVersion;

  VersionModel({
    required this.id,
    this.expenseDbVersion  = 0,
    this.incomeDbVersion = 0,
    this.budgetDbVersion = 0,
    this.categoryDbVersion = 0,
    this.savingsDbVersion = 0,
    this.vaultDbVersion = 0,
    this.plannerDbVersion = 0,
    this.plannerExpDbVersion = 0,
    this.settingsDbVersion = 0,
  });


  VersionModel copyWith({
    dynamic id,
    int? expenseDbVersion,
    int? incomeDbVersion,
    int? budgetDbVersion,
    int? categoryDbVersion,
    int? savingsDbVersion,
    int? vaultDbVersion,
    int? plannerDbVersion,
    int? plannerExpDbVersion,
    int? settingsDbVersion,
  }) {
    return VersionModel(
      id: id ?? this.id,
      expenseDbVersion: expenseDbVersion ?? this.expenseDbVersion,
      incomeDbVersion: incomeDbVersion ?? this.incomeDbVersion,
      budgetDbVersion: budgetDbVersion ?? this.budgetDbVersion,
      categoryDbVersion: categoryDbVersion ?? this.categoryDbVersion,
      savingsDbVersion: savingsDbVersion ?? this.savingsDbVersion,
      vaultDbVersion: vaultDbVersion ?? this.vaultDbVersion,
      plannerDbVersion: plannerDbVersion ?? this.plannerDbVersion,
      plannerExpDbVersion: plannerExpDbVersion ?? this.plannerExpDbVersion,
      settingsDbVersion: settingsDbVersion ?? this.settingsDbVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'expenseDbVersion': expenseDbVersion,
      'incomeDbVersion': incomeDbVersion,
      'budgetDbVersion': budgetDbVersion,
      'categoryDbVersion': categoryDbVersion,
      'savingsDbVersion': savingsDbVersion,
      'vaultDbVersion': vaultDbVersion,
      'plannerDbVersion': plannerDbVersion,
      'plannerExpDbVersion': plannerExpDbVersion,
      'settingsDbVersion': settingsDbVersion,
    };
  }

  factory VersionModel.fromMap(Map<String, dynamic> map) {
    return VersionModel(
      id: map['id'] as dynamic,
      expenseDbVersion: map['expenseDbVersion'] as int,
      incomeDbVersion: map['incomeDbVersion'] as int,
      budgetDbVersion: map['budgetDbVersion'] as int,
      categoryDbVersion: map['categoryDbVersion'] as int,
      savingsDbVersion: map['savingsDbVersion'] as int,
      vaultDbVersion: map['vaultDbVersion'] as int,
      plannerDbVersion: map['plannerDbVersion'] as int,
      plannerExpDbVersion: map['plannerExpDbVersion'] as int,
      settingsDbVersion: map['settingsDbVersion'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VersionModel.fromJson(String source) => VersionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VersionModel(id: $id, expenseDbVersion: $expenseDbVersion, incomeDbVersion: $incomeDbVersion, budgetDbVersion: $budgetDbVersion, categoryDbVersion: $categoryDbVersion, savingsDbVersion: $savingsDbVersion, vaultDbVersion: $vaultDbVersion, plannerDbVersion: $plannerDbVersion, plannerExpDbVersion: $plannerExpDbVersion, settingsDbVersion: $settingsDbVersion)';
  }

  @override
  bool operator ==(covariant VersionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.expenseDbVersion == expenseDbVersion &&
      other.incomeDbVersion == incomeDbVersion &&
      other.budgetDbVersion == budgetDbVersion &&
      other.categoryDbVersion == categoryDbVersion &&
      other.savingsDbVersion == savingsDbVersion &&
      other.vaultDbVersion == vaultDbVersion &&
      other.plannerDbVersion == plannerDbVersion &&
      other.plannerExpDbVersion == plannerExpDbVersion &&
      other.settingsDbVersion == settingsDbVersion;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      expenseDbVersion.hashCode ^
      incomeDbVersion.hashCode ^
      budgetDbVersion.hashCode ^
      categoryDbVersion.hashCode ^
      savingsDbVersion.hashCode ^
      vaultDbVersion.hashCode ^
      plannerDbVersion.hashCode ^
      plannerExpDbVersion.hashCode ^
      settingsDbVersion.hashCode;
  }
}



Future updateDbVersion(
  {
    int? expenseDbVersion,
    int? incomeDbVersion,
    int? budgetDbVersion,
    int? categoryDbVersion,
    int? savingsDbVersion,
    int? vaultDbVersion,
    int? plannerDbVersion,
    int? plannerExpDbVersion,
    int? settingsDbVersion,
  }
)async{

  final VersionDb versionDb = VersionDb();
  final existing = await versionDb.retrieveData();
  VersionModel? currentVersion = existing;

  VersionModel? updatedVersion;

  if (expenseDbVersion != null) {
    updatedVersion = currentVersion.copyWith(
      expenseDbVersion: currentVersion.expenseDbVersion + expenseDbVersion
    );
  } else if (incomeDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      incomeDbVersion: currentVersion.incomeDbVersion + incomeDbVersion
    );
  } else if (budgetDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      budgetDbVersion: currentVersion.budgetDbVersion + budgetDbVersion
    );
  }else if (categoryDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      categoryDbVersion: currentVersion.categoryDbVersion + categoryDbVersion
    );
  }else if (savingsDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      savingsDbVersion: currentVersion.savingsDbVersion + savingsDbVersion
    );
  }else if (vaultDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      vaultDbVersion: currentVersion.vaultDbVersion + vaultDbVersion
    );
  }else if (plannerDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      plannerDbVersion: currentVersion.plannerDbVersion + plannerDbVersion
    );
  }else if (plannerExpDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      plannerExpDbVersion: currentVersion.plannerExpDbVersion + plannerExpDbVersion
    );
  }else if (settingsDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      settingsDbVersion: currentVersion.settingsDbVersion + settingsDbVersion
    );
  }

  await versionDb.updateData(updatedVersion!);

}



/////////////////////////////////////////////

Future updateFirebaseDbVersion(
  uid,
  {
    int? expenseDbVersion,
    int? incomeDbVersion,
    int? budgetDbVersion,
    int? categoryDbVersion,
    int? savingsDbVersion,
    int? vaultDbVersion,
    int? plannerDbVersion,
    int? plannerExpDbVersion,
    int? settingsDbVersion,
  }
)async{

  final versionDb = FirebaseVersionDb(uid: uid);
  VersionModel? currentVersion = await versionDb.getVersion;

  VersionModel? updatedVersion;

  if (expenseDbVersion != null) {
    updatedVersion = currentVersion.copyWith(
      expenseDbVersion: currentVersion.expenseDbVersion + expenseDbVersion
    );
  } else if (incomeDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      incomeDbVersion: currentVersion.incomeDbVersion + incomeDbVersion
    );
  } else if (budgetDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      budgetDbVersion: currentVersion.budgetDbVersion + budgetDbVersion
    );
  }else if (categoryDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      categoryDbVersion: currentVersion.categoryDbVersion + categoryDbVersion
    );
  }else if (savingsDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      savingsDbVersion: currentVersion.savingsDbVersion + savingsDbVersion
    );
  }else if (vaultDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      vaultDbVersion: currentVersion.vaultDbVersion + vaultDbVersion
    );
  }else if (plannerDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      plannerDbVersion: currentVersion.plannerDbVersion + plannerDbVersion
    );
  }else if (plannerExpDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      plannerExpDbVersion: currentVersion.plannerExpDbVersion + plannerExpDbVersion
    );
  }else if (settingsDbVersion != null){
    updatedVersion = currentVersion.copyWith(
      settingsDbVersion: currentVersion.settingsDbVersion + settingsDbVersion
    );
  }

  await versionDb.update(updatedVersion!);

}
