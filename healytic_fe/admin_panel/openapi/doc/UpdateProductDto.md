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
**vendorName** | **String** |  | [optional] 
**media** | [**List<CreateProductMediaDto>**](CreateProductMediaDto.md) | Product media (images/videos) | [optional] [default to const []]
**physicalDetails** | [**CreatePhysicalDetailsDto**](CreatePhysicalDetailsDto.md) | Physical product details (required if type is physical) | [optional] 
**serviceDefinition** | [**CreateServiceDefinitionDto**](CreateServiceDefinitionDto.md) | Service definition (required if type is service) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


