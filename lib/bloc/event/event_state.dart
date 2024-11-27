part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {

}

class EventsLoading extends EventState {

}

class EventsLoaded extends EventState {
  const EventsLoaded(this.events);
  final List<Event> events;

  @override
  List<Object> get props => [events];
}

class EventError extends EventState {
  const EventError(this.message);
  final String message;
}
