import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:offline_first/core/theme/app_pallete.dart';
import 'package:offline_first/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:offline_first/features/auth/presentation/pages/signup_page.dart';
import 'package:offline_first/features/auth/presentation/widgets/auth_field.dart';
import 'package:offline_first/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:offline_first/features/blog/presentation/pages/blog_page.dart';
import '../../../../core/common/widgets/Loader.dart';
import '../../../../core/utils/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }
  void signInWithGoogle() {
    context.read<AuthBloc>().add(GoogleSignInEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if(state is AuthSuccess){
                Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route) => false);

              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthField(hintText: 'Email', controller: emailController),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObscure: false,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: AuthGradientButton(
                            text: 'Sign In',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: SweepGradient(
                                transform: GradientRotation(-pi / 2),
                                colors: [
                                  Color(0xFFEA4335),
                                  Color(0xFF4285F4),
                                  Color(0xFF34A853),
                                  Color(0xFFFBBC05),
                                  Color(0xFFEA4335),
                                ],
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                            ),

                            child: IconButton(
                              style: IconButton.styleFrom(
                                fixedSize: Size(55, 55),
                              ),
                              onPressed: signInWithGoogle,
                              icon: FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: navigateToSignUp,
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
