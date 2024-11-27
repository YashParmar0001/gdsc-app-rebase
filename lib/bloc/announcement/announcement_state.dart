part of 'announcement_bloc.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementAdding extends AnnouncementState {}

class AnnouncementError extends AnnouncementState {
  final String message;

  const AnnouncementError(this.message);

  @override
  List<Object> get props => [message];
}

class AnnouncementSuccessed extends AnnouncementState {
  final String message;

  const AnnouncementSuccessed(this.message);

  @override
  List<Object> get props => [message];
}
