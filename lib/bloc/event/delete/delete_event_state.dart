part of 'delete_event_bloc.dart';

abstract class DeleteEventState extends Equatable {
  const DeleteEventState();

  @override
  List<Object> get props => [];
}

class DeleteEventInitial extends DeleteEventState {

}

class EventDeleted extends DeleteEventState {

}

class EventDeleting extends DeleteEventState {}

class EventDeleteError extends DeleteEventState {
  const EventDeleteError(this.message);
  final String message;
}
