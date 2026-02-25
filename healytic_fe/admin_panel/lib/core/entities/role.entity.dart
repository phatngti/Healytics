enum Role { admin, health_partner, user }

extension RoleExtension on Role {
  String get value {
    switch (this) {
      case Role.admin:
        return 'admin';
      case Role.health_partner:
        return 'health_partner';
      case Role.user:
        return 'user';
    }
  }

  String get label {
    switch (this) {
      case Role.admin:
        return 'Admin';
      case Role.health_partner:
        return 'Partner';
      case Role.user:
        return 'User';
    }
  }
}
