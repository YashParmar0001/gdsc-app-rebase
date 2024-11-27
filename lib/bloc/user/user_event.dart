part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class InitializeUser extends UserEvent {}

class RegisterUser extends UserEvent {
  const RegisterUser({required this.user, required this.profilePhoto});

  final UserModel user;
  final File? profilePhoto;
}

class UnRegisterUser extends UserEvent {}

class GetUser extends UserEvent {
  const GetUser({required this.email});

  final String email;
}

class UpdateUserProfile extends UserEvent {
  const UpdateUserProfile({
    required this.user,
    required this.userData,
    required this.profilePhoto,
    required this.removeProfilePhoto,
  });

  final UserModel user;
  final Map<String, dynamic> userData;
  final File? profilePhoto;
  final bool removeProfilePhoto;
}

class UpdateUser extends UserEvent {
  const UpdateUser({required this.user});

  final UserModel user;
}
