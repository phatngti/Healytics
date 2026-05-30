# user_openapi.model.SeedServiceDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** | Unique lookup key | [optional]
**partnerKey** | **String** | Key of a previously seeded partner | [optional]
**partnerBrandName** | **String** | Brand name to look up the partner | [optional]
**employeeKeys** | **List<String>** | Keys of previously seeded employees | [optional] [default to const []]
**categoryKey** | **String** | Key of a previously seeded category | [optional]
**categoryName** | **String** | Category name (auto-created if missing) | [optional]
**name** | **String** |  |
**slug** | **String** |  | [optional]
**description** | **String** |  | [optional]
**price** | **num** |  | [optional]
**durationMinutes** | **num** |  | [optional]
**vendorName** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


