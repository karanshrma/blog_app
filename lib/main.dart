import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/core/common/app_user/app_user_cubit.dart';
import 'package:offline_first/core/theme/theme.dart';
import 'package:offline_first/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:offline_first/features/auth/presentation/pages/login_page.dart';
import 'package:offline_first/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:offline_first/features/blog/presentation/pages/blog_page.dart';
import 'package:offline_first/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()..add(BlogFetchAllBlogs())),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AuthBloc, AuthState, bool>(
        selector: (state) {
          return state is AuthSuccess;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
