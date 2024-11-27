import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/repositories/user_repository.dart';

import 'dart:developer' as dev;

import '../../model/user_model.dart';
import '../../repositories/auth_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(UserInitial()) {
    on<RegisterUser>(_onRegisterUser);
    on<GetUser>(_onGetUser);
    on<UnRegisterUser>(_onUnRegisterUser);
    on<InitializeUser>(_onInitializeUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription? _userSubscription;

  void _onInitializeUser(InitializeUser event, Emitter<UserState> emit) {
    _userSubscription?.cancel();
    emit(UserInitial());
  }

  Future<void> _onGetUser(GetUser event, Emitter<UserState> emit) async {
    emit(GettingUser());
    try {
      _userSubscription?.cancel();
      _userSubscription =
          (await _authRepository.getUserStream(event.email)).listen((event) {
        if (event == null) {
          dev.log('User is null', name: 'Register');
          add(UnRegisterUser());
        } else {
          add(UpdateUser(user: event));
        }
      });
    } on FirebaseException catch (e) {
      dev.log('Error in registering: ${e.code}', name: 'Register');
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) {
    emit(UserRegistered(user: event.user));
  }

  Future<void> _onRegisterUser(
      RegisterUser event, Emitter<UserState> emit) async {
    dev.log('Registering user: ${event.user.email}', name: 'Register');
    emit(UserRegistering());
    final user = await _authRepository.registerClubMember(
      event.user,
      event.profilePhoto,
    );
    if (user == null) {
      emit(const RegisterError('Something went wrong! Please try again!'));
    } else {
      add(GetUser(email: event.user.email));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserState> emit) async {
    dev.log('Updating user profile: ${event.userData}', name: 'Update');
    emit(UserRegistering());
    final response = await _userRepository.updateUserProfile(
      event.user,
      event.userData,
      event.profilePhoto,
      event.removeProfilePhoto,
    );

    if (response == null) {
      dev.log('User profile updated successfully!', name: 'Update');
      // emit(UserProfileUpdated());
    } else {
      dev.log('Update error occurred!', name: 'Update');
      emit(const UserProfileUpdateError('Some error occurred!'));
    }
  }

  void _onUnRegisterUser(UnRegisterUser event, Emitter<UserState> emit) {
    _userSubscription?.cancel();
    emit(UserNotRegistered());
  }

  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    dev.log(transition.toString(), name: 'Register');
    super.onTransition(transition);
  }

  @override
  void onEvent(UserEvent event) {
    dev.log(event.toString(), name: 'Register');
    super.onEvent(event);
  }
}
