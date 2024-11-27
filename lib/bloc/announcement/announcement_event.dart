part of 'announcement_bloc.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();
  @override
  List<Object?> get props => [];
}

class AddAnnouncement extends AnnouncementEvent{
  final AnnouncementModel announcement;
  const AddAnnouncement(this.announcement);

  @override
  List<Object?> get props => [announcement];
}

class AnnouncementSuccess extends AnnouncementEvent{

}

