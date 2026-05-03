/// Common input validators for employee forms.
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
      return 'Password must be at least '
          '$minLength characters';
    }

    if (!RegExp(r'[a-z]').hasMatch(normalized)) {
      return 'Password must include at least '
          'one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(normalized)) {
      return 'Password must include at least '
          'one number';
    }
    return null;
  }

  static String? _normalize(Object? value) {
    return value?.toString().trim();
  }
}
