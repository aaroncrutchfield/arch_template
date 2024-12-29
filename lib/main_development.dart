import 'package:arch_template/app/app.dart';
import 'package:arch_template/app/environments.dart';
import 'package:arch_template/bootstrap.dart';

void main() {
  bootstrap(
    environment: Environment.development,
    builder: () => const App(),
  );
}
