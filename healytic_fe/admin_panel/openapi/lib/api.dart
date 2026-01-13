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
part 'api/authentication_api.dart';
part 'api/categories_api.dart';
part 'api/employees_api.dart';
part 'api/products_api.dart';
part 'api/s3_api.dart';

part 'model/admin_login_dto.dart';
part 'model/auth_tokens_dto.dart';
part 'model/create_category_dto.dart';
part 'model/create_doctor_dto.dart';
part 'model/create_doctor_profile_dto.dart';
part 'model/create_product_dto.dart';
part 'model/create_product_media_dto.dart';
part 'model/create_service_definition_dto.dart';
part 'model/create_therapist_dto.dart';
part 'model/create_therapist_profile_dto.dart';
part 'model/doctor_profile_dto.dart';
part 'model/login_dto.dart';
part 'model/logout_response_dto.dart';
part 'model/register_dto.dart';
part 'model/register_profile_dto.dart';
part 'model/s3_controller_delete_file200_response.dart';
part 'model/s3_controller_get_file_url200_response.dart';
part 'model/s3_controller_pre_sign201_response.dart';
part 'model/s3_controller_pre_sign_request.dart';
part 'model/survey_dto.dart';
part 'model/survey_response_dto.dart';
part 'model/therapist_profile_dto.dart';
part 'model/update_category_dto.dart';
part 'model/update_employee_dto.dart';
part 'model/update_product_dto.dart';


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
