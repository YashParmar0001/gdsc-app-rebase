import 'dart:async';
import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gdsc_atmiya/model/notification_model.dart';
import 'package:gdsc_atmiya/repositories/event_repository.dart';
import 'package:gdsc_atmiya/repositories/notification_repository.dart';

part 'publish_event_state.dart';

part 'publish_event_event.dart';

class PublishEventBloc extends Bloc<PublishEventEvent, PublishEventState> {
  PublishEventBloc({
    required EventRepository eventRepository,
    required NotificationRepository notificationRepository,
  })  : _eventRepository = eventRepository,
        _notificationRepository = notificationRepository,
        super(EventInitial()) {
    on<PublishEvent>(_onPublishEvent);
  }

  final EventRepository _eventRepository;
  final NotificationRepository _notificationRepository;

  Future<void> _onPublishEvent(
    PublishEvent publishEvent,
    Emitter<PublishEventState> emit,
  ) async {
    emit(PublishingEvent());

    final event = await _eventRepository.publishEvent(publishEvent.eventData);
    if (event == null) {
      emit(const EventPublishError('Something went wrong! Please try again!'));
    } else {
      dev.log('Event published: $event', name: 'Event');
      // Now that event is published, post the notification
      _notificationRepository.sendPushNotification(
        event.shortDescription,
        'New event published: ${event.title}',
      );

      _notificationRepository.addNotification(
        NotificationModel(
          time: DateTime.now(),
          title: event.title,
          eventId: DateFormat('yyyy-MM-dd HH:mm').format(event.postedTime),
          thumbnailUrl: event.eventThumbnailUrl.toString(),
        ),
      );
      emit(EventPublished());
      // Future.delayed(const Duration(seconds: 5), () {
      //   if (emit.isDone) emit(EventInitial());
      // });
    }
  }

  @override
  void onChange(Change<PublishEventState> change) {
    dev.log(change.toString(), name: 'PublishEvent');
    super.onChange(change);
  }
}
