class MemberModel {
  final String name;
  final String company;
  final String? phone;
  final String role;

  MemberModel({
    required this.name,
    required this.company,
    this.phone,
    required this.role,
  });
}
