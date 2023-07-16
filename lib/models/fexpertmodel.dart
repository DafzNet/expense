// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  FexpertModel({
    required this.id,
    required this.poster,
    required this.topic,
    required this.date,
    required this.body,
    this.image,
    required this.tags,
    this.allow = true,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory FexpertModel.fromJson(String source) => FexpertModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FexpertModel(id: $id, poster: $poster, topic: $topic, date: $date, body: $body, image: $image, tags: $tags, allow: $allow)';
  }

  @override
  bool operator ==(covariant FexpertModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.poster == poster &&
      other.topic == topic &&
      other.date == date &&
      other.body == body &&
      other.image == image &&
      other.tags == tags &&
      other.allow == allow;
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
      allow.hashCode;
  }
}


class FexpertSubTopic {
  String topic;
  String body;
  
  FexpertSubTopic({
    required this.topic,
    required this.body,
  });

  FexpertSubTopic copyWith({
    String? topic,
    String? body,
  }) {
    return FexpertSubTopic(
      topic: topic ?? this.topic,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topic': topic,
      'body': body,
    };
  }

  factory FexpertSubTopic.fromMap(Map<String, dynamic> map) {
    return FexpertSubTopic(
      topic: map['topic'] as String,
      body: map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FexpertSubTopic.fromJson(String source) => FexpertSubTopic.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FexpertSubTopic(topic: $topic, body: $body)';

  @override
  bool operator ==(covariant FexpertSubTopic other) {
    if (identical(this, other)) return true;
  
    return 
      other.topic == topic &&
      other.body == body;
  }

  @override
  int get hashCode => topic.hashCode ^ body.hashCode;
}



enum FexpertTag{
  budgeting,
  investment,
  debt,
  others
}




