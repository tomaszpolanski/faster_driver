const template = '''
// ignore_for_file: directives_ordering
/// This file is autogenerated and should not be committed
/// to source control
import 'package:integration_test/integration_test.dart';

<<imports>>

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  <<test.main({{arguments}});>>
}
''';
