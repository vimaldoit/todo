import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/data/model/event_model.dart';
import 'package:todo/data/repository/event_repository.dart';
import 'package:todo/ui/screens/home/home_screen.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final EventRepository repository;
  static const String _storageKey = 'calendar_events';
  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddCalendarEvent>(_onAddEvent);
    on<RemoveCalendarEvent>(_onRemoveEvent);
  }
  final List<CalendarEvent<Event>> _events = [];
  void _onLoadEvents(LoadEvents event, Emitter<HomeState> emit) async {
    // final all = await repository.getAllEvents();
    // final favs = await repository.getUserFavorites(event.userId);
    // final bookings = await repository.getUserBookings(event.userId);

    final prefs = await SharedPreferences.getInstance();
    final saveData = prefs.getStringList(_storageKey) ?? [];
    _events.clear();
    for (var item in saveData) {
      final Map<String, dynamic> map = json.decode(item);
      final eventData = Event.fromJson(map['data']);
      final range = DateTimeRange(
        start: DateTime.parse(map['start']),
        end: DateTime.parse(map['end']),
      );
      _events.add(CalendarEvent<Event>(dateTimeRange: range, data: eventData));
    }
    emit(CalendarLoaded(List.from(_events)));
  }

  void _onAddEvent(AddCalendarEvent event, Emitter<HomeState> emit) async {
    _events.addAll([event.calendarEvent]);
    _saveEvents();
    _onLoadEvents(LoadEvents(), emit);
    // emit(CalendarLoaded(List.from(_events)));
  }

  void _onRemoveEvent(
    RemoveCalendarEvent event,
    Emitter<HomeState> emit,
  ) async {
    _events.remove(event.calendarEvent);
    _saveEvents();
    _onLoadEvents(LoadEvents(), emit);
    // emit(CalendarLoaded(List.from(_events)));
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data =
        _events.map((e) {
          return json.encode({
            'start': e.dateTimeRange.start.toIso8601String(),
            'end': e.dateTimeRange.end.toIso8601String(),
            'data': e.data!.toJson(),
          });
        }).toList();
    await prefs.setStringList(_storageKey, data);
  }
}
