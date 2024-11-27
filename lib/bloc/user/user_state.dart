part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserRegistered extends UserState {
  const UserRegistered({required this.user});

  final UserModel user;

  @override
  List<Object?> get props => [
        if (user is CoreUserModel)
          ...(user as CoreUserModel).props
        else
          ...user.props,
      ];
}

class GettingUser extends UserState {}

class UserRegistering extends UserState {}

class UserNotRegistered extends UserState {}

class UpdatingUserProfile extends UserState {}

class UserProfileUpdated extends UserState {}

class UserProfileUpdateError extends UserState {
  const UserProfileUpdateError(this.message);

  final String message;
}

class UserError extends UserState {
  const UserError(this.message);

  final String message;
}

class RegisterError extends UserState {
  const RegisterError(this.message);

  final String message;
}
