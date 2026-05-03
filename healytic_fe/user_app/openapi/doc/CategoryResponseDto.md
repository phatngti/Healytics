# user_openapi.model.CategoryResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique category identifier | 
**name** | **String** | Category name | 
**slug** | **String** | URL-friendly slug | 
**description** | **String** | Category description | [optional] 
**imageUrl** | **String** | Category image URL | [optional] 
**isActive** | **bool** | Whether category is active | 
**categoryType** | **String** | Category type for UI grouping | [optional] [default to 'primary']
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**parent** | [**CategorySummaryDto**](CategorySummaryDto.md) | Parent category | [optional] 
**children** | [**List<CategorySummaryDto>**](CategorySummaryDto.md) | Child categories | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


