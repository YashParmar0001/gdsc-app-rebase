import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/model/announcement_model.dart';

import '../../repositories/notification_repository.dart';
import 'dart:developer' as dev;

part 'announcement_event.dart';

part 'announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  AnnouncementBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(AnnouncementInitial()) {
    on<AddAnnouncement>(_onAddAnnouncement);
  }

  final NotificationRepository _notificationRepository;

  Future<FutureOr<void>> _onAddAnnouncement(
      AddAnnouncement event, Emitter<AnnouncementState> emit) async {
    try {
      emit(AnnouncementAdding());
      await _notificationRepository.addAnnouncement(event.announcement);
      emit(const AnnouncementSuccessed("Announcement is successes"));
      emit(AnnouncementInitial());
      _notificationRepository.sendPushNotification(
        event.announcement.description,
        'New announcement: ${event.announcement.title}',
      );
    } catch (e) {
      emit(AnnouncementError(e.toString()));
    }
  }

  @override
  void onTransition(
      Transition<AnnouncementEvent, AnnouncementState> transition) {
    dev.log(transition.toString(), name: 'Announcement');
    super.onTransition(transition);
  }
}
