import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_atmiya/model/user_model.dart';
import 'package:gdsc_atmiya/repositories/core_team_repository.dart';

import 'dart:developer' as dev;

part 'core_team_event.dart';

part 'core_team_state.dart';

class CoreTeamBloc extends Bloc<CoreTeamEvent, CoreTeamState> {
  CoreTeamBloc({required CoreTeamRepository coreTeamRepository})
      : _coreTeamRepository = coreTeamRepository,
        super(CoreTeamLoading()) {
    on<LoadCoreTeam>(_onLoadCoreTeam);
  }

  final CoreTeamRepository _coreTeamRepository;

  Future<void> _onLoadCoreTeam(CoreTeamEvent event, Emitter<CoreTeamState> emit) async {
    try {
      final coreMembers = await _coreTeamRepository.getCoreTeamMembers();
      emit(CoreTeamLoaded(coreMembers));
    } catch(e) {
      emit(CoreTeamError(e.toString()));
    }
  }

  @override
  void onTransition(Transition<CoreTeamEvent, CoreTeamState> transition) {
    dev.log(transition.toString(), name: 'CoreTeam');
    super.onTransition(transition);
  }
}
