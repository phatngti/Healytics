# employee_openapi.api.TestBackdoorApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**testBackdoorControllerPrepare**](TestBackdoorApi.md#testbackdoorcontrollerprepare) | **POST** /test-backdoor/prepare | Reset DB then seed a scenario
[**testBackdoorControllerResetDb**](TestBackdoorApi.md#testbackdoorcontrollerresetdb) | **POST** /test-backdoor/reset-db | Truncate all non-master tables
[**testBackdoorControllerSeed**](TestBackdoorApi.md#testbackdoorcontrollerseed) | **POST** /test-backdoor/seed | Seed multiple entity types at once
[**testBackdoorControllerSeedBooking**](TestBackdoorApi.md#testbackdoorcontrollerseedbooking) | **POST** /test-backdoor/seed-booking | Seed a single booking
[**testBackdoorControllerSeedCart**](TestBackdoorApi.md#testbackdoorcontrollerseedcart) | **POST** /test-backdoor/seed-cart | Seed a single cart item
[**testBackdoorControllerSeedCategory**](TestBackdoorApi.md#testbackdoorcontrollerseedcategory) | **POST** /test-backdoor/seed-category | Seed a single category
[**testBackdoorControllerSeedCoupon**](TestBackdoorApi.md#testbackdoorcontrollerseedcoupon) | **POST** /test-backdoor/seed-coupon | Seed a single coupon
[**testBackdoorControllerSeedEmployee**](TestBackdoorApi.md#testbackdoorcontrollerseedemployee) | **POST** /test-backdoor/seed-employee | Seed a single employee
[**testBackdoorControllerSeedPartner**](TestBackdoorApi.md#testbackdoorcontrollerseedpartner) | **POST** /test-backdoor/seed-partner | Seed a single partner
[**testBackdoorControllerSeedService**](TestBackdoorApi.md#testbackdoorcontrollerseedservice) | **POST** /test-backdoor/seed-service | Seed a single health service
[**testBackdoorControllerSeedUser**](TestBackdoorApi.md#testbackdoorcontrollerseeduser) | **POST** /test-backdoor/seed-user | Seed a single user
[**testBackdoorControllerStatus**](TestBackdoorApi.md#testbackdoorcontrollerstatus) | **GET** /test-backdoor/status | Check if backdoor is available


# **testBackdoorControllerPrepare**
> SeedResponseDto testBackdoorControllerPrepare(backdoorPrepareDto)

Reset DB then seed a scenario

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final backdoorPrepareDto = BackdoorPrepareDto(); // BackdoorPrepareDto | 

try {
    final result = api_instance.testBackdoorControllerPrepare(backdoorPrepareDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerPrepare: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backdoorPrepareDto** | [**BackdoorPrepareDto**](BackdoorPrepareDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerResetDb**
> ResetDbResponseDto testBackdoorControllerResetDb()

Truncate all non-master tables

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();

try {
    final result = api_instance.testBackdoorControllerResetDb();
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerResetDb: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResetDbResponseDto**](ResetDbResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeed**
> SeedResponseDto testBackdoorControllerSeed(seedPayloadDto)

Seed multiple entity types at once

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedPayloadDto = SeedPayloadDto(); // SeedPayloadDto | 

try {
    final result = api_instance.testBackdoorControllerSeed(seedPayloadDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeed: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedPayloadDto** | [**SeedPayloadDto**](SeedPayloadDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedBooking**
> SeedResponseDto testBackdoorControllerSeedBooking(seedBookingDto)

Seed a single booking

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedBookingDto = SeedBookingDto(); // SeedBookingDto | 

try {
    final result = api_instance.testBackdoorControllerSeedBooking(seedBookingDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedBookingDto** | [**SeedBookingDto**](SeedBookingDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedCart**
> SeedResponseDto testBackdoorControllerSeedCart(seedCartItemDto)

Seed a single cart item

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedCartItemDto = SeedCartItemDto(); // SeedCartItemDto | 

try {
    final result = api_instance.testBackdoorControllerSeedCart(seedCartItemDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedCart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedCartItemDto** | [**SeedCartItemDto**](SeedCartItemDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedCategory**
> SeedResponseDto testBackdoorControllerSeedCategory(seedCategoryDto)

Seed a single category

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedCategoryDto = SeedCategoryDto(); // SeedCategoryDto | 

try {
    final result = api_instance.testBackdoorControllerSeedCategory(seedCategoryDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedCategory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedCategoryDto** | [**SeedCategoryDto**](SeedCategoryDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedCoupon**
> SeedResponseDto testBackdoorControllerSeedCoupon(seedCouponDto)

Seed a single coupon

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedCouponDto = SeedCouponDto(); // SeedCouponDto | 

try {
    final result = api_instance.testBackdoorControllerSeedCoupon(seedCouponDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedCoupon: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedCouponDto** | [**SeedCouponDto**](SeedCouponDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedEmployee**
> SeedResponseDto testBackdoorControllerSeedEmployee(seedEmployeeDto)

Seed a single employee

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedEmployeeDto = SeedEmployeeDto(); // SeedEmployeeDto | 

try {
    final result = api_instance.testBackdoorControllerSeedEmployee(seedEmployeeDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedEmployeeDto** | [**SeedEmployeeDto**](SeedEmployeeDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedPartner**
> SeedResponseDto testBackdoorControllerSeedPartner(seedPartnerDto)

Seed a single partner

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedPartnerDto = SeedPartnerDto(); // SeedPartnerDto | 

try {
    final result = api_instance.testBackdoorControllerSeedPartner(seedPartnerDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedPartner: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedPartnerDto** | [**SeedPartnerDto**](SeedPartnerDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedService**
> SeedResponseDto testBackdoorControllerSeedService(seedServiceDto)

Seed a single health service

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedServiceDto = SeedServiceDto(); // SeedServiceDto | 

try {
    final result = api_instance.testBackdoorControllerSeedService(seedServiceDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedService: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedServiceDto** | [**SeedServiceDto**](SeedServiceDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerSeedUser**
> SeedResponseDto testBackdoorControllerSeedUser(seedUserDto)

Seed a single user

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();
final seedUserDto = SeedUserDto(); // SeedUserDto | 

try {
    final result = api_instance.testBackdoorControllerSeedUser(seedUserDto);
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerSeedUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seedUserDto** | [**SeedUserDto**](SeedUserDto.md)|  | 

### Return type

[**SeedResponseDto**](SeedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **testBackdoorControllerStatus**
> BackdoorStatusResponseDto testBackdoorControllerStatus()

Check if backdoor is available

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = TestBackdoorApi();

try {
    final result = api_instance.testBackdoorControllerStatus();
    print(result);
} catch (e) {
    print('Exception when calling TestBackdoorApi->testBackdoorControllerStatus: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BackdoorStatusResponseDto**](BackdoorStatusResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

