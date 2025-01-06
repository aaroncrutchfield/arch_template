// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:/core/di/data/modules/firebase_module.dart'
    as _i19;
import 'package:/core/di/data/modules/packages_module.dart'
    as _i370;
import 'package:/core/navigation/data/auto_router.dart' as _i34;
import 'package:/core/navigation/domain/app_navigation.dart'
    as _i1032;
import 'package:/core/navigation/domain/auto_route_navigation.dart'
    as _i800;
import 'package:/core/navigation/navigation.dart' as _i423;
import 'package:/features/auth/bloc/auth_bloc.dart' as _i474;
import 'package:/features/login/bloc/login_bloc.dart' as _i21;
import 'package:/features/profile/bloc/profile_bloc.dart' as _i206;
import 'package:auth_repository/auth_repository.dart' as _i1026;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_core/firebase_core.dart' as _i982;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

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
    final firebaseModule = _$FirebaseModule();
    final packagesModule = _$PackagesModule();
    gh.singleton<_i34.RootAutoRouter>(() => _i34.RootAutoRouter());
    gh.singleton<_i1032.AppNavigation>(
        () => _i800.AutoRouteNavigation(gh<_i34.RootAutoRouter>()));
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
    gh.singleton<_i59.FirebaseAuth>(
        () => firebaseModule.getFirebaseAuth(gh<_i982.FirebaseApp>()));
    gh.singleton<_i1026.AuthRepository>(
        () => packagesModule.getAuthRepository(gh<_i59.FirebaseAuth>()));
    gh.factory<_i474.AuthBloc>(() => _i474.AuthBloc(
          gh<_i1026.AuthRepository>(),
          gh<_i423.AppNavigation>(),
        ));
    gh.factory<_i21.LoginBloc>(
        () => _i21.LoginBloc(gh<_i1026.AuthRepository>()));
    gh.factory<_i206.ProfileBloc>(
        () => _i206.ProfileBloc(gh<_i1026.AuthRepository>()));
    return this;
  }
}

class _$FirebaseModule extends _i19.FirebaseModule {}

class _$PackagesModule extends _i370.PackagesModule {}
