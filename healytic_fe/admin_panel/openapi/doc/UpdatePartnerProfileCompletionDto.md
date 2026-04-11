# admin_openapi.model.UpdatePartnerProfileCompletionDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**coverImageUrl** | **String** | Public clinic cover image URL | [optional] 
**logoImageUrl** | **String** | Public clinic logo image URL | [optional] 
**description** | **String** | Public clinic profile description | [optional] 
**gallery** | **List<String>** | Gallery image URLs shown on the clinic profile | [optional] [default to const []]
**certifications** | [**List<UpdatePartnerCertificationDto>**](UpdatePartnerCertificationDto.md) | Optional trust badges/certifications shown on the clinic | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


