// To parse this JSON data, do
//
//     final cordinates = cordinatesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Cordinates cordinatesFromJson(String str) =>
    Cordinates.fromJson(json.decode(str));

String cordinatesToJson(Cordinates data) => json.encode(data.toJson());

class Cordinates {
  final Channel channel;
  final List<Feed> feeds;

  Cordinates({
    required this.channel,
    required this.feeds,
  });

  factory Cordinates.fromJson(Map<String, dynamic> json) => Cordinates(
        channel: Channel.fromJson(json["channel"]),
        feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channel": channel.toJson(),
        "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
      };
}

class Channel {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  final String field1;
  final String field2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int lastEntryId;

  Channel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.field1,
    required this.field2,
    required this.createdAt,
    required this.updatedAt,
    required this.lastEntryId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        field1: json["field1"],
        field2: json["field2"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        lastEntryId: json["last_entry_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "field1": field1,
        "field2": field2,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "last_entry_id": lastEntryId,
      };
}

class Feed {
  final DateTime createdAt;
  final int entryId;
  final String field1;
  final String field2;

  Feed({
    required this.createdAt,
    required this.entryId,
    required this.field1,
    required this.field2,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        createdAt:
            DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        entryId: json["entry_id"] ?? 0,
        field1: json["field1"] ?? "0.0",
        field2: json["field2"] ?? "0.0",
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "entry_id": entryId,
        "field1": field1,
        "field2": field2,
      };
}
