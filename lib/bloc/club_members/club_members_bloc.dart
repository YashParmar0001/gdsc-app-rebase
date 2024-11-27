import 'dart:async';
import 'dart:developer'as dev;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/repositories/user_repository.dart';

import '../../model/user_model.dart';

part 'club_members_event.dart';

part 'club_members_state.dart';

class ClubMembersBloc extends Bloc<ClubMembersEvent, ClubMembersState> {
  ClubMembersBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ClubMembersLoading()) {
        on<LoadClubMembers>(_onLoadClubMembers);
  }
  final UserRepository _userRepository;

  Future<FutureOr<void>> _onLoadClubMembers(LoadClubMembers event, Emitter<ClubMembersState> emit) async {
    try{
      // emit(ClubMembersLoading());
      final list = await  _userRepository.getClubMemberList();
      emit(ClubMembersLoaded(list));
    }catch(e){
      emit(ClubMembersError(e.toString()));
    }
  }

  @override
  void onTransition(
      Transition<ClubMembersEvent, ClubMembersState> transition) {
    dev.log(transition.toString(), name: 'Club Members');
    super.onTransition(transition);
  }
}
