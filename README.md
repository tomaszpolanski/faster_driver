# Faster Driver

This is a set of scripts improving how new Flutter Driver (Integration) tests work.

## Merging all test into one file
If you merge all `main` methods into one file you can run all your tests with one command:
```shell
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_tests.dart
```

You can create `main_tests.dart` manually or use this script to look for all the test files and create the file.

# Usage

Use pub.dev version:
```shell
flutter pub global activate faster_driver
```

Or clone the repo and active the script:
```shell
flutter pub global activate -s path .
```

Run the command by passing the root of your integration tests:
```shell
fasterdriver ./integration_test
```

Now run your tests:
```shell
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_tests.dart
```