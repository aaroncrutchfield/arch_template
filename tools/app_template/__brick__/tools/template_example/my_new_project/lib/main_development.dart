import 'package:/app/app.dart';
import 'package:/app/environments.dart';
import 'package:/bootstrap.dart';

void main() {
  bootstrap(
    environment: Environment.development,
    builder: () => const App(),
  );
}
