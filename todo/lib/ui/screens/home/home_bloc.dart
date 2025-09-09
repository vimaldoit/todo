import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/data/model/event_model.dart';
import 'package:todo/data/model/eventdata_model.dart';
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
  final List<CalendarEvent<EventData>> _events = [];
  void _onLoadEvents(LoadEvents event, Emitter<HomeState> emit) async {
    final saveData = await repository.getAllEvents();
    // final favs = await repository.getUserFavorites(event.userId);
    // final bookings = await repository.getUserBookings(event.userId);

    _events.clear();
    for (var item in saveData) {
      final eventData = item;
      final range = DateTimeRange(start: item.start, end: item.end);
      _events.add(
        CalendarEvent<EventData>(dateTimeRange: range, data: eventData),
      );
    }
    emit(CalendarLoaded(List.from(_events)));
  }

  void _onAddEvent(AddCalendarEvent event, Emitter<HomeState> emit) async {
    await repository.insertEvent(event.calendarEvent.data!);
    // _saveEvents();

    add(LoadEvents());
  }

  void _onRemoveEvent(
    RemoveCalendarEvent event,
    Emitter<HomeState> emit,
  ) async {
    _events.remove(event.calendarEvent);
    // _saveEvents();
    // _onLoadEvents(LoadEvents(), emit);
    // emit(CalendarLoaded(List.from(_events)));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    await repository.updateEventStatus(
      userId: event.userId,
      eventId: event.eventId,
      isFavorite: event.isFavorite,
    );
    add(LoadEvents(event.userId));
  }

  Future<void> _onToggleBooking(
    ToggleBooking event,
    Emitter<HomeState> emit,
  ) async {
    await repository.updateEventStatus(
      userId: event.userId,
      eventId: event.eventId,
      isBooked: event.isBooked,
    );
    add(LoadEvents(event.userId));
  }

  // Future<void> _saveEvents() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data =
  //       _events.map((e) {
  //         return json.encode({
  //           'start': e.dateTimeRange.start.toIso8601String(),
  //           'end': e.dateTimeRange.end.toIso8601String(),
  //           'data': e.data!.toJson(),
  //         });
  //       }).toList();
  //   await prefs.setStringList(_storageKey, data);
  // }
}
