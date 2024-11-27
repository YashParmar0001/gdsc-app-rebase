import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/repositories/event_repository.dart';

part 'delete_event_event.dart';

part 'delete_event_state.dart';

class DeleteEventBloc extends Bloc<DeleteEventEvent, DeleteEventState> {
  DeleteEventBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(DeleteEventInitial()) {
    on<DeleteEvent>(_onDeleteEvent);
  }

  final EventRepository _eventRepository;

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<DeleteEventState> emit,
  ) async {
    emit(EventDeleting());
    final response = await _eventRepository.deleteEvent(event.eventId);
    if (response == null) {
      emit(EventDeleted());
    } else {
      emit(const EventDeleteError('Error occurred while deleting event!'));
    }
  }
}
