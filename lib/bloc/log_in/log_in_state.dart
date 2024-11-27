part of 'log_in_bloc.dart';

class LogInState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  // bool get isFormValid => isEmailValid && isPasswordValid;

  LogInState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  factory LogInState.empty() {
    return LogInState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LogInState.loading() {
    return LogInState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LogInState.failure() {
    return LogInState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory LogInState.success() {
    return LogInState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  LogInState update({
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return copyWith(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LogInState copyWith({
    bool? isSubmitEnabled,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return LogInState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
