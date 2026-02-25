//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/account_api.dart';
part 'api/admin_partners_api.dart';
part 'api/audit_logs_api.dart';
part 'api/authentication_api.dart';
part 'api/categories_api.dart';
part 'api/chatbot_api.dart';
part 'api/employees_api.dart';
part 'api/locations_api.dart';
part 'api/partner_products_api.dart';
part 'api/partners_api.dart';
part 'api/products_api.dart';
part 'api/s3_api.dart';
part 'api/service_tags_api.dart';

part 'model/account_request_dto.dart';
part 'model/address_dto.dart';
part 'model/address_info_dto.dart';
part 'model/admin_login_dto.dart';
part 'model/admin_partner_detail_response_dto.dart';
part 'model/attach_tag_response_dto.dart';
part 'model/auth_tokens_dto.dart';
part 'model/business_info.dart';
part 'model/business_info_dto.dart';
part 'model/business_service_dto.dart';
part 'model/business_services_response_dto.dart';
part 'model/business_type.dart';
part 'model/category_response_dto.dart';
part 'model/category_summary_dto.dart';
part 'model/chat_message_response_dto.dart';
part 'model/clinic_dto.dart';
part 'model/create_category_dto.dart';
part 'model/create_doctor_dto.dart';
part 'model/create_doctor_profile_dto.dart';
part 'model/create_product_dto.dart';
part 'model/create_product_facility_image_dto.dart';
part 'model/create_product_media_dto.dart';
part 'model/create_product_review_dto.dart';
part 'model/create_service_definition_dto.dart';
part 'model/create_service_tag_dto.dart';
part 'model/create_therapist_dto.dart';
part 'model/create_therapist_profile_dto.dart';
part 'model/day_schedule_dto.dart';
part 'model/delete_file_response_dto.dart';
part 'model/doctor_profile_dto.dart';
part 'model/employee_response_dto.dart';
part 'model/facility_image_dto.dart';
part 'model/feature_tag_dto.dart';
part 'model/file_url_response_dto.dart';
part 'model/get_districts_response_dto.dart';
part 'model/get_provinces_response_dto.dart';
part 'model/get_wards_response_dto.dart';
part 'model/kyc_document_dto.dart';
part 'model/legal_representative_dto.dart';
part 'model/legal_representative_request_dto.dart';
part 'model/location_dto.dart';
part 'model/login_dto.dart';
part 'model/logout_response_dto.dart';
part 'model/my_profile_response_dto.dart';
part 'model/partner_document_verification_dto.dart';
part 'model/partner_item_dto.dart';
part 'model/partner_login_dto.dart';
part 'model/partner_request_dto.dart';
part 'model/partner_verification_status.dart';
part 'model/partners_response_dto.dart';
part 'model/presign_request_dto.dart';
part 'model/presign_response_dto.dart';
part 'model/product_detail_response_dto.dart';
part 'model/product_media_dto.dart';
part 'model/product_response_dto.dart';
part 'model/recommended_service_dto.dart';
part 'model/refresh_token_request_dto.dart';
part 'model/register_dto.dart';
part 'model/register_partner_dto.dart';
part 'model/register_partner_response_dto.dart';
part 'model/register_profile_dto.dart';
part 'model/review_dto.dart';
part 'model/review_item_dto.dart';
part 'model/review_partner_profile_dto.dart';
part 'model/review_partner_response_dto.dart';
part 'model/send_message_dto.dart';
part 'model/send_message_response_dto.dart';
part 'model/service_definition_dto.dart';
part 'model/service_employee_eligibility_dto.dart';
part 'model/service_tag_response_dto.dart';
part 'model/specialist_dto.dart';
part 'model/survey_dto.dart';
part 'model/survey_response_dto.dart';
part 'model/therapist_profile_dto.dart';
part 'model/time_slot_dto.dart';
part 'model/total_partners_response_dto.dart';
part 'model/update_category_dto.dart';
part 'model/update_employee_dto.dart';
part 'model/update_partner_dto.dart';
part 'model/update_product_dto.dart';
part 'model/update_service_tag_dto.dart';
part 'model/verified_field.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
