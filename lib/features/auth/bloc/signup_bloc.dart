import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _repository;

  SignupBloc({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(),
      super(SignupInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<SignupFormReset>(_onFormReset);
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    // Validation
    final errors = <String, String>{};

    if (event.name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    } else if (event.name.trim().length < 3) {
      errors['name'] = 'Name must be at least 3 characters';
    }

    if (event.email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!event.email.contains('@') || !event.email.contains('.')) {
      errors['email'] = 'Enter a valid email address';
    }

    if (event.password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (event.password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    if (errors.isNotEmpty) {
      emit(SignupValidationError(errors));
      emit(SignupInitial());
      return;
    }

    try {
      final userModel = await _repository.signUp(
        name: event.name,
        email: event.email.trim(),
        password: event.password,
      );
      emit(SignupSuccess(userModel));
    } on FirebaseAuthException catch (e) {
      emit(SignupError(e.message ?? 'Sign up failed'));
      emit(SignupInitial());
    } catch (e) {
      emit(SignupError(e.toString()));
      emit(SignupInitial());
    }
  }

  Future<void> _onFormReset(
    SignupFormReset event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupInitial());
  }
}
