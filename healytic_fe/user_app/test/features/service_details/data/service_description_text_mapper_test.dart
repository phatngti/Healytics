import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/service_details/data/mappers/service_description_text.mapper.dart';

void main() {
  group('serviceDescriptionToPlainText', () {
    test('converts a Quill Delta object string to readable text', () {
      const raw =
          '{"ops":[{"insert":"Signature Rejuvenating Facial"},{"insert":"\\n","attributes":{"header":2}},{"insert":"A luxurious treatment.\\n\\n"},{"insert":"Key Benefits"},{"insert":"\\n","attributes":{"header":3}},{"insert":"Deep hydration"},{"insert":"\\n","attributes":{"list":"bullet"}},{"insert":"Brightens skin tone"},{"insert":"\\n","attributes":{"list":"bullet"}},{"insert":"Ideal for all skin types. Results visible after first session.\\n"}]}';

      expect(
        serviceDescriptionToPlainText(raw),
        [
          'Signature Rejuvenating Facial',
          'A luxurious treatment.',
          '',
          'Key Benefits',
          '- Deep hydration',
          '- Brightens skin tone',
          'Ideal for all skin types. Results visible after first session.',
        ].join('\n'),
      );
    });

    test('converts a decoded Quill Delta list to readable text', () {
      final raw = [
        {'insert': 'Relaxing treatment'},
        {
          'insert': '\n',
          'attributes': {'header': 2},
        },
        {'insert': 'Calming pressure'},
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'},
        },
      ];

      expect(
        serviceDescriptionToPlainText(raw),
        'Relaxing treatment\n- Calming pressure',
      );
    });

    test('keeps normal text unchanged', () {
      const raw = 'A normal treatment description.';

      expect(serviceDescriptionToPlainText(raw), raw);
    });

    test('keeps malformed JSON unchanged', () {
      const raw = '[{"insert":"Missing end"';

      expect(serviceDescriptionToPlainText(raw), raw);
    });

    test('treats an empty Quill document as empty text', () {
      const raw = '[{"insert":"\\n"}]';

      expect(serviceDescriptionToPlainText(raw), '');
    });
  });
}
