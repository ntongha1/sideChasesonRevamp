class DashboarStatsModel {
  String? total_teams = "0";
  String? total_players = "0";
  String? total_staffs = "0";
  String? teams_activity = "No activity this week";
  String? players_activity = "No activity this week";
  String? staffs_activity = "No activity this week";

  DashboarStatsModel(
      {this.total_teams,
      this.total_players,
      this.total_staffs,
      this.teams_activity,
      this.players_activity,
      this.staffs_activity});

  DashboarStatsModel.fromJson(Map<dynamic, dynamic> json) {
    print("looking for this?" + json.toString());
    total_teams = json['data'] != null && json['data']['teams'] != null
        ? json['data']['teams'].length.toString()
        : "0";
    total_players = json['data'] != null && json['data']['players'] != null
        ? json['data']['players'].length.toString()
        : "0";
    total_staffs = json['data'] != null && json['data']['staff'] != null
        ? json['data']['staff'].length.toString()
        : "0";
    teams_activity = "No activity this week";
    players_activity = "No activity this week";
    staffs_activity = "No activity this week";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['total_teams'] = this.total_teams;
    data['total_players'] = this.total_players;
    data['total_staffs'] = this.total_staffs;
    data['teams_activity'] = this.teams_activity;
    data['players_activity'] = this.players_activity;
    data['staffs_activity'] = this.staffs_activity;
    return data;
  }
}
