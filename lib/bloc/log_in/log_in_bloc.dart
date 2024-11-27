import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'dart:developer' as dev;

import '../../repositories/auth_repository.dart';

part 'log_in_event.dart';

part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LogInState.empty()) {
    on<LogInWithGooglePressed>(_onLogInWithGooglePressed);
  }

  final AuthRepository _authRepository;

  Future<void> _onLogInWithGooglePressed(
    LogInWithGooglePressed event,
    Emitter<LogInState> emit,
  ) async {
    emit(LogInState.loading());
    try {
      await _authRepository.signInWithGoogle();
      dev.log('Successfully logged in', name: 'User');
      emit(LogInState.success());
    } catch (e) {
      dev.log('Got sign in error: ${e.toString()}', name: 'User');
      emit(LogInState.failure());
    }
  }
}
