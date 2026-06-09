# admin_openapi.model.UpdatePartnerPublicProfileDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**coverImageUrl** | **String** | Public clinic cover image URL | [optional] 
**logoImageUrl** | **String** | Public clinic logo image URL | [optional] 
**description** | **String** | Public clinic profile description (120–1000 chars recommended) | [optional] 
**gallery** | **List<String>** | Gallery image URLs shown on the clinic profile (max 8) | [optional] [default to const []]
**certifications** | [**List<UpdatePartnerCertificationDto>**](UpdatePartnerCertificationDto.md) | Trust badges and certifications shown on the clinic profile | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


