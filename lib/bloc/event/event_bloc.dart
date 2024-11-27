import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/repositories/event_repository.dart';

import '../../model/event_model.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<UpdateEvents>(_onUpdateEvents);
    // on<DeleteEvent>(_onDeleteEvent);
  }

  final EventRepository _eventRepository;
  StreamSubscription? _eventSubscription;

  void _onLoadEvents(LoadEvents event, Emitter<EventState> emit) {
    _eventSubscription?.cancel();
    try {
      _eventSubscription = _eventRepository.getEvents().listen((events) {
        add(UpdateEvents(events));
      });
    }catch(e) {
      emit(EventError('Event error: $e'));
    }
  }

  void _onUpdateEvents(UpdateEvents event, Emitter<EventState> emit) {
    emit(EventsLoaded(event.events));
  }

  // Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
  //   final events = (state as EventsLoaded).events;
  //   // emit(EventDeleting());
  //   final response = await _eventRepository.deleteEvent(event.eventId);
  //   if (response == null) {
  //     // emit(EventDeleted());
  //   }else {
  //     emit(const EventDeleteError('Error occurred while deleting event!'));
  //     emit(EventsLoaded(events));
  //   }
  // }

  @override
  void onChange(Change<EventState> change) {
    dev.log(change.toString(), name: 'Events');
    super.onChange(change);
  }
}
