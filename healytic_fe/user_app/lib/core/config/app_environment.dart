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

  /// Local real-backend E2E testing through Patrol.
  test('store.test.json'),

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

  /// Web OAuth 2.0 client ID used as `serverClientId` by
  /// `GoogleSignInServiceImpl` so Google issues an ID token whose `aud`
  /// claim matches what the backend verifies.
  ///
  /// Sourced from `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`. The value
  /// is shared across all environments (dev / test / uat / prod) — it is
  /// NOT environment-specific because the OAuth Web client ID is a single
  /// Cloud Console artefact.
  ///
  /// Returns the empty string when the define is unset;
  /// `GoogleSignInServiceImpl` is expected to fail fast in that case
  /// rather than silently issuing a token with the wrong audience.
  ///
  /// This value MUST equal the backend's `GOOGLE_OAUTH_WEB_CLIENT_ID`
  /// environment variable character-for-character (see Reqs 12.5, 12.6).
  ///
  /// Example:
  /// ```bash
  /// flutter run \
  ///   --dart-define=ENV=dev \
  ///   --dart-define=GOOGLE_SERVER_CLIENT_ID=123-abc.apps.googleusercontent.com
  /// ```
  static String get googleServerClientId =>
      const String.fromEnvironment(
        'GOOGLE_SERVER_CLIENT_ID',
        defaultValue: '',
      );
}
