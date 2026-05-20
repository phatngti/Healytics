//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library test_backdoor_api;

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

part 'api/test_backdoor_api.dart';

part 'model/backdoor_prepare_dto.dart';
part 'model/backdoor_status_response_dto.dart';
part 'model/reset_db_response_dto.dart';
part 'model/seed_booking_dto.dart';
part 'model/seed_cart_item_dto.dart';
part 'model/seed_category_dto.dart';
part 'model/seed_coupon_dto.dart';
part 'model/seed_employee_dto.dart';
part 'model/seed_ids_map_dto.dart';
part 'model/seed_notification_dto.dart';
part 'model/seed_partner_dto.dart';
part 'model/seed_payload_dto.dart';
part 'model/seed_response_dto.dart';
part 'model/seed_service_dto.dart';
part 'model/seed_user_dto.dart';


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
