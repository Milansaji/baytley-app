import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_locale.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignIn = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authBloc = context.read<AuthBloc>();
    if (_isSignIn) {
      authBloc.add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
      return;
    }

    authBloc.add(
      SignUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.t(
                              'Welcome to Baytley',
                              'مرحبًا بك في بيتلي',
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isSignIn
                                ? context.t(
                                    'Sign in to continue',
                                    'سجل الدخول للمتابعة',
                                  )
                                : context.t(
                                    'Create an account',
                                    'أنشئ حسابًا جديدًا',
                                  ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          if (!_isSignIn)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: context.t('Name', 'الاسم'),
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (_isSignIn) return null;
                                  if (value == null || value.trim().isEmpty) {
                                    return context.t(
                                      'Name is required',
                                      'الاسم مطلوب',
                                    );
                                  }
                                  return null;
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: context.t(
                                  'Email',
                                  'البريد الإلكتروني',
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return context.t(
                                    'Email is required',
                                    'البريد الإلكتروني مطلوب',
                                  );
                                }
                                if (!value.contains('@')) {
                                  return context.t(
                                    'Enter a valid email',
                                    'أدخل بريدًا إلكترونيًا صحيحًا',
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: context.t('Password', 'كلمة المرور'),
                                border: const OutlineInputBorder(),
                              ),
                              onFieldSubmitted: (_) => _submit(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.t(
                                    'Password is required',
                                    'كلمة المرور مطلوبة',
                                  );
                                }
                                if (!_isSignIn && value.length < 6) {
                                  return context.t(
                                    'Minimum 6 characters',
                                    'على الأقل 6 أحرف',
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _isSignIn
                                            ? context.t(
                                                'Sign In',
                                                'تسجيل الدخول',
                                              )
                                            : context.t(
                                                'Sign Up',
                                                'إنشاء حساب',
                                              ),
                                      ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          if (_isSignIn)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                context.t(
                                  'Don\'t have an account? Sign Up',
                                  'ليس لديك حساب؟ أنشئ حسابًا',
                                ),
                              ),
                            )
                          else
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignIn = !_isSignIn;
                                });
                              },
                              child: Text(
                                context.t(
                                  'Already have an account? Sign In',
                                  'لديك حساب بالفعل؟ سجل الدخول',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
