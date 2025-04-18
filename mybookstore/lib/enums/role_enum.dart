enum Role {
  admin,
  employee;

  static Role fromString(String role) {
    switch (role.toUpperCase()) {
      case 'Admin':
        return Role.admin;
      case 'Employee':
        return Role.employee;
      default:
        throw Exception('Invalid role: $role');
    }
  }
}