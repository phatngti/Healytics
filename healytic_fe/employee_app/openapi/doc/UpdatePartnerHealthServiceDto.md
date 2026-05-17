# employee_openapi.model.UpdatePartnerHealthServiceDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**categoryId** | **String** |  | [optional] 
**description** | **String** |  | [optional] 
**salePrice** | **num** |  | [optional] 
**name** | **String** |  | [optional] 
**slug** | **String** |  | [optional] 
**type** | [**HealthServiceType**](HealthServiceType.md) |  | [optional] 
**basePrice** | **num** |  | [optional] 
**currency** | **String** |  | [optional] 
**status** | **String** |  | [optional] 
**isVisibleOnline** | **bool** |  | [optional] 
**employeeIds** | **List<String>** |  | [optional] [default to const []]
**tagIds** | **List<String>** | Feature tag IDs to associate with this service (full replacement) | [optional] [default to const []]
**media** | [**List<CreatePartnerHealthServiceMediaDto>**](CreatePartnerHealthServiceMediaDto.md) |  | [optional] [default to const []]
**productDefinition** | [**CreatePartnerHealthServiceDefinitionDto**](CreatePartnerHealthServiceDefinitionDto.md) |  | [optional] 
**facilityImages** | [**List<CreatePartnerHealthServiceFacilityImageDto>**](CreatePartnerHealthServiceFacilityImageDto.md) |  | [optional] [default to const []]
**serviceManual** | [**ServiceManualInputDto**](ServiceManualInputDto.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


