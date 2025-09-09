part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class CalendarLoaded extends HomeState {
  final List<CalendarEvent<EventData>> events;
  final List<CalendarEvent<EventData>> favevents;
  CalendarLoaded(this.events, {this.favevents = const []});
}
