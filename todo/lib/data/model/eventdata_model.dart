import 'package:flutter/material.dart';

class EventData {
  final int? id;
  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final Color color;

  const EventData({
    this.id,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    required this.color,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'color': color.value,
  };

  factory EventData.fromMap(Map<String, dynamic> map) => EventData(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    start: DateTime.parse(map['start']),
    end: DateTime.parse(map['end']),
    color: Color(map['color']),
  );
}
