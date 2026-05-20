# admin_openapi.model.UpdatePartnerProfileCompletionDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**coverImageUrl** | **String** | Public clinic cover image URL (required to complete your profile) | 
**logoImageUrl** | **String** | Public clinic logo image URL (required to complete your profile) | 
**description** | **String** | Public clinic profile description (min 120 characters, required to complete your profile) | 
**gallery** | **List<String>** | Gallery image URLs shown on the clinic profile (min 3, required to complete your profile) | [default to const []]
**certifications** | [**List<UpdatePartnerCertificationDto>**](UpdatePartnerCertificationDto.md) | Optional trust badges/certifications shown on the clinic | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


