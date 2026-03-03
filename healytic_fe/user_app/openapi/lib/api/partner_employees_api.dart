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

  /// Create a new therapist
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateTherapistDto] createTherapistDto (required):
  Future<Response> partnerEmployeesControllerCreateTherapistWithHttpInfo(CreateTherapistDto createTherapistDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/employees/therapists';

    // ignore: prefer_final_locals
    Object? postBody = createTherapistDto;

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

  /// Create a new therapist
  ///
  /// Parameters:
  ///
  /// * [CreateTherapistDto] createTherapistDto (required):
  Future<EmployeeResponseDto?> partnerEmployeesControllerCreateTherapist(CreateTherapistDto createTherapistDto,) async {
    final response = await partnerEmployeesControllerCreateTherapistWithHttpInfo(createTherapistDto,);
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
  Future<Response> partnerEmployeesControllerFindAllWithHttpInfo({ String? role, }) async {
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
  Future<List<EmployeeResponseDto>?> partnerEmployeesControllerFindAll({ String? role, }) async {
    final response = await partnerEmployeesControllerFindAllWithHttpInfo( role: role, );
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
