//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerEmployeesApi {
  PartnerEmployeesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new doctor
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateDoctorDto] createDoctorDto (required):
  Future<Response> partnerEmployeesControllerCreateDoctorWithHttpInfo(CreateDoctorDto createDoctorDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/doctors';

    // ignore: prefer_final_locals
    Object? postBody = createDoctorDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new doctor
  ///
  /// Parameters:
  ///
  /// * [CreateDoctorDto] createDoctorDto (required):
  Future<EmployeeResponseDto?> partnerEmployeesControllerCreateDoctor(CreateDoctorDto createDoctorDto,) async {
    final response = await partnerEmployeesControllerCreateDoctorWithHttpInfo(createDoctorDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeResponseDto',) as EmployeeResponseDto;

    }
    return null;
  }

  /// Create a massage skill
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateSkillDto] createSkillDto (required):
  Future<Response> partnerEmployeesControllerCreateMassageSkillWithHttpInfo(CreateSkillDto createSkillDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/massage-skills';

    // ignore: prefer_final_locals
    Object? postBody = createSkillDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a massage skill
  ///
  /// Parameters:
  ///
  /// * [CreateSkillDto] createSkillDto (required):
  Future<SkillCatalogResponseDto?> partnerEmployeesControllerCreateMassageSkill(CreateSkillDto createSkillDto,) async {
    final response = await partnerEmployeesControllerCreateMassageSkillWithHttpInfo(createSkillDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SkillCatalogResponseDto',) as SkillCatalogResponseDto;

    }
    return null;
  }

  /// Create a new massage therapist
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateMassageTherapistDto] createMassageTherapistDto (required):
  Future<Response> partnerEmployeesControllerCreateMassageTherapistWithHttpInfo(CreateMassageTherapistDto createMassageTherapistDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/massage-therapists';

    // ignore: prefer_final_locals
    Object? postBody = createMassageTherapistDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new massage therapist
  ///
  /// Parameters:
  ///
  /// * [CreateMassageTherapistDto] createMassageTherapistDto (required):
  Future<EmployeeResponseDto?> partnerEmployeesControllerCreateMassageTherapist(CreateMassageTherapistDto createMassageTherapistDto,) async {
    final response = await partnerEmployeesControllerCreateMassageTherapistWithHttpInfo(createMassageTherapistDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeResponseDto',) as EmployeeResponseDto;

    }
    return null;
  }

  /// Create a spa skill
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateSkillDto] createSkillDto (required):
  Future<Response> partnerEmployeesControllerCreateSpaSkillWithHttpInfo(CreateSkillDto createSkillDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/spa-skills';

    // ignore: prefer_final_locals
    Object? postBody = createSkillDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a spa skill
  ///
  /// Parameters:
  ///
  /// * [CreateSkillDto] createSkillDto (required):
  Future<SkillCatalogResponseDto?> partnerEmployeesControllerCreateSpaSkill(CreateSkillDto createSkillDto,) async {
    final response = await partnerEmployeesControllerCreateSpaSkillWithHttpInfo(createSkillDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SkillCatalogResponseDto',) as SkillCatalogResponseDto;

    }
    return null;
  }

  /// Create a new spa therapist
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateSpaTherapistDto] createSpaTherapistDto (required):
  Future<Response> partnerEmployeesControllerCreateSpaTherapistWithHttpInfo(CreateSpaTherapistDto createSpaTherapistDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/spa-therapists';

    // ignore: prefer_final_locals
    Object? postBody = createSpaTherapistDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new spa therapist
  ///
  /// Parameters:
  ///
  /// * [CreateSpaTherapistDto] createSpaTherapistDto (required):
  Future<EmployeeResponseDto?> partnerEmployeesControllerCreateSpaTherapist(CreateSpaTherapistDto createSpaTherapistDto,) async {
    final response = await partnerEmployeesControllerCreateSpaTherapistWithHttpInfo(createSpaTherapistDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeResponseDto',) as EmployeeResponseDto;

    }
    return null;
  }

  /// Get all employees for this partner
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] role:
  ///
  /// * [String] sort:
  ///
  /// * [String] clinicId:
  ///
  /// * [String] provinceId:
  ///
  /// * [String] districtId:
  ///
  /// * [String] wardId:
  ///
  /// * [num] minExperienceYears:
  Future<Response> partnerEmployeesControllerFindAllWithHttpInfo({ String? role, String? sort, String? clinicId, String? provinceId, String? districtId, String? wardId, num? minExperienceYears, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (role != null) {
      queryParams.addAll(_queryParams('', 'role', role));
    }
    if (sort != null) {
      queryParams.addAll(_queryParams('', 'sort', sort));
    }
    if (clinicId != null) {
      queryParams.addAll(_queryParams('', 'clinicId', clinicId));
    }
    if (provinceId != null) {
      queryParams.addAll(_queryParams('', 'provinceId', provinceId));
    }
    if (districtId != null) {
      queryParams.addAll(_queryParams('', 'districtId', districtId));
    }
    if (wardId != null) {
      queryParams.addAll(_queryParams('', 'wardId', wardId));
    }
    if (minExperienceYears != null) {
      queryParams.addAll(_queryParams('', 'minExperienceYears', minExperienceYears));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get all employees for this partner
  ///
  /// Parameters:
  ///
  /// * [String] role:
  ///
  /// * [String] sort:
  ///
  /// * [String] clinicId:
  ///
  /// * [String] provinceId:
  ///
  /// * [String] districtId:
  ///
  /// * [String] wardId:
  ///
  /// * [num] minExperienceYears:
  Future<List<EmployeeResponseDto>?> partnerEmployeesControllerFindAll({ String? role, String? sort, String? clinicId, String? provinceId, String? districtId, String? wardId, num? minExperienceYears, }) async {
    final response = await partnerEmployeesControllerFindAllWithHttpInfo( role: role, sort: sort, clinicId: clinicId, provinceId: provinceId, districtId: districtId, wardId: wardId, minExperienceYears: minExperienceYears, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EmployeeResponseDto>') as List)
        .cast<EmployeeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get services assigned to an employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> partnerEmployeesControllerFindAssignedServicesWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/{id}/services'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get services assigned to an employee
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<List<EmployeeAssignedServiceDto>?> partnerEmployeesControllerFindAssignedServices(String id,) async {
    final response = await partnerEmployeesControllerFindAssignedServicesWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EmployeeAssignedServiceDto>') as List)
        .cast<EmployeeAssignedServiceDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get an employee by id
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> partnerEmployeesControllerFindOneWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get an employee by id
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<EmployeeResponseDto?> partnerEmployeesControllerFindOne(String id,) async {
    final response = await partnerEmployeesControllerFindOneWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeResponseDto',) as EmployeeResponseDto;

    }
    return null;
  }

  /// Get per-employee detail analytics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] employeeId (required):
  ///
  /// * [DashboardTimePeriod] period:
  ///   Time period for employee analytics aggregation
  Future<Response> partnerEmployeesControllerGetDetailAnalyticsWithHttpInfo(String employeeId, { DashboardTimePeriod? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/analytics/{employeeId}'
      .replaceAll('{employeeId}', employeeId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get per-employee detail analytics
  ///
  /// Parameters:
  ///
  /// * [String] employeeId (required):
  ///
  /// * [DashboardTimePeriod] period:
  ///   Time period for employee analytics aggregation
  Future<EmployeeDetailAnalyticsResponseDto?> partnerEmployeesControllerGetDetailAnalytics(String employeeId, { DashboardTimePeriod? period, }) async {
    final response = await partnerEmployeesControllerGetDetailAnalyticsWithHttpInfo(employeeId,  period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeDetailAnalyticsResponseDto',) as EmployeeDetailAnalyticsResponseDto;

    }
    return null;
  }

  /// Get massage skill catalog
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerEmployeesControllerGetMassageSkillsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/massage-skills';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get massage skill catalog
  Future<List<SkillCatalogResponseDto>?> partnerEmployeesControllerGetMassageSkills() async {
    final response = await partnerEmployeesControllerGetMassageSkillsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<SkillCatalogResponseDto>') as List)
        .cast<SkillCatalogResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get employee overview analytics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [DashboardTimePeriod] period:
  ///   Time period for employee analytics aggregation
  Future<Response> partnerEmployeesControllerGetOverviewAnalyticsWithHttpInfo({ DashboardTimePeriod? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/analytics/overview';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get employee overview analytics
  ///
  /// Parameters:
  ///
  /// * [DashboardTimePeriod] period:
  ///   Time period for employee analytics aggregation
  Future<EmployeeOverviewAnalyticsResponseDto?> partnerEmployeesControllerGetOverviewAnalytics({ DashboardTimePeriod? period, }) async {
    final response = await partnerEmployeesControllerGetOverviewAnalyticsWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeOverviewAnalyticsResponseDto',) as EmployeeOverviewAnalyticsResponseDto;

    }
    return null;
  }

  /// Get spa skill catalog
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerEmployeesControllerGetSpaSkillsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/spa-skills';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get spa skill catalog
  Future<List<SkillCatalogResponseDto>?> partnerEmployeesControllerGetSpaSkills() async {
    final response = await partnerEmployeesControllerGetSpaSkillsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<SkillCatalogResponseDto>') as List)
        .cast<SkillCatalogResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Delete an employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> partnerEmployeesControllerRemoveWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an employee
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> partnerEmployeesControllerRemove(String id,) async {
    final response = await partnerEmployeesControllerRemoveWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update an employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateEmployeeDto] updateEmployeeDto (required):
  Future<Response> partnerEmployeesControllerUpdateWithHttpInfo(String id, UpdateEmployeeDto updateEmployeeDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateEmployeeDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an employee
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateEmployeeDto] updateEmployeeDto (required):
  Future<EmployeeResponseDto?> partnerEmployeesControllerUpdate(String id, UpdateEmployeeDto updateEmployeeDto,) async {
    final response = await partnerEmployeesControllerUpdateWithHttpInfo(id, updateEmployeeDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeResponseDto',) as EmployeeResponseDto;

    }
    return null;
  }
}
