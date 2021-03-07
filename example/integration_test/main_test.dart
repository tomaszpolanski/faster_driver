import 'package:integration_test/integration_test.dart';

//flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart -d windows --no-sound-null-safety
import 'route_test.dart' as route;
import 'simple_test.dart' as simple;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  route.main();
  simple.main();
}
