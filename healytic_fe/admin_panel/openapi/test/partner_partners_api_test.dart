//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_openapi/api.dart';
import 'package:test/test.dart';


/// tests for PartnerPartnersApi
void main() {
  // final instance = PartnerPartnersApi();

  group('tests for PartnerPartnersApi', () {
    // Get own business profile
    //
    // Partner gets their own business entity information
    //
    //Future<MyProfileResponseDto> partnerSelfControllerGetMyProfile() async
    test('test partnerSelfControllerGetMyProfile', () async {
      // TODO
    });

    // Get partner clinic profile completion data
    //
    // Returns verified clinic identity data and editable post-verification profile fields.
    //
    //Future<MyProfileCompletionResponseDto> partnerSelfControllerGetMyProfileCompletion() async
    test('test partnerSelfControllerGetMyProfileCompletion', () async {
      // TODO
    });

    // Get partner public profile edit aggregate
    //
    // Returns the full partner profile with read-only business context and editable storefront fields. Only available after profile completion.
    //
    //Future<PartnerPublicProfileResponseDto> partnerSelfControllerGetPublicProfile() async
    test('test partnerSelfControllerGetPublicProfile', () async {
      // TODO
    });

    // Update own business profile
    //
    // Partner updates their business information (limited fields)
    //
    //Future<MyProfileResponseDto> partnerSelfControllerUpdateMyProfile(UpdatePartnerDto updatePartnerDto) async
    test('test partnerSelfControllerUpdateMyProfile', () async {
      // TODO
    });

    // Update partner clinic profile completion data
    //
    // Immediately publishes post-verification clinic profile fields without entering admin review again.
    //
    //Future<MyProfileCompletionResponseDto> partnerSelfControllerUpdateMyProfileCompletion(UpdatePartnerProfileCompletionDto updatePartnerProfileCompletionDto) async
    test('test partnerSelfControllerUpdateMyProfileCompletion', () async {
      // TODO
    });

    // Update partner public profile (storefront only)
    //
    // Updates public-facing clinic profile fields (cover image, logo, description, gallery, certifications). Does not affect admin-verified business data.
    //
    //Future<PartnerPublicProfileResponseDto> partnerSelfControllerUpdatePublicProfile(UpdatePartnerPublicProfileDto updatePartnerPublicProfileDto) async
    test('test partnerSelfControllerUpdatePublicProfile', () async {
      // TODO
    });

  });
}
