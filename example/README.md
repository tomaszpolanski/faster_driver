# Faster Driver example

An example to integration tests

## Getting Started
- Update flutter to at least `2.1.0-12.2.pre`
- Run integration tests:
```bash
flutter pub global activate faster_driver
fasterdriver ./integration_test
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_tests.dart
```
