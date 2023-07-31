import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:expense/models/user_model.dart';

import '../firebase/db/fexpert/likes.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FLike {
  
  dynamic fexpertId;
  List<dynamic> likes;

  FLike({
    required this.fexpertId,
    this.likes = const [],
  });


  int get numberOfLikes{
    return likes.length;
  }

  bool liked(LightUser user){
    return likes.contains(user.id);
  }

  void like(LightUser user){
    if (!liked(user)) {
      likes.add(user.id);
    } else {
      likes.remove(user.id);
    }
  }

  FLike copyWith({
    dynamic fexpertId,
    List<dynamic>? likes,
  }) {
    return FLike(
      fexpertId: fexpertId ?? this.fexpertId,
      likes: likes!,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fexpertId': fexpertId,
      'likes': likes.toList(),
    };
  }

  factory FLike.fromMap(Map<String, dynamic> map) {
    return FLike(
      fexpertId: map['fexpertId'] as dynamic,
      likes: List<dynamic>.from((map['likes'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory FLike.fromJson(String source) => FLike.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FLike(fexpertId: $fexpertId, likes: $likes)';

  @override
  bool operator ==(covariant FLike other) {
    if (identical(this, other)) return true;
    final setEquals = const DeepCollectionEquality().equals;
  
    return 
      other.fexpertId == fexpertId &&
      setEquals(other.likes, likes);
  }

  @override
  int get hashCode => fexpertId.hashCode ^ likes.hashCode;
}
