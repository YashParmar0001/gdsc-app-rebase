part of 'club_members_bloc.dart';

abstract class ClubMembersEvent extends Equatable {
  const ClubMembersEvent();
  @override
  List<Object?> get props => [];
}

class LoadClubMembers extends ClubMembersEvent{

}