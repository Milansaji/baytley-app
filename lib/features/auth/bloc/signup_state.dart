import '../models/user_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final UserModel user;

  SignupSuccess(this.user);
}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);
}

class SignupValidationError extends SignupState {
  final Map<String, String> errors;

  SignupValidationError(this.errors);
}
