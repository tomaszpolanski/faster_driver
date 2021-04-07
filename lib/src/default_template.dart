const template = '''
// ignore_for_file: directives_ordering
/// This file is autogenerated and should not be committed
/// to source control
import 'package:integration_test/integration_test.dart';

<<imports>>

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  /// This is the template for single name line:
  /// test.main(<<arguments>>);
  /// 
<<main body>>
}
''';
