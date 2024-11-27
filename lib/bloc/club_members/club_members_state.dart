part of 'club_members_bloc.dart';

abstract class ClubMembersState extends Equatable {
  const ClubMembersState();
  @override
  List<Object?> get props => [];
}

class ClubMembersLoading extends ClubMembersState{

}

class ClubMembersLoaded extends ClubMembersState{
  const ClubMembersLoaded(this.clubMembers);
  final List<UserModel> clubMembers;

  @override
  List<Object> get props => [clubMembers];
}

class ClubMembersError extends ClubMembersState{
  const ClubMembersError(this.message);
  final String message;
}
