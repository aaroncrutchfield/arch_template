import 'package:arch_template/features/profile/models/user.dart';
import 'package:arch_template/features/profile/widgets/loaded_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('LoadedProfileView', () {
    const user = User(
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
    );

    testWidgets('renders user information correctly', (tester) async {
      // Arrange

      await tester.pumpApp(
        Scaffold(
          body: LoadedProfileView(
            user: user,
            onEditProfile: () {},
            onSettings: () {},
          ),
        ),
      );

      // Assert
      expect(find.text(user.name), findsOneWidget);
      expect(find.text(user.email), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('shows first letter of name when no photo URL', (tester) async {
      // Arrange
      const userWithoutPhoto = User(
        email: 'test@example.com',
        name: 'Test User',
        photoUrl: '',
      );

      await tester.pumpApp(
        Scaffold(
          body: LoadedProfileView(
            user: userWithoutPhoto,
            onEditProfile: () {},
            onSettings: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('T'), findsOneWidget);
    });

    testWidgets('shows question mark when no name and no photo',
        (tester) async {
      // Arrange
      const userWithoutNameAndPhoto = User(
        email: 'test@example.com',
        name: '',
        photoUrl: '',
      );

      await tester.pumpApp(
        Scaffold(
          body: LoadedProfileView(
            user: userWithoutNameAndPhoto,
            onEditProfile: () {},
            onSettings: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('calls onEditProfile when edit button is tapped',
        (tester) async {
      // Arrange
      var editProfileCalled = false;

      await tester.pumpApp(
        Scaffold(
          body: LoadedProfileView(
            user: user,
            onEditProfile: () => editProfileCalled = true,
            onSettings: () {},
          ),
        ),
      );

      // Act
      await tester.tap(find.widgetWithIcon(ListTile, Icons.edit));
      await tester.pump();

      // Assert
      expect(editProfileCalled, isTrue);
    });

    testWidgets('calls onSettings when settings button is tapped',
        (tester) async {
      // Arrange
      var settingsCalled = false;

      await tester.pumpApp(
        Scaffold(
          body: LoadedProfileView(
            user: user,
            onEditProfile: () {},
            onSettings: () => settingsCalled = true,
          ),
        ),
      );

      // Act
      await tester.tap(find.widgetWithIcon(ListTile, Icons.settings));
      await tester.pump();

      // Assert
      expect(settingsCalled, isTrue);
    });

    testWidgets('shows "No name provided" when name is empty', (tester) async {
      // Arrange
      const userWithoutName = User(
        email: 'test@example.com',
        name: '',
        photoUrl: 'https://example.com/photo.jpg',
      );

      await tester.pumpApp(
        Scaffold(
          body: LoadedProfileView(
            user: userWithoutName,
            onEditProfile: () {},
            onSettings: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('No name provided'), findsOneWidget);
    });
  });
}
