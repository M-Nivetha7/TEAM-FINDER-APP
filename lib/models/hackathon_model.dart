class HackathonModel {
  String id;
  String name;
  String organizer;
  String date;
  String mode;
  String location;
  String description;
  List<String> requiredSkills;
  int teamSize;
  String prize;
  bool isRegistered;

  HackathonModel({
    required this.id,
    required this.name,
    required this.organizer,
    required this.date,
    required this.mode,
    required this.location,
    required this.description,
    required this.requiredSkills,
    required this.teamSize,
    required this.prize,
    this.isRegistered = false,
  });
}
