part of 'publish_event_bloc.dart';

abstract class PublishEventEvent extends Equatable {
  const PublishEventEvent();

  @override
  List<Object?> get props => [];
}

class PublishEvent extends PublishEventEvent {
  const PublishEvent(this.eventData);

  final Map<String, dynamic> eventData;
}
