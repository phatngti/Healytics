# admin_openapi.model.CheckDuplicateSlotResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**isDuplicate** | **bool** | Whether a conflicting booking exists at this datetime |
**conflictingServiceName** | **String** | Name of the conflicting service/product (if duplicate found) | [optional]
**conflictingBookingId** | **String** | ID of the conflicting booking (if duplicate found) | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


