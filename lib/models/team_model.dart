class TeamModel {
  String id;
  String hackathonId;
  String teamName;
  String leaderId;
  List<String> memberIds;
  List<String> requiredSkills;
  String description;
  int currentSize;
  int maxSize;

  TeamModel({
    required this.id,
    required this.hackathonId,
    required this.teamName,
    required this.leaderId,
    required this.memberIds,
    required this.requiredSkills,
    required this.description,
    required this.currentSize,
    required this.maxSize,
  });
}
