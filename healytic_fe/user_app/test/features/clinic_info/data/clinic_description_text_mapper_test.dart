import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/clinic_info/data/mappers/clinic_description_text.mapper.dart';

void main() {
  group('clinicDescriptionToPlainText', () {
    test('converts a Quill Delta list string to plain text', () {
      const raw =
          '[{"insert":"A central District 1 wellness clinic focused on massage therapy.\\n"}]';

      expect(
        clinicDescriptionToPlainText(raw),
        'A central District 1 wellness clinic focused on massage therapy.',
      );
    });

    test('converts a Quill Delta ops object to plain text', () {
      const raw =
          '{"ops":[{"insert":"Skin care","attributes":{"bold":true}},{"insert":" and recovery\\n"}]}';

      expect(clinicDescriptionToPlainText(raw), 'Skin care and recovery');
    });

    test('keeps normal text unchanged', () {
      const raw = 'A normal clinic description.';

      expect(clinicDescriptionToPlainText(raw), raw);
    });

    test('keeps malformed JSON unchanged', () {
      const raw = '[{"insert":"Missing end"';

      expect(clinicDescriptionToPlainText(raw), raw);
    });

    test('treats an empty Quill document as empty text', () {
      const raw = '[{"insert":"\\n"}]';

      expect(clinicDescriptionToPlainText(raw), '');
    });
  });
}
