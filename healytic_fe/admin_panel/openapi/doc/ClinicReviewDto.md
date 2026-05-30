# admin_openapi.model.ClinicReviewDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**reviewerName** | **String** | Masked name for privacy |
**reviewerInitial** | **String** |  |
**starCount** | **num** |  |
**memberBadge** | **String** | null for MVP | [optional]
**dateLabel** | **String** |  |
**serviceName** | **String** |  | [optional]
**serviceIcon** | **String** |  | [optional]
**reviewText** | **String** |  |
**mediaUrls** | **List<String>** |  | [default to const []]
**clinicResponse** | [**ClinicReviewResponseSubDto**](ClinicReviewResponseSubDto.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


