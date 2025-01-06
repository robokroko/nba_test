abstract class Environment {
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://api.sportsdata.io/v3/nba/scores/json');
  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '1171b4ed8f644d499462fcf13d8d5afa');
}
