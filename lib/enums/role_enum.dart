enum Role {
  admin,
  employee;

  static Role fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Role.admin;
      case 'employee':
        return Role.employee;
      default:
        throw Exception('Invalid role: $role');
    }
  }

  @override
  String toString() {
    switch (this) {
      case Role.admin:
        return 'admin';
      case Role.employee:
        return 'employee';
    }
  }
}
