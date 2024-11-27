part of 'delete_event_bloc.dart';

abstract class DeleteEventEvent extends Equatable {
  const DeleteEventEvent();

  @override
  List<Object?> get props => [];
}

class DeleteEvent extends DeleteEventEvent {
  const DeleteEvent(this.eventId);
  final String eventId;
}
