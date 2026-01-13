enum TherapistType {
  spa,
  massage;

  String get displayName {
    switch (this) {
      case TherapistType.spa:
        return 'Spa Therapist';
      case TherapistType.massage:
        return 'Massage Therapist';
    }
  }

  String get apiValue {
    switch (this) {
      case TherapistType.spa:
        return 'SPA';
      case TherapistType.massage:
        return 'MASSAGE';
    }
  }
}
