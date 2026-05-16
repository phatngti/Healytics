# employee_openapi.model.SeedCouponDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** | Unique lookup key | [optional] 
**code** | **String** |  | 
**discountPercent** | **num** |  | 
**maxDiscountAmount** | **num** |  | [optional] 
**usageLimit** | **num** |  | [optional] 
**serviceKey** | **String** | Key of a previously seeded service | [optional] 
**serviceSlug** | **String** | Slug to look up the service | [optional] 
**categoryName** | **String** | Category name (auto-created if missing) | [optional] 
**expiresAt** | **String** | ISO 8601 expiry | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


