part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState{

}

class NotificationLoaded extends NotificationState{
  const NotificationLoaded(this.notifications);
  final List<dynamic> notifications;

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationState {
  const NotificationError(this.message);
  final String message;
}
