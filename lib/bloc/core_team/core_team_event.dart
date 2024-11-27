part of 'core_team_bloc.dart';

abstract class CoreTeamEvent extends Equatable {
  const CoreTeamEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoreTeam extends CoreTeamEvent {

}
