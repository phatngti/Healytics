# employee_openapi.model.AdminCategoryResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
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
**parentId** | **String** | Parent category ID. Null for root categories. | [optional] 
**isRoot** | **bool** | Whether this category is a root category. | 
**iconName** | **String** | Icon identifier for frontend rendering | [optional] 
**colorValue** | **String** | Hex color value (e.g. #FF6B6B) | [optional] 
**sortOrder** | **num** | Sort order for display (lower = first) | 
**serviceCount** | **num** | Number of health services in this category | 
**subCategoryCount** | **num** | Number of direct child sub-categories | 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**parent** | [**CategorySummaryDto**](CategorySummaryDto.md) | Parent category | [optional] 
**children** | [**List<CategorySummaryDto>**](CategorySummaryDto.md) | Child categories | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


