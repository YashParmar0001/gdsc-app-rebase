import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'dart:developer' as dev;

import '../../repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(Uninitialized()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  final AuthRepository _authRepository;

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final email = _authRepository.getCurrentEmail();

        emit(Authenticated(email: email ?? 'Error'));
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
    emit(Authenticated(email: _authRepository.getCurrentEmail() ?? 'Error'));
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    try {
      // emit(LoggingOut());
      await _authRepository.signOut();
      emit(UnAuthenticated());
    } catch(e) {
      emit(LogOutError(e.toString()));
    }
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    dev.log(transition.toString());
    super.onTransition(transition);
  }
}
