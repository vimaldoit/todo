import 'package:flutter/material.dart';

class Event {
  final String title;
  final Color color;

  const Event(this.title, this.color);

  Map<String, dynamic> toJson() {
    return {'title': title, 'color': color.value};
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(json['title'], Color(json['color']));
  }
}
