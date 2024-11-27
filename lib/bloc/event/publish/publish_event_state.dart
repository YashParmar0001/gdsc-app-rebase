part of 'publish_event_bloc.dart';

abstract class PublishEventState extends Equatable {
  const PublishEventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends PublishEventState {

}

class PublishingEvent extends PublishEventState {

}

class EventPublished extends PublishEventState {

}

class EventPublishError extends PublishEventState {
  const EventPublishError(this.message);

  final String message;
}
