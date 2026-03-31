# user_openapi.model.CreatePartnerHealthServiceDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**categoryId** | **String** |  | [optional] 
**name** | **String** |  | 
**slug** | **String** |  | 
**description** | **String** |  | [optional] 
**type** | **String** |  | 
**basePrice** | **num** |  | [optional] 
**salePrice** | **num** |  | [optional] 
**currency** | **String** |  | [optional] 
**status** | **String** |  | [optional] 
**isVisibleOnline** | **bool** |  | [optional] 
**employeeIds** | **List<String>** |  | [optional] [default to const []]
**media** | [**List<CreatePartnerHealthServiceMediaDto>**](CreatePartnerHealthServiceMediaDto.md) | Product media (images/videos) | [optional] [default to const []]
**productDefinition** | [**CreatePartnerHealthServiceDefinitionDto**](CreatePartnerHealthServiceDefinitionDto.md) | Product definition (required if type is service) | [optional] 
**facilityImages** | [**List<CreatePartnerHealthServiceFacilityImageDto>**](CreatePartnerHealthServiceFacilityImageDto.md) | Facility/clinic images | [optional] [default to const []]
**serviceManual** | [**ServiceManualInputDto**](ServiceManualInputDto.md) | Service manual (guidelines, rules, procedure steps) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


