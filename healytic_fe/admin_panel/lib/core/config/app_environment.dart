/// Defines the available build environments and
/// resolves which store asset file to load.
///
/// Use `--dart-define=ENV=<env>` to select at
/// build / run time:
/// ```bash
/// flutter run --dart-define=ENV=dev
/// flutter run --dart-define=ENV=uat
/// flutter run --dart-define=ENV=prod
/// ```
enum AppEnvironment {
  /// Local / development – mock flags enabled.
  dev('store.dev.json'),

  /// User-acceptance testing – real APIs, no mocks.
  uat('store.uat.json'),

  /// Live production server.
  prod('store.prod.json');

  const AppEnvironment(this.configFile);

  /// Filename of the JSON asset for this environment.
  final String configFile;

  /// Full asset path loadable via [rootBundle].
  String get assetPath => 'assets/$configFile';

  /// Resolves from `--dart-define=ENV=<value>`.
  ///
  /// Defaults to [dev] when the define is unset
  /// or contains an unrecognised value.
  static AppEnvironment fromDartDefine() {
    const envStr = String.fromEnvironment('ENV', defaultValue: 'dev');
    return AppEnvironment.values.firstWhere(
      (e) => e.name == envStr,
      orElse: () => AppEnvironment.dev,
    );
  }
}
