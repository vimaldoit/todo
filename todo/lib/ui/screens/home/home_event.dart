part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadEvents extends HomeEvent {}

class AddCalendarEvent extends HomeEvent {
  final CalendarEvent<Event> calendarEvent;
  AddCalendarEvent(this.calendarEvent);
}

class RemoveCalendarEvent extends HomeEvent {
  final CalendarEvent<Event> calendarEvent;
  RemoveCalendarEvent(this.calendarEvent);
}
