import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/model/notification_model.dart';

import '../../repositories/notification_repository.dart';
import 'dart:developer' as dev;

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(NotificationLoading()) {
    on<LoadNotifications>(_onLoadNotification);
    on<AddNotification>(_onAddNotification);
    on<UpdateNotifications>(_onUpdateNotifications);
  }

  final NotificationRepository _notificationRepository;
  StreamSubscription? _notificationSubscription;

  Future<void> _onLoadNotification(
    NotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      _notificationSubscription?.cancel();
      _notificationSubscription = _notificationRepository.getStreamOfNotifications().listen((event) {
        add(UpdateNotifications(event));
      });
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onUpdateNotifications(UpdateNotifications event, Emitter<NotificationState> emit) {
    emit(NotificationLoaded(event.notifications));
  }

  Future<void> _onAddNotification(
      AddNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.addNotification(event.notification);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  @override
  void onTransition(
      Transition<NotificationEvent, NotificationState> transition) {
    dev.log(transition.toString(), name: 'Notification');
    super.onTransition(transition);
  }
}
