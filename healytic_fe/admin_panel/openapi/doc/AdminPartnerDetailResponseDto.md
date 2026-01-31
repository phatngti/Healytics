# admin_openapi.model.AdminPartnerDetailResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**businessInfo** | [**BusinessInfoDto**](BusinessInfoDto.md) |  | 
**legalRepresentative** | [**LegalRepresentativeDto**](LegalRepresentativeDto.md) |  | [optional] 
**kycDocuments** | [**List<VerifiedField>**](VerifiedField.md) |  | [default to const []]
**status** | **String** |  | 
**priority** | **String** |  | 
**submittedAt** | [**DateTime**](DateTime.md) |  | 
**reviewNote** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


