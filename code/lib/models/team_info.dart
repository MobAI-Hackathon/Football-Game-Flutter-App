class TeamInfo {
  static const double initialBudget = 100.0;
  static const int maxPlayers = 11;
  static const String defaultFormation = '4-3-3';
  
  double budgetLeft;
  int numberOfPlayers;
  String formation;

  TeamInfo({
    this.budgetLeft = initialBudget,
    this.numberOfPlayers = 0,
    this.formation = defaultFormation,
  });
}
