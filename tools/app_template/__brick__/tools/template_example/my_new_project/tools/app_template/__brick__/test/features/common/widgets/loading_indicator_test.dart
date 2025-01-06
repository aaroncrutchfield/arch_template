import 'package:/features/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingIndicator', () {
    testWidgets('displays centered circular progress indicator',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);

      // Verify the CircularProgressIndicator is inside the Center widget
      final center = tester.widget<Center>(find.byType(Center));
      expect(center.child, isA<CircularProgressIndicator>());
    });
  });
}
