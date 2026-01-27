# user_openapi.model.ReviewItemDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**type** | **String** | Type of item being reviewed | 
**documentId** | **String** | UUID of the document (if type is DOCUMENT) | [optional] 
**fieldName** | **String** | Name of the field (if type is FIELD) | [optional] 
**isValid** | **bool** | Mark the item as valid or invalid | 
**reason** | **String** | Reason for rejection or feedback | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


