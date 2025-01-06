enum NBATemasProviderError {
  failedToLoadTeams('teams.failed_to_load'),
  unauthorized('teams.unauthorized'),
  noInternetConnection('teams.noInternetConnection'),
  timeout('teams.timeout');

  const NBATemasProviderError(this.errorKey);
  final String errorKey;
}

class Team {
  final int teamID;
  final String key;
  final bool active;
  final String city;
  final String name;
  final int leagueID;
  final int stadiumID;
  final String conference;
  final String division;
  final String primaryColor;
  final String secondaryColor;
  final String? tertiaryColor;
  final String? quaternaryColor;
  final String wikipediaLogoUrl;
  final String? wikipediaWordMarkUrl;
  final int globalTeamID;
  final int nbaDotComTeamID;
  final String headCoach;
  final bool favorite;

  Team(
    this.teamID,
    this.key,
    this.active,
    this.city,
    this.name,
    this.leagueID,
    this.stadiumID,
    this.conference,
    this.division,
    this.primaryColor,
    this.secondaryColor,
    this.tertiaryColor,
    this.quaternaryColor,
    this.wikipediaLogoUrl,
    this.wikipediaWordMarkUrl,
    this.globalTeamID,
    this.nbaDotComTeamID,
    this.headCoach,
    this.favorite,
  );

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      json['TeamID'],
      json['Key'],
      json['Active'],
      json['City'],
      json['Name'],
      json['LeagueID'],
      json['StadiumID'],
      json['Conference'],
      json['Division'],
      json['PrimaryColor'],
      json['SecondaryColor'],
      json['TertiaryColor'],
      json['QuaternaryColor'],
      json['WikipediaLogoUrl'],
      json['WikipediaWordMarkUrl'],
      json['GlobalTeamID'],
      json['NbaDotComTeamID'],
      json['HeadCoach'],
      false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TeamID': teamID,
      'Key': key,
      'Active': active,
      'City': city,
      'Name': name,
      'LeagueID': leagueID,
      'StadiumID': stadiumID,
      'Conference': conference,
      'Division': division,
      'PrimaryColor': primaryColor,
      'SecondaryColor': secondaryColor,
      'TertiaryColor': tertiaryColor,
      'QuaternaryColor': quaternaryColor,
      'WikipediaLogoUrl': wikipediaLogoUrl,
      'WikipediaWordMarkUrl': wikipediaWordMarkUrl,
      'GlobalTeamID': globalTeamID,
      'NbaDotComTeamID': nbaDotComTeamID,
      'HeadCoach': headCoach,
    };
  }

  Team copyWith({
    int? teamID,
    String? key,
    bool? active,
    String? city,
    String? name,
    int? leagueID,
    int? stadiumID,
    String? conference,
    String? division,
    String? primaryColor,
    String? secondaryColor,
    String? tertiaryColor,
    String? quaternaryColor,
    String? wikipediaLogoUrl,
    String? wikipediaWordMarkUrl,
    int? globalTeamID,
    int? nbaDotComTeamID,
    String? headCoach,
    bool? favorite,
  }) {
    return Team(
      teamID ?? this.teamID,
      key ?? this.key,
      active ?? this.active,
      city ?? this.city,
      name ?? this.name,
      leagueID ?? this.leagueID,
      stadiumID ?? this.stadiumID,
      conference ?? this.conference,
      division ?? this.division,
      primaryColor ?? this.primaryColor,
      secondaryColor ?? this.secondaryColor,
      tertiaryColor ?? this.tertiaryColor,
      quaternaryColor ?? this.quaternaryColor,
      wikipediaLogoUrl ?? this.wikipediaLogoUrl,
      wikipediaWordMarkUrl ?? this.wikipediaWordMarkUrl,
      globalTeamID ?? this.globalTeamID,
      nbaDotComTeamID ?? this.nbaDotComTeamID,
      headCoach ?? this.headCoach,
      favorite ?? this.favorite,
    );
  }
}
