import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer'as dev;
import '../../repositories/admin_repository.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(LoadingData()) {
    on<LoadDataEvent>(_loadData);
  }

  FutureOr<void> _loadData(LoadDataEvent event, Emitter<AdminState> emit) async{
    try {
      emit(LoadingData());
       final map = await _adminRepository.getAdminDetails();
       emit(LoadedData(map));
    } catch (e) {
      emit(AdminErrorState(e.toString()));
    }
  }

  @override
  void onTransition(
      Transition<AdminEvent, AdminState> transition) {
    dev.log(transition.toString(), name: 'About us');
    super.onTransition(transition);
  }
}
