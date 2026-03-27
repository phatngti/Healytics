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
part 'api/admin_audit_logs_api.dart';
part 'api/admin_categories_api.dart';
part 'api/admin_partners_api.dart';
part 'api/authentication_api.dart';
part 'api/categories_api.dart';
part 'api/chatbot_api.dart';
part 'api/health_api.dart';
part 'api/health_services_api.dart';
part 'api/locations_api.dart';
part 'api/mapbox_api.dart';
part 'api/partner_employees_api.dart';
part 'api/partner_health_services_api.dart';
part 'api/partner_partners_api.dart';
part 'api/partner_service_tags_api.dart';
part 'api/partners_api.dart';
part 'api/recommender_api.dart';
part 'api/s3_api.dart';
part 'api/user_bookings_api.dart';
part 'api/user_employees_api.dart';
part 'api/user_slots_api.dart';

part 'model/account_request_dto.dart';
part 'model/address_dto.dart';
part 'model/address_info_dto.dart';
part 'model/admin_category_response_dto.dart';
part 'model/admin_login_dto.dart';
part 'model/admin_partner_detail_response_dto.dart';
part 'model/async_checkout_dto.dart';
part 'model/async_checkout_response_dto.dart';
part 'model/attach_tag_response_dto.dart';
part 'model/auth_tokens_dto.dart';
part 'model/booking_response_dto.dart';
part 'model/business_info.dart';
part 'model/business_info_dto.dart';
part 'model/business_service_dto.dart';
part 'model/business_services_response_dto.dart';
part 'model/business_type.dart';
part 'model/category_response_dto.dart';
part 'model/category_summary_dto.dart';
part 'model/chatbot_recommendation_response.dart';
part 'model/chatbot_recommender_request.dart';
part 'model/chatbot_request.dart';
part 'model/checkout_ticket_response_dto.dart';
part 'model/client_key_response_dto.dart';
part 'model/create_category_dto.dart';
part 'model/create_doctor_dto.dart';
part 'model/create_doctor_profile_dto.dart';
part 'model/create_massage_therapist_dto.dart';
part 'model/create_partner_health_service_definition_dto.dart';
part 'model/create_partner_health_service_dto.dart';
part 'model/create_partner_health_service_facility_image_dto.dart';
part 'model/create_partner_health_service_media_dto.dart';
part 'model/create_partner_health_service_review_dto.dart';
part 'model/create_service_tag_dto.dart';
part 'model/create_spa_therapist_dto.dart';
part 'model/create_therapist_profile_dto.dart';
part 'model/delete_file_response_dto.dart';
part 'model/distance_matrix_element_dto.dart';
part 'model/distance_matrix_response_dto.dart';
part 'model/distance_matrix_row_dto.dart';
part 'model/doctor_profile_response_dto.dart';
part 'model/employee_response_dto.dart';
part 'model/file_url_response_dto.dart';
part 'model/geocode_response_dto.dart';
part 'model/geocode_result_dto.dart';
part 'model/home_recommender_request.dart';
part 'model/kyc_document_dto.dart';
part 'model/legal_representative_dto.dart';
part 'model/legal_representative_request_dto.dart';
part 'model/location_info.dart';
part 'model/location_list_response_dto.dart';
part 'model/location_response_dto.dart';
part 'model/login_dto.dart';
part 'model/logout_response_dto.dart';
part 'model/micro_lock_dto.dart';
part 'model/micro_lock_response_dto.dart';
part 'model/my_profile_response_dto.dart';
part 'model/partner_category_summary_dto.dart';
part 'model/partner_clinic_dto.dart';
part 'model/partner_day_schedule_dto.dart';
part 'model/partner_document_verification_dto.dart';
part 'model/partner_facility_image_dto.dart';
part 'model/partner_feature_tag_dto.dart';
part 'model/partner_health_service_definition_dto.dart';
part 'model/partner_health_service_detail_response_dto.dart';
part 'model/partner_health_service_employee_eligibility_dto.dart';
part 'model/partner_health_service_media_dto.dart';
part 'model/partner_health_service_response_dto.dart';
part 'model/partner_item_dto.dart';
part 'model/partner_login_dto.dart';
part 'model/partner_recommended_service_dto.dart';
part 'model/partner_request_dto.dart';
part 'model/partner_review_dto.dart';
part 'model/partner_specialist_dto.dart';
part 'model/partner_time_slot_dto.dart';
part 'model/partner_verification_status.dart';
part 'model/partners_response_dto.dart';
part 'model/presign_request_dto.dart';
part 'model/presign_response_dto.dart';
part 'model/price_info.dart';
part 'model/public_category_dto.dart';
part 'model/public_category_summary_dto.dart';
part 'model/public_clinic_dto.dart';
part 'model/public_employee_time_slot_dto.dart';
part 'model/public_facility_image_dto.dart';
part 'model/public_feature_tag_dto.dart';
part 'model/public_health_service_card_response_dto.dart';
part 'model/public_health_service_definition_dto.dart';
part 'model/public_health_service_employee_day_schedule_dto.dart';
part 'model/public_health_service_employee_eligibility_dto.dart';
part 'model/public_health_service_employee_response_dto.dart';
part 'model/public_health_service_info_response_dto.dart';
part 'model/public_health_service_media_dto.dart';
part 'model/public_health_service_recommended_response_dto.dart';
part 'model/public_health_service_response_dto.dart';
part 'model/public_health_service_review_response_dto.dart';
part 'model/public_service_tag_dto.dart';
part 'model/rating_info.dart';
part 'model/recommendation_response.dart';
part 'model/refresh_token_request_dto.dart';
part 'model/register_dto.dart';
part 'model/register_partner_dto.dart';
part 'model/register_partner_response_dto.dart';
part 'model/register_profile_dto.dart';
part 'model/review_item_dto.dart';
part 'model/review_partner_profile_dto.dart';
part 'model/review_partner_response_dto.dart';
part 'model/service_detail.dart';
part 'model/service_tag_response_dto.dart';
part 'model/survey_dto.dart';
part 'model/survey_response_dto.dart';
part 'model/therapist_profile_response_dto.dart';
part 'model/total_partners_response_dto.dart';
part 'model/update_category_dto.dart';
part 'model/update_employee_dto.dart';
part 'model/update_partner_dto.dart';
part 'model/update_partner_health_service_dto.dart';
part 'model/update_service_tag_dto.dart';
part 'model/verified_field.dart';
part 'model/work_schedule_entry_dto.dart';


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
