part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class InitialData extends AdminState {}

class LoadedData extends AdminState {
  final Map<String, String> urls;

  const LoadedData(this.urls);

  @override
  List<Object> get props => [urls];
}

class LoadingData extends AdminState {}

class AdminErrorState extends AdminState {
  final String error;

  const AdminErrorState(this.error);
}
