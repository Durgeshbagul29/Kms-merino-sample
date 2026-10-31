class UserData {
  final int userId;
  final String userName;
  final String name;
  final String email;
  final String deptName;
  final int status;
  final int roleId;
  final String apiToken;

  UserData({
    required this.userId,
    required this.userName,
    required this.name,
    required this.email,
    required this.deptName,
    required this.status,
    required this.roleId,
    required this.apiToken,
  });

  factory UserData.empty() {
    return UserData(
      userId: 0,
      userName: '',
      name: '',
      email: '',
      deptName: '',
      status: 0,
      roleId: 0,
      apiToken: '',
    );
  }
}