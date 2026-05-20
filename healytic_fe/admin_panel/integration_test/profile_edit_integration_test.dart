library;

import 'package:admin_panel/features/partner/profile_edit/data/provider/public_profile.provider.dart';
import 'package:admin_panel/features/partner/profile_edit/data/public_profile_remote.datasource.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/screens/profile_edit.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileEditScreen integration', () {
    testWidgets('saves only changed certifications through sparse patch', (
      tester,
    ) async {
      final dataSource = _FakePublicProfileRemoteDataSource();
      await _pumpProfileEdit(tester, dataSource);

      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text('Trust badges and certifications'),
        500,
        scrollable: scrollable,
      );
      await tester.tap(find.byTooltip('Edit certification'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'ISO 9001:2015 Updated',
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Save'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Save').last);
      await tester.pumpAndSettle();

      final patch = dataSource.lastPatch;
      expect(patch, isNotNull);
      expect(patch!.includeCertifications, isTrue);
      expect(patch.includeCoverImageUrl, isFalse);
      expect(patch.includeLogoImageUrl, isFalse);
      expect(patch.includeDescription, isFalse);
      expect(patch.includeGallery, isFalse);
      expect(patch.certifications, hasLength(1));
      expect(patch.certifications!.single.title, 'ISO 9001:2015 Updated');
    });

    testWidgets('blocks save when required storefront data is incomplete', (
      tester,
    ) async {
      final dataSource = _FakePublicProfileRemoteDataSource();
      await _pumpProfileEdit(tester, dataSource);

      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.byTooltip('Remove image').first,
        500,
        scrollable: scrollable,
      );
      await tester.tap(find.byTooltip('Remove image').first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Save').last);
      await tester.pumpAndSettle();

      expect(dataSource.updateCalls, 0);
      expect(
        find.text(
          'Complete cover, logo, description, and gallery before saving.',
        ),
        findsOneWidget,
      );
      expect(find.text('Cover image is required.'), findsOneWidget);
    });
  });
}

Future<void> _pumpProfileEdit(
  WidgetTester tester,
  PublicProfileRemoteDataSource dataSource,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        publicProfileDataSourceProvider.overrideWithValue(dataSource),
      ],
      child: MaterialApp(
        home: const ProfileEditScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: FlutterQuillLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakePublicProfileRemoteDataSource
    implements PublicProfileRemoteDataSource {
  PublicProfileUpdatePatch? lastPatch;
  int updateCalls = 0;

  PartnerPublicProfileEntity _entity = PartnerPublicProfileEntity(
    id: 'partner-1',
    businessInfo: const PublicProfileBusinessInfo(
      brandName: 'Healytics Wellness Center',
      legalName: 'Healytics Wellness Company',
      taxCode: '0123456789',
      businessType: ['SPA_BEAUTY'],
      phoneNumber: '0901234567',
      email: 'partner@healytics.vn',
    ),
    address: const PublicProfileAddress(
      streetAddress: '123 Nguyen Hue',
      ward: LocationRef(id: 'ward-1', name: 'Ward 1'),
      district: LocationRef(id: 'district-1', name: 'District 1'),
      province: LocationRef(id: 'province-1', name: 'Ho Chi Minh City'),
      formattedAddress: '123 Nguyen Hue, Ward 1, District 1, Ho Chi Minh City',
    ),
    legalSummary: const PublicProfileLegalSummary(
      fullName: 'Nguyen Van A',
      position: 'Director',
      idType: 'CCCD',
      idNumber: '012345678901',
    ),
    verificationStatus: 'APPROVED',
    storefront: const PublicProfileStorefront(
      coverImageUrl: 'https://cdn.example.com/cover.jpg',
      logoImageUrl: 'https://cdn.example.com/logo.jpg',
      description:
          '[{"insert":"A modern wellness clinic focused on preventive care, '
          'personalized treatment planning, and a calm patient experience '
          'across consultation, therapy, recovery, and follow-up visits.\\n"}]',
      gallery: [
        'https://cdn.example.com/gallery-1.jpg',
        'https://cdn.example.com/gallery-2.jpg',
        'https://cdn.example.com/gallery-3.jpg',
      ],
      certifications: [
        PublicProfileCertification(
          id: 'cert-1',
          title: 'ISO 9001:2015',
          subtitle: 'Quality Management',
          iconName: 'workspace_premium',
        ),
      ],
    ),
    completionSummary: const PublicProfileCompletionSummary(
      checklist: [
        PublicProfileChecklistItem(
          key: 'coverImageUrl',
          label: 'Clinic cover image',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'logoImageUrl',
          label: 'Clinic logo image',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'description',
          label: 'Clinic description',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'gallery',
          label: 'Clinic gallery',
          isRequired: true,
          completed: true,
        ),
      ],
      completionPercent: 100,
      isCompleted: true,
    ),
  );

  @override
  Future<PartnerPublicProfileEntity> getPublicProfile() async {
    return _entity;
  }

  @override
  Future<PartnerPublicProfileEntity> updatePublicProfile(
    PublicProfileUpdatePatch request,
  ) async {
    lastPatch = request;
    updateCalls++;

    final current = _entity.storefront;
    final next = current.copyWith(
      coverImageUrl: request.includeCoverImageUrl
          ? request.coverImageUrl
          : current.coverImageUrl,
      logoImageUrl: request.includeLogoImageUrl
          ? request.logoImageUrl
          : current.logoImageUrl,
      description: request.includeDescription
          ? request.description
          : current.description,
      gallery: request.includeGallery
          ? request.gallery ?? const <String>[]
          : current.gallery,
      certifications: request.includeCertifications
          ? request.certifications ?? const <PublicProfileCertification>[]
          : current.certifications,
    );

    _entity = _entity.copyWith(storefront: next);
    return _entity;
  }
}
