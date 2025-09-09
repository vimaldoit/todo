part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadEvents extends HomeEvent {
  String userId;
  LoadEvents({this.userId = ''});
}

class AddCalendarEvent extends HomeEvent {
  final CalendarEvent<EventData> calendarEvent;
  AddCalendarEvent(this.calendarEvent);
}

class RemoveCalendarEvent extends HomeEvent {
  final CalendarEvent<EventData> calendarEvent;
  RemoveCalendarEvent(this.calendarEvent);
}

class EditCalendarEvent extends HomeEvent {
  final EventData calendarEvent;
  EditCalendarEvent(this.calendarEvent);
}

class ToggleFavoriteEvent extends HomeEvent {
  final int eventId;
  final String userId;
  final bool isFavorite;
  ToggleFavoriteEvent({
    required this.eventId,
    required this.userId,
    required this.isFavorite,
  });
}
