import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/data/model/event_model.dart';
import 'package:todo/data/model/eventdata_model.dart';
import 'package:todo/data/model/user_model.dart';
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
    on<EditCalendarEvent>(_onEditEvent);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SwitchUserEvent>(_onSwitchUser);
    on<ToggleBookingEvent>(_onToggleBooking);
  }
  final List<CalendarEvent<EventData>> _events = [];
  void _onLoadEvents(LoadEvents event, Emitter<HomeState> emit) async {
    var finalEventdata;
    final saveData = await repository.getAllEvents();

    if (event.userId != '') {
      final userFavevent = await repository.getUserFavorites(event.userId);
      final userBookedevent = await repository.getUserBookings(event.userId);
      finalEventdata =
          saveData.map((e) {
            final isFav = userFavevent.any((fav) => fav.id == e.id);
            final isBooked = userBookedevent.any((booked) => booked.id == e.id);
            return e.copyWith(
              favoriteFlag: isFav ? 1 : 0,
              bookFlag: isBooked ? 1 : 0,
              favoriteCount:
                  isFav
                      ? (e.favoriteCount ?? 0) + 1
                      : (e.favoriteCount != null && e.favoriteCount! > 0
                          ? e.favoriteCount! - 1
                          : 0),
              bookCount:
                  isBooked
                      ? (e.bookCount ?? 0) + 1
                      : (e.bookCount != null && e.bookCount! > 0
                          ? e.bookCount! - 1
                          : 0),
              color:
                  isFav
                      ? Colors.redAccent
                      : isBooked
                      ? Colors.green
                      : e.color,
            );
          }).toList();
    } else {
      finalEventdata = saveData;
    }

    // final favs = await repository.getUserFavorites(event.userId);
    // final bookings = await repository.getUserBookings(event.userId);

    _events.clear();
    for (var item in finalEventdata) {
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
    await repository.deleteEvent(event.calendarEvent.data!.id!);
    add(LoadEvents());
  }

  void _onEditEvent(EditCalendarEvent event, Emitter<HomeState> emit) async {
    try {
      await repository.editEvent(event.calendarEvent);
      add(LoadEvents());
    } catch (e) {
      print("Error editing event: $e");
    }
  }

  void _onSwitchUser(SwitchUserEvent event, Emitter<HomeState> emit) {
    add(LoadEvents(userId: event.user.id));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<HomeState> emit,
  ) async {
    await repository.updateEventStatus(
      userId: event.userId,
      eventId: event.eventId,
      isFavorite: event.isFavorite,
    );
    add(LoadEvents(userId: event.userId));
  }

  Future<void> _onToggleBooking(
    ToggleBookingEvent event,
    Emitter<HomeState> emit,
  ) async {
    await repository.updateEventStatus(
      userId: event.userId,
      eventId: event.eventId,
      isBooked: event.isBooked,
    );
    add(LoadEvents(userId: event.userId));
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
