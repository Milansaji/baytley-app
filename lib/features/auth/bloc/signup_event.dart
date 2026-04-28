abstract class SignupEvent {}

class SignupRequested extends SignupEvent {
  final String name;
  final String email;
  final String password;

  SignupRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignupNameChanged extends SignupEvent {
  final String name;

  SignupNameChanged(this.name);
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  SignupEmailChanged(this.email);
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  SignupPasswordChanged(this.password);
}

class SignupPasswordConfirmChanged extends SignupEvent {
  final String confirmPassword;

  SignupPasswordConfirmChanged(this.confirmPassword);
}

class SignupFormReset extends SignupEvent {}
