# admin_openapi.model.UpdateProductDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**categoryId** | **String** |  | [optional] 
**name** | **String** |  | [optional] 
**slug** | **String** |  | [optional] 
**description** | **String** |  | [optional] 
**type** | **String** |  | [optional] 
**basePrice** | **num** |  | [optional] 
**salePrice** | **num** |  | [optional] 
**currency** | **String** |  | [optional] 
**status** | **String** |  | [optional] 
**isVisibleOnline** | **bool** |  | [optional] 
**employeeIds** | **List<String>** |  | [optional] [default to const []]
**media** | [**List<CreateProductMediaDto>**](CreateProductMediaDto.md) | Product media (images/videos) | [optional] [default to const []]
**serviceDefinition** | [**CreateServiceDefinitionDto**](CreateServiceDefinitionDto.md) | Service definition (required if type is service) | [optional] 
**facilityImages** | [**List<CreateProductFacilityImageDto>**](CreateProductFacilityImageDto.md) | Facility/clinic images | [optional] [default to const []]
**reviews** | [**List<CreateProductReviewDto>**](CreateProductReviewDto.md) | Product reviews | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


