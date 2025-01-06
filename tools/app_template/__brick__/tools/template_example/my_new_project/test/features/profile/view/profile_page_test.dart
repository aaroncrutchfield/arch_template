import 'package:/core/di/app_registry.dart';
import 'package:/features/common/widgets/loading_indicator.dart';
import 'package:/features/profile/bloc/profile_bloc.dart';
import 'package:/features/profile/models/user.dart';
import 'package:/features/profile/view/profile_page.dart';
import 'package:/features/profile/widgets/widgets.dart';
import 'package:/l10n/l10n.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('ProfilePage', () {
    late ProfileBloc profileBloc;

    setUp(() {
      profileBloc = MockProfileBloc();

      appRegistry.register<ProfileBloc>(() => profileBloc);

      // Setup default bloc state
      when(() => profileBloc.state).thenReturn(ProfileInitial());

      // Register test doubles
      registerFallbackValue(ProfileInitial());
      registerFallbackValue(const ProfileStarted());
      registerFallbackValue(const ProfileSignOutRequested());
      registerFallbackValue(const ProfileEditRequested());
      registerFallbackValue(const ProfileSettingsRequested());
    });

    tearDown(appRegistry.reset);

    testWidgets('renders ProfileView', (tester) async {
      // Arrange
      await tester.pumpApp(
        BlocProvider.value(
          value: profileBloc,
          child: const ProfilePage(),
        ),
      );

      // Assert
      expect(find.byType(ProfileView), findsOneWidget);
    });

    group('ProfileView', () {
      const user = User(
        email: 'test@example.com',
        name: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      testWidgets(
        'renders loading indicator when state is ProfileInitial',
        (tester) async {
          // Arrange
          when(() => profileBloc.state).thenReturn(ProfileInitial());

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          // Assert
          expect(find.byType(LoadingIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'renders loading indicator when state is ProfileLoading',
        (tester) async {
          when(() => profileBloc.state).thenReturn(ProfileLoading());

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          expect(find.byType(LoadingIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'renders error view when state is ProfileError',
        (tester) async {
          const errorMessage = 'Something went wrong';
          when(() => profileBloc.state)
              .thenReturn(const ProfileError(message: errorMessage));

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          expect(find.byType(ProfileErrorView), findsOneWidget);
          expect(find.text(errorMessage), findsOneWidget);
        },
      );

      testWidgets(
        'renders loaded view when state is ProfileLoaded',
        (tester) async {
          when(() => profileBloc.state)
              .thenReturn(const ProfileLoaded(user: user));

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          expect(find.byType(LoadedProfileView), findsOneWidget);
          expect(find.text(user.name), findsOneWidget);
          expect(find.text(user.email), findsOneWidget);
        },
      );

      testWidgets(
        'adds ProfileSignOutRequested when logout button is tapped',
        (tester) async {
          // Arrange
          when(() => profileBloc.state)
              .thenReturn(const ProfileLoaded(user: user));

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          // Act
          await tester.tap(find.byIcon(Icons.logout));
          await tester.pump();

          // Assert
          verify(() => profileBloc.add(const ProfileSignOutRequested()))
              .called(1);
        },
      );

      testWidgets(
        'adds ProfileEditRequested when edit button is tapped',
        (tester) async {
          // Arrange
          when(() => profileBloc.state)
              .thenReturn(const ProfileLoaded(user: user));

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          // Act
          await tester.tap(find.widgetWithIcon(ListTile, Icons.edit));
          await tester.pump();

          // Assert
          verify(() => profileBloc.add(const ProfileEditRequested())).called(1);
        },
      );

      testWidgets(
        'adds ProfileSettingsRequested when settings button is tapped',
        (tester) async {
          // Arrange
          when(() => profileBloc.state)
              .thenReturn(const ProfileLoaded(user: user));

          await tester.pumpApp(
            BlocProvider.value(
              value: profileBloc,
              child: const ProfileView(),
            ),
          );

          // Act
          await tester.tap(find.widgetWithIcon(ListTile, Icons.settings));
          await tester.pump();

          // Assert
          verify(() => profileBloc.add(const ProfileSettingsRequested()))
              .called(1);
        },
      );
    });
  });
}
