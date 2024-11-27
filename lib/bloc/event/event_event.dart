part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {

}

class UpdateEvents extends EventEvent {
  const UpdateEvents(this.events);
  final List<Event> events;
}

// class DeleteEvent extends EventEvent {
//   const DeleteEvent(this.eventId);
//   final String eventId;
// }
