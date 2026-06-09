# user_openapi.model.AdminPartnerDetailResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**businessInfo** | [**BusinessInfoDto**](BusinessInfoDto.md) |  | 
**legalRepresentative** | [**LegalRepresentativeDto**](LegalRepresentativeDto.md) |  | [optional] 
**kycDocuments** | [**List<VerifiedField>**](VerifiedField.md) |  | [default to const []]
**status** | [**PartnerVerificationStatus**](PartnerVerificationStatus.md) |  | 
**priority** | [**PartnerPriority**](PartnerPriority.md) |  | 
**submittedAt** | [**DateTime**](DateTime.md) |  | 
**reviewNote** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


