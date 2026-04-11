import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(),
      super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _repository.currentFirebaseUser;
    if (user != null) {
      final userModel = await _repository.getUserModel(user.uid);
      if (userModel != null) {
        emit(AuthAuthenticated(userModel));
        return;
      }
    }
    emit(AuthUnauthenticated());
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userModel = await _repository.signIn(
        email: event.email.trim(),
        password: event.password,
      );
      emit(AuthAuthenticated(userModel));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Sign in failed.'));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userModel = await _repository.signUp(
        name: event.name,
        email: event.email.trim(),
        password: event.password,
      );
      emit(AuthAuthenticated(userModel));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Sign up failed.'));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repository.signOut();
      emit(AuthUnauthenticated());
    } catch (_) {
      emit(AuthError('Sign out failed.'));
      final user = _repository.currentFirebaseUser;
      if (user != null) {
        final userModel = await _repository.getUserModel(user.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(userModel));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }
}
