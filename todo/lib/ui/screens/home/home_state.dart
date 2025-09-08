part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class CalendarLoaded extends HomeState {
  final List<CalendarEvent<Event>> events;
  CalendarLoaded(this.events);
}
