part of 'core_team_bloc.dart';

abstract class CoreTeamState extends Equatable {
  const CoreTeamState();

  @override
  List<Object> get props => [];
}

class CoreTeamLoading extends CoreTeamState {

}

class CoreTeamLoaded extends CoreTeamState {
  const CoreTeamLoaded(this.coreTeamMembers);

  final List<CoreUserModel> coreTeamMembers;
}

class CoreTeamError extends CoreTeamState {
  const CoreTeamError(this.message);

  final String message;
}
