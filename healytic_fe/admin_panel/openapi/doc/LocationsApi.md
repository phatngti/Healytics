# admin_openapi.api.LocationsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**locationsControllerGetDistricts**](LocationsApi.md#locationscontrollergetdistricts) | **GET** /locations/provinces/{provinceId}/districts | Get all districts in a province
[**locationsControllerGetProvinces**](LocationsApi.md#locationscontrollergetprovinces) | **GET** /locations/provinces | Get all provinces in Vietnam
[**locationsControllerGetWards**](LocationsApi.md#locationscontrollergetwards) | **GET** /locations/districts/{districtId}/wards | Get all wards in a district
[**locationsControllerSeedData**](LocationsApi.md#locationscontrollerseeddata) | **POST** /locations/seed | Seed Vietnam administrative divisions data


# **locationsControllerGetDistricts**
> GetDistrictsResponseDto locationsControllerGetDistricts(provinceId)

Get all districts in a province

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = LocationsApi();
final provinceId = uuid; // String | 

try {
    final result = api_instance.locationsControllerGetDistricts(provinceId);
    print(result);
} catch (e) {
    print('Exception when calling LocationsApi->locationsControllerGetDistricts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provinceId** | **String**|  | 

### Return type

[**GetDistrictsResponseDto**](GetDistrictsResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **locationsControllerGetProvinces**
> GetProvincesResponseDto locationsControllerGetProvinces()

Get all provinces in Vietnam

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = LocationsApi();

try {
    final result = api_instance.locationsControllerGetProvinces();
    print(result);
} catch (e) {
    print('Exception when calling LocationsApi->locationsControllerGetProvinces: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetProvincesResponseDto**](GetProvincesResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **locationsControllerGetWards**
> GetWardsResponseDto locationsControllerGetWards(districtId)

Get all wards in a district

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = LocationsApi();
final districtId = uuid; // String | 

try {
    final result = api_instance.locationsControllerGetWards(districtId);
    print(result);
} catch (e) {
    print('Exception when calling LocationsApi->locationsControllerGetWards: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **districtId** | **String**|  | 

### Return type

[**GetWardsResponseDto**](GetWardsResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **locationsControllerSeedData**
> locationsControllerSeedData()

Seed Vietnam administrative divisions data

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = LocationsApi();

try {
    api_instance.locationsControllerSeedData();
} catch (e) {
    print('Exception when calling LocationsApi->locationsControllerSeedData: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

