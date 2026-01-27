# user_openapi.model.ProductResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique product identifier | 
**name** | **String** | Product name | 
**slug** | **String** | URL-friendly slug | 
**description** | [**Object**](.md) | Product description | [optional] 
**type** | **String** | Product type | 
**basePrice** | **num** | Base price in specified currency | 
**salePrice** | [**Object**](.md) | Sale price if on discount | [optional] 
**currency** | **String** | Currency code (ISO 4217) | 
**status** | **String** | Product status | 
**isVisibleOnline** | **bool** | Whether product is visible online | 
**vendorName** | [**Object**](.md) | Vendor name | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**category** | [**CategorySummaryDto**](CategorySummaryDto.md) | Product category | [optional] 
**media** | [**List<ProductMediaDto>**](ProductMediaDto.md) | Product media assets | [optional] [default to const []]
**serviceDefinition** | [**ServiceDefinitionDto**](ServiceDefinitionDto.md) | Service definition for service products | [optional] 
**serviceEmployeeEligibilities** | [**List<ServiceEmployeeEligibilityDto>**](ServiceEmployeeEligibilityDto.md) | Eligible employees for service | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


