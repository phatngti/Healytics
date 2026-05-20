/// Common input validators for user-facing forms.
final class FormValidators {
  const FormValidators._();

  static String? requiredField(Object? value, {required String fieldName}) {
    final normalized = _normalize(value);
    if (normalized == null || normalized.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  static String? email(Object? value) {
    final requiredMessage = requiredField(value, fieldName: 'email address');
    if (requiredMessage != null) return requiredMessage;

    final normalized = _normalize(value)!;
    final emailPattern = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );
    if (!emailPattern.hasMatch(normalized)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(Object? value, {int minLength = 8}) {
    final requiredMessage = requiredField(value, fieldName: 'password');
    if (requiredMessage != null) return requiredMessage;

    final normalized = _normalize(value)!;
    if (normalized.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (!RegExp(r'[a-z]').hasMatch(normalized)) {
      return 'Password must include at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(normalized)) {
      return 'Password must include at least one number';
    }
    return null;
  }

  static String? confirmPassword(Object? value, {required String password}) {
    final requiredMessage = requiredField(
      value,
      fieldName: 'password confirmation',
    );
    if (requiredMessage != null) return requiredMessage;

    final normalized = _normalize(value)!;
    if (normalized != password.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? fullName(Object? value, {required String fieldName}) {
    final requiredMessage = requiredField(value, fieldName: fieldName);
    if (requiredMessage != null) return requiredMessage;

    final normalized = _normalize(value)!;
    if (normalized.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    if (RegExp(r'[0-9]').hasMatch(normalized)) {
      return '$fieldName cannot contain numbers';
    }
    return null;
  }

  static String? otpCode(Object? value, {int length = 5}) {
    final requiredMessage = requiredField(
      value,
      fieldName: 'verification code',
    );
    if (requiredMessage != null) return requiredMessage;

    final normalized = _normalize(value)!;
    final digitPattern = RegExp('^[0-9]{$length}\$');
    if (!digitPattern.hasMatch(normalized)) {
      return 'Verification code must be $length digits';
    }
    return null;
  }

  static String? phone(Object? value) {
    final normalized = _normalize(value);
    if (normalized == null || normalized.isEmpty) return null;

    final phonePattern = RegExp(r'^(?:\+84|84|0)(?:3|5|7|8|9)[0-9]{8}$');
    if (!phonePattern.hasMatch(normalized)) {
      return 'Please enter a valid Vietnamese phone number';
    }
    return null;
  }

  static String? dateOfBirth(Object? value, {int minAge = 16}) {
    final requiredMessage = requiredField(value, fieldName: 'date of birth');
    if (requiredMessage != null) return requiredMessage;

    DateTime? dob;
    if (value is DateTime) {
      dob = value;
    } else if (value is String) {
      dob = DateTime.tryParse(value);
    }

    if (dob == null) {
      return 'Please enter a valid date';
    }

    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    if (age < minAge) {
      return 'You must be at least $minAge years old';
    }
    return null;
  }

  static String? _normalize(Object? value) {
    return value?.toString().trim();
  }
}
