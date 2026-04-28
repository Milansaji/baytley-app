import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_locale.dart';
import '../../../screens/main_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final signupBloc = context.read<SignupBloc>();
    signupBloc.add(
      SignupRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          // After successful signup, navigate to home
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.t(
                          'Join Baytley Today',
                          'انضم إلى بيتلي اليوم',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.t(
                          'Create your account to get started',
                          'أنشئ حسابك للبدء',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Full Name Field
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: context.t('Full Name', 'الاسم الكامل'),
                            hintText: context.t(
                              'Enter your full name',
                              'أدخل اسمك الكامل',
                            ),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.t(
                                'Name is required',
                                'الاسم مطلوب',
                              );
                            }
                            if (value.trim().length < 3) {
                              return context.t(
                                'Name must be at least 3 characters',
                                'يجب أن يكون الاسم 3 أحرف على الأقل',
                              );
                            }
                            return null;
                          },
                        ),
                      ),

                      // Email Field
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText:
                                context.t('Email Address', 'عنوان البريد الإلكتروني'),
                            hintText: context.t(
                              'Enter your email',
                              'أدخل بريدك الإلكتروني',
                            ),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.t(
                                'Email is required',
                                'البريد الإلكتروني مطلوب',
                              );
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return context.t(
                                'Enter a valid email address',
                                'أدخل عنوان بريد إلكتروني صحيح',
                              );
                            }
                            return null;
                          },
                        ),
                      ),

                      // Password Field
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: context.t('Password', 'كلمة المرور'),
                            hintText: context.t(
                              'Enter your password',
                              'أدخل كلمة مرورك',
                            ),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.t(
                                'Password is required',
                                'كلمة المرور مطلوبة',
                              );
                            }
                            if (value.length < 6) {
                              return context.t(
                                'Password must be at least 6 characters',
                                'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
                              );
                            }
                            return null;
                          },
                        ),
                      ),

                      // Confirm Password Field
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText:
                                context.t('Confirm Password', 'تأكيد كلمة المرور'),
                            hintText: context.t(
                              'Re-enter your password',
                              'أعد إدخال كلمة مرورك',
                            ),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.t(
                                'Please confirm your password',
                                'يرجى تأكيد كلمة مرورك',
                              );
                            }
                            if (value != _passwordController.text) {
                              return context.t(
                                'Passwords do not match',
                                'كلمات المرور غير متطابقة',
                              );
                            }
                            return null;
                          },
                        ),
                      ),

                      // Sign Up Button
                      BlocBuilder<SignupBloc, SignupState>(
                        builder: (context, state) {
                          final isLoading = state is SignupLoading;
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
                                    context.t('Create Account', 'إنشاء حساب'),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Sign In Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.t(
                              'Already have an account? ',
                              'هل لديك حساب بالفعل؟ ',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              context.t('Sign In', 'تسجيل الدخول'),
                            ),
                          ),
                        ],
                      ),
                    ],
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
