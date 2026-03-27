# user_openapi.model.PublicHealthServiceResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique identifier | 
**name** | **String** | Name | 
**slug** | **String** | URL-friendly slug | 
**description** | [**Object**](.md) | Description | [optional] 
**type** | **String** | Type | 
**basePrice** | **num** | Base price in specified currency | 
**salePrice** | [**Object**](.md) | Sale price if on discount | [optional] 
**currency** | **String** | Currency code (ISO 4217) | 
**status** | **String** | Status | 
**isVisibleOnline** | **bool** | Whether visible online | 
**vendorName** | [**Object**](.md) | Vendor name | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**category** | [**PublicCategorySummaryDto**](PublicCategorySummaryDto.md) | Category | [optional] 
**media** | [**List<PublicHealthServiceMediaDto>**](PublicHealthServiceMediaDto.md) | Media assets | [optional] [default to const []]
**productDefinition** | [**PublicHealthServiceDefinitionDto**](PublicHealthServiceDefinitionDto.md) | Definition for service type | [optional] 
**productEmployeeEligibilities** | [**List<PublicHealthServiceEmployeeEligibilityDto>**](PublicHealthServiceEmployeeEligibilityDto.md) | Eligible employees for service | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


