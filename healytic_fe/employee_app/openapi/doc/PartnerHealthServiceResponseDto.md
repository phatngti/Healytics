# employee_openapi.model.PartnerHealthServiceResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique identifier | 
**name** | **String** | Name | 
**slug** | **String** | URL-friendly slug | 
**description** | **String** | Description | [optional] 
**type** | [**HealthServiceType**](HealthServiceType.md) |  | 
**basePrice** | **num** | Base price in specified currency | 
**salePrice** | **num** | Sale price if on discount | [optional] 
**currency** | **String** | Currency code (ISO 4217) | 
**status** | [**HealthServiceStatus**](HealthServiceStatus.md) |  | 
**isVisibleOnline** | **bool** | Whether visible online | 
**vendorName** | **String** | Vendor name | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**category** | [**PartnerCategorySummaryDto**](PartnerCategorySummaryDto.md) | Category | [optional] 
**media** | [**List<PartnerHealthServiceMediaDto>**](PartnerHealthServiceMediaDto.md) | Media assets | [optional] [default to const []]
**productDefinition** | [**PartnerHealthServiceDefinitionDto**](PartnerHealthServiceDefinitionDto.md) | Definition for service type | [optional] 
**productEmployeeEligibilities** | [**List<PartnerHealthServiceEmployeeEligibilityDto>**](PartnerHealthServiceEmployeeEligibilityDto.md) | Eligible employees for service | [optional] [default to const []]
**serviceManual** | [**PartnerServiceManualDto**](PartnerServiceManualDto.md) | Service manual (guidelines, rules, procedure steps) | [optional] 
**productTags** | [**List<PartnerProductTagDto>**](PartnerProductTagDto.md) | Feature tags associated with this service | [optional] [default to const []]
**tagIds** | **List<String>** | Tag IDs associated with this service | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


