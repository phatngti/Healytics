//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApiClient {
  ApiClient({this.basePath = 'http://localhost', this.authentication,});

  final String basePath;
  final Authentication? authentication;

  var _client = Client();
  final _defaultHeaderMap = <String, String>{};

  /// Returns the current HTTP [Client] instance to use in this class.
  ///
  /// The return value is guaranteed to never be null.
  Client get client => _client;

  /// Requests to use a new HTTP [Client] in this class.
  set client(Client newClient) {
    _client = newClient;
  }

  Map<String, String> get defaultHeaderMap => _defaultHeaderMap;

  void addDefaultHeader(String key, String value) {
     _defaultHeaderMap[key] = value;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi', a key might appear multiple times.
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType,
  ) async {
    await authentication?.applyToParams(queryParams, headerParams);

    headerParams.addAll(_defaultHeaderMap);
    if (contentType != null) {
      headerParams['Content-Type'] = contentType;
    }

    final urlEncodedQueryParams = queryParams.map((param) => '$param');
    final queryString = urlEncodedQueryParams.isNotEmpty ? '?${urlEncodedQueryParams.join('&')}' : '';
    final uri = Uri.parse('$basePath$path$queryString');

    try {
      // Special case for uploading a single file which isn't a 'multipart/form-data'.
      if (
        body is MultipartFile && (contentType == null ||
        !contentType.toLowerCase().startsWith('multipart/form-data'))
      ) {
        final request = StreamedRequest(method, uri);
        request.headers.addAll(headerParams);
        request.contentLength = body.length;
        body.finalize().listen(
          request.sink.add,
          onDone: request.sink.close,
          // ignore: avoid_types_on_closure_parameters
          onError: (Object error, StackTrace trace) => request.sink.close(),
          cancelOnError: true,
        );
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      if (body is MultipartRequest) {
        final request = MultipartRequest(method, uri);
        request.fields.addAll(body.fields);
        request.files.addAll(body.files);
        request.headers.addAll(body.headers);
        request.headers.addAll(headerParams);
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      final msgBody = contentType == 'application/x-www-form-urlencoded'
        ? formParams
        : await serializeAsync(body);
      final nullableHeaderParams = headerParams.isEmpty ? null : headerParams;

      switch(method) {
        case 'POST': return await _client.post(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'PUT': return await _client.put(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'DELETE': return await _client.delete(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'PATCH': return await _client.patch(uri, headers: nullableHeaderParams, body: msgBody,);
        case 'HEAD': return await _client.head(uri, headers: nullableHeaderParams,);
        case 'GET': return await _client.get(uri, headers: nullableHeaderParams,);
      }
    } on SocketException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Socket operation failed: $method $path',
        error,
        trace,
      );
    } on TlsException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'TLS/SSL communication failed: $method $path',
        error,
        trace,
      );
    } on IOException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'I/O operation failed: $method $path',
        error,
        trace,
      );
    } on ClientException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'HTTP connection failed: $method $path',
        error,
        trace,
      );
    } on Exception catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Exception occurred: $method $path',
        error,
        trace,
      );
    }

    throw ApiException(
      HttpStatus.badRequest,
      'Invalid HTTP operation: $method $path',
    );
  }

  Future<dynamic> deserializeAsync(String value, String targetType, {bool growable = false,}) async =>
    // ignore: deprecated_member_use_from_same_package
    deserialize(value, targetType, growable: growable);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use deserializeAsync() instead.')
  dynamic deserialize(String value, String targetType, {bool growable = false,}) {
    // Remove all spaces. Necessary for regular expressions as well.
    targetType = targetType.replaceAll(' ', ''); // ignore: parameter_assignments

    // If the expected target type is String, nothing to do...
    return targetType == 'String'
      ? value
      : fromJson(json.decode(value), targetType, growable: growable);
  }

  // ignore: deprecated_member_use_from_same_package
  Future<String> serializeAsync(Object? value) async => serialize(value);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use serializeAsync() instead.')
  String serialize(Object? value) => value == null ? '' : json.encode(value);

  /// Returns a native instance of an OpenAPI class matching the [specified type][targetType].
  static dynamic fromJson(dynamic value, String targetType, {bool growable = false,}) {
    try {
      switch (targetType) {
        case 'String':
          return value is String ? value : value.toString();
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'double':
          return value is double ? value : double.parse('$value');
        case 'bool':
          if (value is bool) {
            return value;
          }
          final valueString = '$value'.toLowerCase();
          return valueString == 'true' || valueString == '1';
        case 'DateTime':
          return value is DateTime ? value : DateTime.tryParse(value);
        case 'Object':
          return value;
        case 'AccountMeResponseDto':
          return AccountMeResponseDto.fromJson(value);
        case 'AccountRequestDto':
          return AccountRequestDto.fromJson(value);
        case 'AddToCartDto':
          return AddToCartDto.fromJson(value);
        case 'AddressDto':
          return AddressDto.fromJson(value);
        case 'AddressInfoDto':
          return AddressInfoDto.fromJson(value);
        case 'AdminCategoryResponseDto':
          return AdminCategoryResponseDto.fromJson(value);
        case 'AdminFinanceAlertDto':
          return AdminFinanceAlertDto.fromJson(value);
        case 'AdminFinanceAuditEventDto':
          return AdminFinanceAuditEventDto.fromJson(value);
        case 'AdminFinanceCreateExportDto':
          return AdminFinanceCreateExportDto.fromJson(value);
        case 'AdminFinanceCreateNoteDto':
          return AdminFinanceCreateNoteDto.fromJson(value);
        case 'AdminFinanceExportJobDto':
          return AdminFinanceExportJobDto.fromJson(value);
        case 'AdminFinanceExportStatus':
          return AdminFinanceExportStatusTypeTransformer().decode(value);
        case 'AdminFinanceExportType':
          return AdminFinanceExportTypeTypeTransformer().decode(value);
        case 'AdminFinanceNoteActionDto':
          return AdminFinanceNoteActionDto.fromJson(value);
        case 'AdminFinanceNoteDto':
          return AdminFinanceNoteDto.fromJson(value);
        case 'AdminFinanceNoteEntityType':
          return AdminFinanceNoteEntityTypeTypeTransformer().decode(value);
        case 'AdminFinanceOverviewDto':
          return AdminFinanceOverviewDto.fromJson(value);
        case 'AdminFinancePageMetaDto':
          return AdminFinancePageMetaDto.fromJson(value);
        case 'AdminFinancePartnerExposureDto':
          return AdminFinancePartnerExposureDto.fromJson(value);
        case 'AdminFinancePayoutAttemptDto':
          return AdminFinancePayoutAttemptDto.fromJson(value);
        case 'AdminFinancePayoutDetailDto':
          return AdminFinancePayoutDetailDto.fromJson(value);
        case 'AdminFinancePayoutPageDto':
          return AdminFinancePayoutPageDto.fromJson(value);
        case 'AdminFinancePayoutRecordDto':
          return AdminFinancePayoutRecordDto.fromJson(value);
        case 'AdminFinancePeriod':
          return AdminFinancePeriodTypeTransformer().decode(value);
        case 'AdminFinanceProvider':
          return AdminFinanceProviderTypeTransformer().decode(value);
        case 'AdminFinanceProviderEventDto':
          return AdminFinanceProviderEventDto.fromJson(value);
        case 'AdminFinanceReconciliationDetailDto':
          return AdminFinanceReconciliationDetailDto.fromJson(value);
        case 'AdminFinanceReconciliationExceptionDto':
          return AdminFinanceReconciliationExceptionDto.fromJson(value);
        case 'AdminFinanceReconciliationPageDto':
          return AdminFinanceReconciliationPageDto.fromJson(value);
        case 'AdminFinanceReconciliationStatus':
          return AdminFinanceReconciliationStatusTypeTransformer().decode(value);
        case 'AdminFinanceReconciliationType':
          return AdminFinanceReconciliationTypeTypeTransformer().decode(value);
        case 'AdminFinanceRefundCaseDetailDto':
          return AdminFinanceRefundCaseDetailDto.fromJson(value);
        case 'AdminFinanceRefundCasePageDto':
          return AdminFinanceRefundCasePageDto.fromJson(value);
        case 'AdminFinanceRefundCaseRecordDto':
          return AdminFinanceRefundCaseRecordDto.fromJson(value);
        case 'AdminFinanceRequiredNoteActionDto':
          return AdminFinanceRequiredNoteActionDto.fromJson(value);
        case 'AdminFinanceReviewFlagActionDto':
          return AdminFinanceReviewFlagActionDto.fromJson(value);
        case 'AdminFinanceRiskTone':
          return AdminFinanceRiskToneTypeTransformer().decode(value);
        case 'AdminFinanceSettlementActionDto':
          return AdminFinanceSettlementActionDto.fromJson(value);
        case 'AdminFinanceTransactionDetailDto':
          return AdminFinanceTransactionDetailDto.fromJson(value);
        case 'AdminFinanceTransactionPageDto':
          return AdminFinanceTransactionPageDto.fromJson(value);
        case 'AdminFinanceTransactionRecordDto':
          return AdminFinanceTransactionRecordDto.fromJson(value);
        case 'AdminFinanceTrendPointDto':
          return AdminFinanceTrendPointDto.fromJson(value);
        case 'AdminLoginDto':
          return AdminLoginDto.fromJson(value);
        case 'AdminPartnerDetailResponseDto':
          return AdminPartnerDetailResponseDto.fromJson(value);
        case 'AiRecommendationItemDto':
          return AiRecommendationItemDto.fromJson(value);
        case 'AnalyticsAlertDto':
          return AnalyticsAlertDto.fromJson(value);
        case 'AnalyticsBookingMetricsDto':
          return AnalyticsBookingMetricsDto.fromJson(value);
        case 'AnalyticsCategoryPerformanceDto':
          return AnalyticsCategoryPerformanceDto.fromJson(value);
        case 'AnalyticsOperationalMetricDto':
          return AnalyticsOperationalMetricDto.fromJson(value);
        case 'AnalyticsReviewBucketDto':
          return AnalyticsReviewBucketDto.fromJson(value);
        case 'AnalyticsServicePerformanceDto':
          return AnalyticsServicePerformanceDto.fromJson(value);
        case 'AnalyticsTrendPointDto':
          return AnalyticsTrendPointDto.fromJson(value);
        case 'AppointmentCategoryResponseDto':
          return AppointmentCategoryResponseDto.fromJson(value);
        case 'AppointmentResponseDto':
          return AppointmentResponseDto.fromJson(value);
        case 'AppointmentStatus':
          return AppointmentStatusTypeTransformer().decode(value);
        case 'AsyncCheckoutDto':
          return AsyncCheckoutDto.fromJson(value);
        case 'AsyncCheckoutResponseDto':
          return AsyncCheckoutResponseDto.fromJson(value);
        case 'AttachTagResponseDto':
          return AttachTagResponseDto.fromJson(value);
        case 'AuthTokensDto':
          return AuthTokensDto.fromJson(value);
        case 'BookingResponseDto':
          return BookingResponseDto.fromJson(value);
        case 'BookingScheduleDto':
          return BookingScheduleDto.fromJson(value);
        case 'BookingServiceResponseDto':
          return BookingServiceResponseDto.fromJson(value);
        case 'BookingSpecialistResponseDto':
          return BookingSpecialistResponseDto.fromJson(value);
        case 'BookingStatus':
          return BookingStatusTypeTransformer().decode(value);
        case 'BookingStatusBreakdownDto':
          return BookingStatusBreakdownDto.fromJson(value);
        case 'BusinessInfo':
          return BusinessInfo.fromJson(value);
        case 'BusinessInfoDto':
          return BusinessInfoDto.fromJson(value);
        case 'BusinessServiceDto':
          return BusinessServiceDto.fromJson(value);
        case 'BusinessServicesResponseDto':
          return BusinessServicesResponseDto.fromJson(value);
        case 'BusinessType':
          return BusinessTypeTypeTransformer().decode(value);
        case 'CancelEmployeeAppointmentDto':
          return CancelEmployeeAppointmentDto.fromJson(value);
        case 'CartItemResponseDto':
          return CartItemResponseDto.fromJson(value);
        case 'CategoryInfoDto':
          return CategoryInfoDto.fromJson(value);
        case 'CategoryResponseDto':
          return CategoryResponseDto.fromJson(value);
        case 'CategorySummaryDto':
          return CategorySummaryDto.fromJson(value);
        case 'ChatbotRecommendationResponse':
          return ChatbotRecommendationResponse.fromJson(value);
        case 'ChatbotRecommenderRequest':
          return ChatbotRecommenderRequest.fromJson(value);
        case 'ChatbotRequest':
          return ChatbotRequest.fromJson(value);
        case 'CheckDuplicateSlotDto':
          return CheckDuplicateSlotDto.fromJson(value);
        case 'CheckDuplicateSlotResponseDto':
          return CheckDuplicateSlotResponseDto.fromJson(value);
        case 'CheckEmailDto':
          return CheckEmailDto.fromJson(value);
        case 'CheckEmailResponseDto':
          return CheckEmailResponseDto.fromJson(value);
        case 'CheckoutTicketResponseDto':
          return CheckoutTicketResponseDto.fromJson(value);
        case 'ClientKeyResponseDto':
          return ClientKeyResponseDto.fromJson(value);
        case 'ClinicCertificationDto':
          return ClinicCertificationDto.fromJson(value);
        case 'ClinicInfoResponseDto':
          return ClinicInfoResponseDto.fromJson(value);
        case 'ClinicProductCategoryDto':
          return ClinicProductCategoryDto.fromJson(value);
        case 'ClinicProductDto':
          return ClinicProductDto.fromJson(value);
        case 'ClinicProductsResponseDto':
          return ClinicProductsResponseDto.fromJson(value);
        case 'ClinicReviewDto':
          return ClinicReviewDto.fromJson(value);
        case 'ClinicReviewFilterDto':
          return ClinicReviewFilterDto.fromJson(value);
        case 'ClinicReviewResponseSubDto':
          return ClinicReviewResponseSubDto.fromJson(value);
        case 'ClinicReviewSummaryDto':
          return ClinicReviewSummaryDto.fromJson(value);
        case 'ClinicReviewsResponseDto':
          return ClinicReviewsResponseDto.fromJson(value);
        case 'ClinicSpecialistPreviewDto':
          return ClinicSpecialistPreviewDto.fromJson(value);
        case 'ClinicTrustMetricsDto':
          return ClinicTrustMetricsDto.fromJson(value);
        case 'CompletionChecklistItemDto':
          return CompletionChecklistItemDto.fromJson(value);
        case 'ConversationResponse':
          return ConversationResponse.fromJson(value);
        case 'ConversationResponseDto':
          return ConversationResponseDto.fromJson(value);
        case 'ConversationStatus':
          return ConversationStatusTypeTransformer().decode(value);
        case 'ConversationsPageResponse':
          return ConversationsPageResponse.fromJson(value);
        case 'CreateBroadcastDto':
          return CreateBroadcastDto.fromJson(value);
        case 'CreateCategoryDto':
          return CreateCategoryDto.fromJson(value);
        case 'CreateConversationDto':
          return CreateConversationDto.fromJson(value);
        case 'CreateDoctorDto':
          return CreateDoctorDto.fromJson(value);
        case 'CreateDoctorProfileDto':
          return CreateDoctorProfileDto.fromJson(value);
        case 'CreateMassageTherapistDto':
          return CreateMassageTherapistDto.fromJson(value);
        case 'CreateMoMoPaymentDto':
          return CreateMoMoPaymentDto.fromJson(value);
        case 'CreateMoMoRefundDto':
          return CreateMoMoRefundDto.fromJson(value);
        case 'CreatePartnerHealthServiceDefinitionDto':
          return CreatePartnerHealthServiceDefinitionDto.fromJson(value);
        case 'CreatePartnerHealthServiceDto':
          return CreatePartnerHealthServiceDto.fromJson(value);
        case 'CreatePartnerHealthServiceFacilityImageDto':
          return CreatePartnerHealthServiceFacilityImageDto.fromJson(value);
        case 'CreatePartnerHealthServiceMediaDto':
          return CreatePartnerHealthServiceMediaDto.fromJson(value);
        case 'CreateServiceTagDto':
          return CreateServiceTagDto.fromJson(value);
        case 'CreateSpaTherapistDto':
          return CreateSpaTherapistDto.fromJson(value);
        case 'CreateSpecialistReviewDto':
          return CreateSpecialistReviewDto.fromJson(value);
        case 'CreateTherapistProfileDto':
          return CreateTherapistProfileDto.fromJson(value);
        case 'CreateTreatmentReviewDto':
          return CreateTreatmentReviewDto.fromJson(value);
        case 'DashboardNotificationDto':
          return DashboardNotificationDto.fromJson(value);
        case 'DashboardReviewDto':
          return DashboardReviewDto.fromJson(value);
        case 'DashboardStatsResponseDto':
          return DashboardStatsResponseDto.fromJson(value);
        case 'DashboardTimePeriod':
          return DashboardTimePeriodTypeTransformer().decode(value);
        case 'DayScheduleDto':
          return DayScheduleDto.fromJson(value);
        case 'DeleteFileResponseDto':
          return DeleteFileResponseDto.fromJson(value);
        case 'DevicePlatform':
          return DevicePlatformTypeTransformer().decode(value);
        case 'DistanceMatrixElementDto':
          return DistanceMatrixElementDto.fromJson(value);
        case 'DistanceMatrixResponseDto':
          return DistanceMatrixResponseDto.fromJson(value);
        case 'DistanceMatrixRowDto':
          return DistanceMatrixRowDto.fromJson(value);
        case 'DoctorProfileResponseDto':
          return DoctorProfileResponseDto.fromJson(value);
        case 'DocumentEntryDto':
          return DocumentEntryDto.fromJson(value);
        case 'EmployeeAppointmentResponseDto':
          return EmployeeAppointmentResponseDto.fromJson(value);
        case 'EmployeeBookingStatusFilter':
          return EmployeeBookingStatusFilterTypeTransformer().decode(value);
        case 'EmployeeComplianceItemDto':
          return EmployeeComplianceItemDto.fromJson(value);
        case 'EmployeeDetailAnalyticsResponseDto':
          return EmployeeDetailAnalyticsResponseDto.fromJson(value);
        case 'EmployeeDistributionDto':
          return EmployeeDistributionDto.fromJson(value);
        case 'EmployeeLoginDto':
          return EmployeeLoginDto.fromJson(value);
        case 'EmployeeMixMetricDto':
          return EmployeeMixMetricDto.fromJson(value);
        case 'EmployeeOverviewAnalyticsResponseDto':
          return EmployeeOverviewAnalyticsResponseDto.fromJson(value);
        case 'EmployeePerformanceSummaryDto':
          return EmployeePerformanceSummaryDto.fromJson(value);
        case 'EmployeeQualityMetricDto':
          return EmployeeQualityMetricDto.fromJson(value);
        case 'EmployeeResponseDto':
          return EmployeeResponseDto.fromJson(value);
        case 'EmployeeRevenueBreakdownItemDto':
          return EmployeeRevenueBreakdownItemDto.fromJson(value);
        case 'EmployeeRevenuePeriod':
          return EmployeeRevenuePeriodTypeTransformer().decode(value);
        case 'EmployeeRevenueSummaryResponseDto':
          return EmployeeRevenueSummaryResponseDto.fromJson(value);
        case 'EmployeeRevenueTrendPointDto':
          return EmployeeRevenueTrendPointDto.fromJson(value);
        case 'EmployeeRole':
          return EmployeeRoleTypeTransformer().decode(value);
        case 'EmployeeRoleDistributionDto':
          return EmployeeRoleDistributionDto.fromJson(value);
        case 'EmployeeScheduleLoadDto':
          return EmployeeScheduleLoadDto.fromJson(value);
        case 'EmployeeStatus':
          return EmployeeStatusTypeTransformer().decode(value);
        case 'EmployeeTimeSlotsResponseDto':
          return EmployeeTimeSlotsResponseDto.fromJson(value);
        case 'EmployeeTrendPointDto':
          return EmployeeTrendPointDto.fromJson(value);
        case 'FacilityDto':
          return FacilityDto.fromJson(value);
        case 'FeaturedSpecialistResponseDto':
          return FeaturedSpecialistResponseDto.fromJson(value);
        case 'FileUrlResponseDto':
          return FileUrlResponseDto.fromJson(value);
        case 'FlagReviewDto':
          return FlagReviewDto.fromJson(value);
        case 'GeocodeResponseDto':
          return GeocodeResponseDto.fromJson(value);
        case 'GeocodeResultDto':
          return GeocodeResultDto.fromJson(value);
        case 'HealthServiceDetailAnalyticsResponseDto':
          return HealthServiceDetailAnalyticsResponseDto.fromJson(value);
        case 'HealthServiceOverviewAnalyticsResponseDto':
          return HealthServiceOverviewAnalyticsResponseDto.fromJson(value);
        case 'HealthServiceStatus':
          return HealthServiceStatusTypeTransformer().decode(value);
        case 'HealthServiceType':
          return HealthServiceTypeTypeTransformer().decode(value);
        case 'HomeRecommenderRequest':
          return HomeRecommenderRequest.fromJson(value);
        case 'InventoryAlertDto':
          return InventoryAlertDto.fromJson(value);
        case 'KycDocumentDto':
          return KycDocumentDto.fromJson(value);
        case 'LastMessageDto':
          return LastMessageDto.fromJson(value);
        case 'LegalRepresentativeDto':
          return LegalRepresentativeDto.fromJson(value);
        case 'LegalRepresentativeRequestDto':
          return LegalRepresentativeRequestDto.fromJson(value);
        case 'LocationInfoDto':
          return LocationInfoDto.fromJson(value);
        case 'LocationListResponseDto':
          return LocationListResponseDto.fromJson(value);
        case 'LocationResponseDto':
          return LocationResponseDto.fromJson(value);
        case 'LoginDto':
          return LoginDto.fromJson(value);
        case 'LogoutResponseDto':
          return LogoutResponseDto.fromJson(value);
        case 'MarkSettlementDto':
          return MarkSettlementDto.fromJson(value);
        case 'MedicalCredentialResponseDto':
          return MedicalCredentialResponseDto.fromJson(value);
        case 'MessageResponse':
          return MessageResponse.fromJson(value);
        case 'MessagesPageResponse':
          return MessagesPageResponse.fromJson(value);
        case 'MicroLockDto':
          return MicroLockDto.fromJson(value);
        case 'MicroLockResponseDto':
          return MicroLockResponseDto.fromJson(value);
        case 'MyProfileCompletionResponseDto':
          return MyProfileCompletionResponseDto.fromJson(value);
        case 'MyProfileResponseDto':
          return MyProfileResponseDto.fromJson(value);
        case 'NotificationResponseDto':
          return NotificationResponseDto.fromJson(value);
        case 'PaginatedEmployeeAppointmentsResponseDto':
          return PaginatedEmployeeAppointmentsResponseDto.fromJson(value);
        case 'PaginationMeta':
          return PaginationMeta.fromJson(value);
        case 'PaginationMetaResponseDto':
          return PaginationMetaResponseDto.fromJson(value);
        case 'ParticipantInfoDto':
          return ParticipantInfoDto.fromJson(value);
        case 'PartnerCategorySummaryDto':
          return PartnerCategorySummaryDto.fromJson(value);
        case 'PartnerClinicDto':
          return PartnerClinicDto.fromJson(value);
        case 'PartnerCommerceSourceType':
          return PartnerCommerceSourceTypeTypeTransformer().decode(value);
        case 'PartnerDayScheduleDto':
          return PartnerDayScheduleDto.fromJson(value);
        case 'PartnerDetailProcedureStepDto':
          return PartnerDetailProcedureStepDto.fromJson(value);
        case 'PartnerDetailServiceManualDto':
          return PartnerDetailServiceManualDto.fromJson(value);
        case 'PartnerDetailServiceRuleDto':
          return PartnerDetailServiceRuleDto.fromJson(value);
        case 'PartnerDocumentVerificationDto':
          return PartnerDocumentVerificationDto.fromJson(value);
        case 'PartnerFacilityImageDto':
          return PartnerFacilityImageDto.fromJson(value);
        case 'PartnerFeatureTagDto':
          return PartnerFeatureTagDto.fromJson(value);
        case 'PartnerFinancePeriod':
          return PartnerFinancePeriodTypeTransformer().decode(value);
        case 'PartnerFinanceSummaryDto':
          return PartnerFinanceSummaryDto.fromJson(value);
        case 'PartnerFinanceTrendPointDto':
          return PartnerFinanceTrendPointDto.fromJson(value);
        case 'PartnerHealthServiceDefinitionDto':
          return PartnerHealthServiceDefinitionDto.fromJson(value);
        case 'PartnerHealthServiceDetailResponseDto':
          return PartnerHealthServiceDetailResponseDto.fromJson(value);
        case 'PartnerHealthServiceEmployeeEligibilityDto':
          return PartnerHealthServiceEmployeeEligibilityDto.fromJson(value);
        case 'PartnerHealthServiceMediaDto':
          return PartnerHealthServiceMediaDto.fromJson(value);
        case 'PartnerHealthServiceResponseDto':
          return PartnerHealthServiceResponseDto.fromJson(value);
        case 'PartnerItemDto':
          return PartnerItemDto.fromJson(value);
        case 'PartnerLoginDto':
          return PartnerLoginDto.fromJson(value);
        case 'PartnerPayoutRecordDto':
          return PartnerPayoutRecordDto.fromJson(value);
        case 'PartnerPayoutStatus':
          return PartnerPayoutStatusTypeTransformer().decode(value);
        case 'PartnerPriority':
          return PartnerPriorityTypeTransformer().decode(value);
        case 'PartnerProcedureStepDto':
          return PartnerProcedureStepDto.fromJson(value);
        case 'PartnerProfileCompletionCertificationDto':
          return PartnerProfileCompletionCertificationDto.fromJson(value);
        case 'PartnerProfileCompletionIdentityDto':
          return PartnerProfileCompletionIdentityDto.fromJson(value);
        case 'PartnerPublicProfileResponseDto':
          return PartnerPublicProfileResponseDto.fromJson(value);
        case 'PartnerRecommendedServiceDto':
          return PartnerRecommendedServiceDto.fromJson(value);
        case 'PartnerRefundCaseRecordDto':
          return PartnerRefundCaseRecordDto.fromJson(value);
        case 'PartnerRefundCaseStatus':
          return PartnerRefundCaseStatusTypeTransformer().decode(value);
        case 'PartnerRefundCaseType':
          return PartnerRefundCaseTypeTypeTransformer().decode(value);
        case 'PartnerRequestDto':
          return PartnerRequestDto.fromJson(value);
        case 'PartnerReviewDto':
          return PartnerReviewDto.fromJson(value);
        case 'PartnerServiceManualDto':
          return PartnerServiceManualDto.fromJson(value);
        case 'PartnerServiceRuleDto':
          return PartnerServiceRuleDto.fromJson(value);
        case 'PartnerSettlementStatus':
          return PartnerSettlementStatusTypeTransformer().decode(value);
        case 'PartnerSpecialistDto':
          return PartnerSpecialistDto.fromJson(value);
        case 'PartnerTimeSlotDto':
          return PartnerTimeSlotDto.fromJson(value);
        case 'PartnerTransactionDetailDto':
          return PartnerTransactionDetailDto.fromJson(value);
        case 'PartnerTransactionRecordDto':
          return PartnerTransactionRecordDto.fromJson(value);
        case 'PartnerTransactionStatus':
          return PartnerTransactionStatusTypeTransformer().decode(value);
        case 'PartnerTransactionTimelineEventDto':
          return PartnerTransactionTimelineEventDto.fromJson(value);
        case 'PartnerTransactionType':
          return PartnerTransactionTypeTypeTransformer().decode(value);
        case 'PartnerVerificationStatus':
          return PartnerVerificationStatusTypeTransformer().decode(value);
        case 'PartnersResponseDto':
          return PartnersResponseDto.fromJson(value);
        case 'PresignRequestDto':
          return PresignRequestDto.fromJson(value);
        case 'PresignResponseDto':
          return PresignResponseDto.fromJson(value);
        case 'PriceBreakdownDto':
          return PriceBreakdownDto.fromJson(value);
        case 'ProcedureStepDto':
          return ProcedureStepDto.fromJson(value);
        case 'ProcedureStepInputDto':
          return ProcedureStepInputDto.fromJson(value);
        case 'PublicCategoryDto':
          return PublicCategoryDto.fromJson(value);
        case 'PublicCategorySummaryDto':
          return PublicCategorySummaryDto.fromJson(value);
        case 'PublicClinicCertificationDto':
          return PublicClinicCertificationDto.fromJson(value);
        case 'PublicClinicDto':
          return PublicClinicDto.fromJson(value);
        case 'PublicClinicFacilityImageDto':
          return PublicClinicFacilityImageDto.fromJson(value);
        case 'PublicClinicFeaturedServiceDto':
          return PublicClinicFeaturedServiceDto.fromJson(value);
        case 'PublicClinicInfoResponseDto':
          return PublicClinicInfoResponseDto.fromJson(value);
        case 'PublicClinicSpecialistPreviewDto':
          return PublicClinicSpecialistPreviewDto.fromJson(value);
        case 'PublicClinicTrustMetricsDto':
          return PublicClinicTrustMetricsDto.fromJson(value);
        case 'PublicEmployeeTimeSlotDto':
          return PublicEmployeeTimeSlotDto.fromJson(value);
        case 'PublicFacilityImageDto':
          return PublicFacilityImageDto.fromJson(value);
        case 'PublicFeatureTagDto':
          return PublicFeatureTagDto.fromJson(value);
        case 'PublicHealthServiceCardResponseDto':
          return PublicHealthServiceCardResponseDto.fromJson(value);
        case 'PublicHealthServiceDefinitionDto':
          return PublicHealthServiceDefinitionDto.fromJson(value);
        case 'PublicHealthServiceEmployeeDayScheduleDto':
          return PublicHealthServiceEmployeeDayScheduleDto.fromJson(value);
        case 'PublicHealthServiceEmployeeEligibilityDto':
          return PublicHealthServiceEmployeeEligibilityDto.fromJson(value);
        case 'PublicHealthServiceEmployeeResponseDto':
          return PublicHealthServiceEmployeeResponseDto.fromJson(value);
        case 'PublicHealthServiceInfoResponseDto':
          return PublicHealthServiceInfoResponseDto.fromJson(value);
        case 'PublicHealthServiceMediaDto':
          return PublicHealthServiceMediaDto.fromJson(value);
        case 'PublicHealthServiceRecommendedResponseDto':
          return PublicHealthServiceRecommendedResponseDto.fromJson(value);
        case 'PublicHealthServiceResponseDto':
          return PublicHealthServiceResponseDto.fromJson(value);
        case 'PublicHealthServiceReviewResponseDto':
          return PublicHealthServiceReviewResponseDto.fromJson(value);
        case 'PublicProfileAddressDto':
          return PublicProfileAddressDto.fromJson(value);
        case 'PublicProfileBusinessInfoDto':
          return PublicProfileBusinessInfoDto.fromJson(value);
        case 'PublicProfileCertificationDto':
          return PublicProfileCertificationDto.fromJson(value);
        case 'PublicProfileChecklistItemDto':
          return PublicProfileChecklistItemDto.fromJson(value);
        case 'PublicProfileCompletionSummaryDto':
          return PublicProfileCompletionSummaryDto.fromJson(value);
        case 'PublicProfileLegalSummaryDto':
          return PublicProfileLegalSummaryDto.fromJson(value);
        case 'PublicProfileStorefrontDto':
          return PublicProfileStorefrontDto.fromJson(value);
        case 'PublicServiceTagDto':
          return PublicServiceTagDto.fromJson(value);
        case 'RecommendationResponse':
          return RecommendationResponse.fromJson(value);
        case 'RecommendedServiceResponseDto':
          return RecommendedServiceResponseDto.fromJson(value);
        case 'RefreshTokenRequestDto':
          return RefreshTokenRequestDto.fromJson(value);
        case 'RefundCaseActionDto':
          return RefundCaseActionDto.fromJson(value);
        case 'RegisterDeviceDto':
          return RegisterDeviceDto.fromJson(value);
        case 'RegisterDto':
          return RegisterDto.fromJson(value);
        case 'RegisterPartnerDto':
          return RegisterPartnerDto.fromJson(value);
        case 'RegisterPartnerResponseDto':
          return RegisterPartnerResponseDto.fromJson(value);
        case 'RegisterProfileDto':
          return RegisterProfileDto.fromJson(value);
        case 'RetryPayoutDto':
          return RetryPayoutDto.fromJson(value);
        case 'RevenueDataPointDto':
          return RevenueDataPointDto.fromJson(value);
        case 'ReviewItemDto':
          return ReviewItemDto.fromJson(value);
        case 'ReviewPartnerProfileDto':
          return ReviewPartnerProfileDto.fromJson(value);
        case 'ReviewPartnerResponseDto':
          return ReviewPartnerResponseDto.fromJson(value);
        case 'ReviewSummaryDto':
          return ReviewSummaryDto.fromJson(value);
        case 'ServiceInfoDto':
          return ServiceInfoDto.fromJson(value);
        case 'ServiceManualInputDto':
          return ServiceManualInputDto.fromJson(value);
        case 'ServiceManualResponseDto':
          return ServiceManualResponseDto.fromJson(value);
        case 'ServicePerformanceDto':
          return ServicePerformanceDto.fromJson(value);
        case 'ServiceRuleDto':
          return ServiceRuleDto.fromJson(value);
        case 'ServiceRuleInputDto':
          return ServiceRuleInputDto.fromJson(value);
        case 'ServiceTagResponseDto':
          return ServiceTagResponseDto.fromJson(value);
        case 'SpecialistInfoDto':
          return SpecialistInfoDto.fromJson(value);
        case 'SpecialistReviewResponseDto':
          return SpecialistReviewResponseDto.fromJson(value);
        case 'StaffScheduleEntryDto':
          return StaffScheduleEntryDto.fromJson(value);
        case 'StripePaymentResponseDto':
          return StripePaymentResponseDto.fromJson(value);
        case 'StripeRefundResponseDto':
          return StripeRefundResponseDto.fromJson(value);
        case 'SurveyDto':
          return SurveyDto.fromJson(value);
        case 'SurveyResponseDto':
          return SurveyResponseDto.fromJson(value);
        case 'TherapistProfileResponseDto':
          return TherapistProfileResponseDto.fromJson(value);
        case 'TimeSlotDto':
          return TimeSlotDto.fromJson(value);
        case 'TotalPartnersResponseDto':
          return TotalPartnersResponseDto.fromJson(value);
        case 'TreatmentReviewResponseDto':
          return TreatmentReviewResponseDto.fromJson(value);
        case 'UpcomingAppointmentDto':
          return UpcomingAppointmentDto.fromJson(value);
        case 'UpdateCategoryDto':
          return UpdateCategoryDto.fromJson(value);
        case 'UpdateEmployeeDto':
          return UpdateEmployeeDto.fromJson(value);
        case 'UpdateEmployeeProfileDto':
          return UpdateEmployeeProfileDto.fromJson(value);
        case 'UpdatePartnerCertificationDto':
          return UpdatePartnerCertificationDto.fromJson(value);
        case 'UpdatePartnerDto':
          return UpdatePartnerDto.fromJson(value);
        case 'UpdatePartnerHealthServiceDto':
          return UpdatePartnerHealthServiceDto.fromJson(value);
        case 'UpdatePartnerProfileCompletionDto':
          return UpdatePartnerProfileCompletionDto.fromJson(value);
        case 'UpdatePartnerPublicProfileDto':
          return UpdatePartnerPublicProfileDto.fromJson(value);
        case 'UpdateServiceTagDto':
          return UpdateServiceTagDto.fromJson(value);
        case 'UserEligibilityDetailResponseDto':
          return UserEligibilityDetailResponseDto.fromJson(value);
        case 'UserProfileDto':
          return UserProfileDto.fromJson(value);
        case 'VerificationDocumentEntryDto':
          return VerificationDocumentEntryDto.fromJson(value);
        case 'VerifiedField':
          return VerifiedField.fromJson(value);
        case 'WorkHistoryEntryDto':
          return WorkHistoryEntryDto.fromJson(value);
        case 'WorkScheduleEntryDto':
          return WorkScheduleEntryDto.fromJson(value);
        default:
          dynamic match;
          if (value is List && (match = _regList.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toList(growable: growable);
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toSet();
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)?.group(1)) != null) {
            return Map<String, dynamic>.fromIterables(
              value.keys.cast<String>(),
              value.values.map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,)),
            );
          }
      }
    } on Exception catch (error, trace) {
      throw ApiException.withInner(HttpStatus.internalServerError, 'Exception during deserialization.', error, trace,);
    }
    throw ApiException(HttpStatus.internalServerError, 'Could not find a suitable class for deserialization',);
  }
}

/// Primarily intended for use in an isolate.
class DeserializationMessage {
  const DeserializationMessage({
    required this.json,
    required this.targetType,
    this.growable = false,
  });

  /// The JSON value to deserialize.
  final String json;

  /// Target type to deserialize to.
  final String targetType;

  /// Whether to make deserialized lists or maps growable.
  final bool growable;
}

/// Primarily intended for use in an isolate.
Future<dynamic> decodeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : json.decode(message.json);
}

/// Primarily intended for use in an isolate.
Future<dynamic> deserializeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : ApiClient.fromJson(
        json.decode(message.json),
        targetType,
        growable: message.growable,
      );
}

/// Primarily intended for use in an isolate.
Future<String> serializeAsync(Object? value) async => value == null ? '' : json.encode(value);
