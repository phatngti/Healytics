# admin_openapi.model.AdminCategoryResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique category identifier | 
**name** | **String** | Category name | 
**slug** | **String** | URL-friendly slug | 
**description** | [**Object**](.md) | Category description | [optional] 
**imageUrl** | [**Object**](.md) | Category image URL | [optional] 
**isActive** | **bool** | Whether category is active | 
**iconName** | [**Object**](.md) | Icon identifier for frontend rendering | [optional] 
**colorValue** | [**Object**](.md) | Hex color value (e.g. #FF6B6B) | [optional] 
**sortOrder** | **num** | Sort order for display (lower = first) | 
**serviceCount** | **num** | Number of health services in this category | 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**parent** | [**CategorySummaryDto**](CategorySummaryDto.md) | Parent category | [optional] 
**children** | [**List<CategorySummaryDto>**](CategorySummaryDto.md) | Child categories | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


