class MemberModel {
  final String name;
  final String company;
  final String role;
  final String? phone;
  final bool isHighlighted;

  MemberModel(this.name, this.company, this.role,
      {this.phone, this.isHighlighted = false});
}
