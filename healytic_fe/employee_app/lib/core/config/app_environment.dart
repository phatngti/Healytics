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

  /// Whether this environment uses mock data sources
  /// instead of real API calls.
  bool get useMock => this == AppEnvironment.dev;

  // -- static singleton ----------------------------------

  static AppEnvironment? _current;

  /// The resolved environment for this app run.
  ///
  /// Set once via [setCurrent] during bootstrap.
  /// Throws if accessed before initialisation.
  static AppEnvironment get current {
    if (_current == null) {
      throw StateError(
        'AppEnvironment not initialised. '
        'Call setCurrent() first.',
      );
    }
    return _current!;
  }

  /// Stores the resolved environment for the run.
  ///
  /// Must be called exactly once during bootstrap.
  static void setCurrent(AppEnvironment env) {
    _current = env;
  }

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
