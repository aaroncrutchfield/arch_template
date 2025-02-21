// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:analytics/analytics.dart' as _i548;
import 'package:arch_template/core/di/modules/firebase_module.dart' as _i519;
import 'package:arch_template/core/di/modules/libraries_module.dart' as _i997;
import 'package:arch_template/core/di/modules/onboarding_module.dart' as _i415;
import 'package:arch_template/core/di/modules/packages_module.dart' as _i304;
import 'package:arch_template/core/navigation/auto_router/auto_router.dart'
    as _i17;
import 'package:arch_template/core/navigation/domain/app_navigation.dart'
    as _i1032;
import 'package:arch_template/core/navigation/domain/auto_route_navigation.dart'
    as _i800;
import 'package:arch_template/core/navigation/navigation.dart' as _i423;
import 'package:arch_template/features/auth/bloc/auth_bloc.dart' as _i474;
import 'package:arch_template/features/login/bloc/login_bloc.dart' as _i21;
import 'package:arch_template/features/notifications/bloc/notifications_bloc.dart'
    as _i831;
import 'package:arch_template/features/onboarding/bloc/onboarding_bloc.dart'
    as _i359;
import 'package:arch_template/features/onboarding/models/models.dart' as _i974;
import 'package:arch_template/features/profile/bloc/profile_bloc.dart' as _i206;
import 'package:arch_template/features/theme/bloc/theme_bloc.dart' as _i341;
import 'package:auth_repository/auth_repository.dart' as _i1026;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_core/firebase_core.dart' as _i982;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as _i141;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:notifications/notifications.dart' as _i327;
import 'package:user_repository/user_repository.dart' as _i164;

const String _staging = 'staging';
const String _development = 'development';
const String _production = 'production';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final onboardingModule = _$OnboardingModule();
    final librariesModule = _$LibrariesModule();
    final firebaseModule = _$FirebaseModule();
    final packagesModule = _$PackagesModule();
    gh.factory<_i974.OnboardingConfig>(() => onboardingModule.onboardingConfig);
    gh.singleton<_i163.FlutterLocalNotificationsPlugin>(
        () => librariesModule.getFlutterLocalNotificationsPlugin());
    gh.singleton<_i17.RootAutoRouter>(() => _i17.RootAutoRouter());
    gh.singleton<_i1032.AppNavigation>(
        () => _i800.AutoRouteNavigation(gh<_i17.RootAutoRouter>()));
    gh.singleton<_i982.FirebaseOptions>(
      () => firebaseModule.getStagingOptions(),
      registerFor: {_staging},
    );
    gh.singleton<_i982.FirebaseOptions>(
      () => firebaseModule.getDevOptions(),
      registerFor: {_development},
    );
    gh.singleton<_i982.FirebaseOptions>(
      () => firebaseModule.getProdOptions(),
      registerFor: {_production},
    );
    await gh.singletonAsync<_i982.FirebaseApp>(
      () => firebaseModule.getFirebase(gh<_i982.FirebaseOptions>()),
      registerFor: {
        _development,
        _staging,
        _production,
      },
      preResolve: true,
    );
    gh.singleton<_i327.PushNotifications>(
        () => packagesModule.getPushNotifications(gh<_i982.FirebaseApp>()));
    gh.singleton<_i59.FirebaseAuth>(
        () => firebaseModule.getFirebaseAuth(gh<_i982.FirebaseApp>()));
    gh.singleton<_i398.FirebaseAnalytics>(
        () => firebaseModule.getFirebaseAnalytics(gh<_i982.FirebaseApp>()));
    gh.singleton<_i892.FirebaseMessaging>(
        () => firebaseModule.getFirebaseMessaging(gh<_i982.FirebaseApp>()));
    gh.singleton<_i141.FirebaseCrashlytics>(
        () => firebaseModule.getFirebaseCrashlytics(gh<_i982.FirebaseApp>()));
    gh.singleton<_i974.FirebaseFirestore>(
        () => firebaseModule.getFirebaseFirestore(gh<_i982.FirebaseApp>()));
    gh.singleton<_i164.UserRepository>(
        () => packagesModule.getUserRepository(gh<_i974.FirebaseFirestore>()));
    gh.singleton<_i548.Analytics>(
        () => packagesModule.getAnalytics(gh<_i398.FirebaseAnalytics>()));
    gh.singleton<_i398.FirebaseAnalyticsObserver>(() => firebaseModule
        .getFirebaseAnalyticsObserver(gh<_i398.FirebaseAnalytics>()));
    gh.factory<_i831.NotificationsBloc>(
        () => _i831.NotificationsBloc(gh<_i327.PushNotifications>()));
    gh.singleton<_i1026.AuthRepository>(
        () => packagesModule.getAuthRepository(gh<_i59.FirebaseAuth>()));
    gh.factory<_i474.AuthBloc>(() => _i474.AuthBloc(
          gh<_i1026.AuthRepository>(),
          gh<_i164.UserRepository>(),
          gh<_i423.AppNavigation>(),
          gh<_i548.Analytics>(),
        ));
    gh.factory<_i359.OnboardingBloc>(() => _i359.OnboardingBloc(
          config: gh<_i974.OnboardingConfig>(),
          userRepository: gh<_i164.UserRepository>(),
          authRepository: gh<_i1026.AuthRepository>(),
        ));
    gh.factory<_i206.ProfileBloc>(
        () => _i206.ProfileBloc(gh<_i1026.AuthRepository>()));
    gh.factory<_i21.LoginBloc>(
        () => _i21.LoginBloc(gh<_i1026.AuthRepository>()));
    gh.factory<_i341.ThemeBloc>(() => _i341.ThemeBloc(
          gh<_i164.UserRepository>(),
          gh<_i1026.AuthRepository>(),
        ));
    return this;
  }
}

class _$OnboardingModule extends _i415.OnboardingModule {}

class _$LibrariesModule extends _i997.LibrariesModule {}

class _$FirebaseModule extends _i519.FirebaseModule {}

class _$PackagesModule extends _i304.PackagesModule {}
