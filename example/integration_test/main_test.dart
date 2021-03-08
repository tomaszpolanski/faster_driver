import 'package:integration_test/integration_test.dart';

//flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart -d windows
import 'route_test.dart' as route;
import 'simple_test.dart' as simple;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  route.main();
  route.main();
  route.main();
  route.main();
  route.main();
  route.main();
  route.main();
  route.main();
  route.main();
  simple.main();
}

/// Issues:
/// * with 644 tests requesting the data after the tests ended freezes
//VMServiceFlutterDriver: request_data message is taking a long time to complete...
// flutter: 12:20 +644: (tearDownAll) [E]
// flutter:   TimeoutException after 0:12:00.000000: Test timed out after 12 minutes.
