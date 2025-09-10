import 'package:flutter/material.dart';

class EventData {
  final int? id;
  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final Color color;
  final int favoriteFlag; // changed from bool to int
  final int bookFlag; // changed from bool to int
  final int favoriteCount;
  final int bookCount;

  const EventData({
    this.id,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    required this.color,
    this.favoriteFlag = 0, // default to 0
    this.bookFlag = 0, // default to 0
    this.favoriteCount = 0,
    this.bookCount = 0,
  });

  EventData copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    Color? color,
    int? favoriteFlag, // changed from bool to int
    int? bookFlag, // changed from bool to int
    int? favoriteCount,
    int? bookCount,
  }) {
    return EventData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      favoriteFlag: favoriteFlag ?? this.favoriteFlag,
      bookFlag: bookFlag ?? this.bookFlag,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      bookCount: bookCount ?? this.bookCount,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'color': color.value,
    'favoriteFlag': favoriteFlag,
    'bookFlag': bookFlag,
    'favoriteCount': favoriteCount,
    'bookCount': bookCount,
  };

  factory EventData.fromMap(Map<String, dynamic> map) => EventData(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    start: DateTime.parse(map['start']),
    end: DateTime.parse(map['end']),
    color: Color(map['color']),
    favoriteFlag: map['favoriteFlag'] ?? 0, // changed from bool to int
    bookFlag: map['bookFlag'] ?? 0, // changed from bool to int
    favoriteCount: map['favoriteCount'] ?? 0,
    bookCount: map['bookCount'] ?? 0,
  );
}
