class UserModel {
  String id;
  String name;
  String email;
  String college;
  int year;
  List<String> skills;
  String lookingFor;
  List<String> portfolioLinks;
  String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.college,
    required this.year,
    required this.skills,
    required this.lookingFor,
    required this.portfolioLinks,
    required this.profileImage,
  });
}
