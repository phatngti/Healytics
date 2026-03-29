# user_openapi.api.UserReviewsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userReviewControllerSubmitSpecialistReview**](UserReviewsApi.md#userreviewcontrollersubmitspecialistreview) | **POST** /user/reviews/specialist | Submit a specialist review for a completed appointment
[**userReviewControllerSubmitTreatmentReview**](UserReviewsApi.md#userreviewcontrollersubmittreatmentreview) | **POST** /user/reviews/treatment | Submit a treatment review for a completed appointment


# **userReviewControllerSubmitSpecialistReview**
> SpecialistReviewResponseDto userReviewControllerSubmitSpecialistReview(createSpecialistReviewDto)

Submit a specialist review for a completed appointment

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserReviewsApi();
final createSpecialistReviewDto = CreateSpecialistReviewDto(); // CreateSpecialistReviewDto | 

try {
    final result = api_instance.userReviewControllerSubmitSpecialistReview(createSpecialistReviewDto);
    print(result);
} catch (e) {
    print('Exception when calling UserReviewsApi->userReviewControllerSubmitSpecialistReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSpecialistReviewDto** | [**CreateSpecialistReviewDto**](CreateSpecialistReviewDto.md)|  | 

### Return type

[**SpecialistReviewResponseDto**](SpecialistReviewResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userReviewControllerSubmitTreatmentReview**
> TreatmentReviewResponseDto userReviewControllerSubmitTreatmentReview(createTreatmentReviewDto)

Submit a treatment review for a completed appointment

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserReviewsApi();
final createTreatmentReviewDto = CreateTreatmentReviewDto(); // CreateTreatmentReviewDto | 

try {
    final result = api_instance.userReviewControllerSubmitTreatmentReview(createTreatmentReviewDto);
    print(result);
} catch (e) {
    print('Exception when calling UserReviewsApi->userReviewControllerSubmitTreatmentReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createTreatmentReviewDto** | [**CreateTreatmentReviewDto**](CreateTreatmentReviewDto.md)|  | 

### Return type

[**TreatmentReviewResponseDto**](TreatmentReviewResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

