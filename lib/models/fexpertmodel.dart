// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:expense/models/user_model.dart';

class FexpertModel {
  dynamic id;
  LightUser poster;
  String topic;
  DateTime date;
  String body;
  String? image;
  String tags;
  bool allow;
  List<String>? search;
  List<String>? tagSearch;

  FexpertModel({
    required this.id,
    required this.poster,
    required this.topic,
    required this.date,
    required this.body,
    this.image,
    required this.tags,
    this.allow = true,
    this.search,
    this.tagSearch,
  });


  FexpertModel copyWith({
    dynamic? id,
    LightUser? poster,
    String? topic,
    DateTime? date,
    String? body,
    String? image,
    String? tags,
    bool? allow,
    List<String>? search,
    List<String>? tagSearch,
  }) {
    return FexpertModel(
      id: id ?? this.id,
      poster: poster ?? this.poster,
      topic: topic ?? this.topic,
      date: date ?? this.date,
      body: body ?? this.body,
      image: image ?? this.image,
      tags: tags ?? this.tags,
      allow: allow ?? this.allow,
      search: search ?? this.search,
      tagSearch: tagSearch ?? this.tagSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poster': poster.toMap(),
      'topic': topic,
      'date': date.millisecondsSinceEpoch,
      'body': body,
      'image': image,
      'tags': tags,
      'allow': allow,
      'search': search,
      'tagSearch': tagSearch,
    };
  }

  factory FexpertModel.fromMap(Map<String, dynamic> map) {
    return FexpertModel(
      id: map['id'] as dynamic,
      poster: LightUser.fromMap(map['poster'] as Map<String,dynamic>),
      topic: map['topic'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      body: map['body'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      tags: map['tags'] as String,
      allow: map['allow'] as bool,
      search: map['search'] != null ? List<String>.from((map['search']??[] as List<String>)) : null,
      tagSearch: map['tagSearch'] != null ? List<String>.from((map['tagSearch']??[] as List<String>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FexpertModel.fromJson(String source) => FexpertModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FexpertModel(id: $id, poster: $poster, topic: $topic, date: $date, body: $body, image: $image, tags: $tags, allow: $allow, search: $search, tagSearch: $tagSearch)';
  }

  @override
  bool operator ==(covariant FexpertModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      poster.hashCode ^
      topic.hashCode ^
      date.hashCode ^
      body.hashCode ^
      image.hashCode ^
      tags.hashCode ^
      allow.hashCode ^
      search.hashCode ^
      tagSearch.hashCode;
  }
}
