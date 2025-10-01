import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_first/core/common/app_user/app_user_cubit.dart';
import 'package:offline_first/core/network/network_checker.dart';
import 'package:offline_first/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:offline_first/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:offline_first/features/auth/domain/repository/auth_repository.dart';
import 'package:offline_first/features/auth/domain/usecases/current_user.dart';
import 'package:offline_first/features/auth/domain/usecases/user_login.dart';
import 'package:offline_first/features/auth/domain/usecases/user_logout.dart';
import 'package:offline_first/features/auth/domain/usecases/user_sign_up.dart';
import 'package:offline_first/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:offline_first/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:offline_first/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:offline_first/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:offline_first/features/blog/domain/repositories/blog_repository.dart';
import 'package:offline_first/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:offline_first/features/blog/domain/usecases/upload_blog.dart';
import 'package:offline_first/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnon,
  );
  await Hive.initFlutter();

  final blogBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton<Box>(() => blogBox);
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());
  //Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl((serviceLocator())),
  );
}

void _initAuth() {
  //Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // User Cases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserLogout(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        usersignup: serviceLocator(),
        userLogin: serviceLocator(),
        currentuser: serviceLocator(),
        userlogout: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() async {
  //DataSource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )

    ..registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(serviceLocator()))
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(serviceLocator() , serviceLocator() , serviceLocator()),
    )
    //UseCases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
