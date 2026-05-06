# employee_openapi.model.MyProfileResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**businessInfo** | [**BusinessInfoDto**](BusinessInfoDto.md) |  | 
**legalRepresentative** | [**LegalRepresentativeDto**](LegalRepresentativeDto.md) |  | [optional] 
**kycDocuments** | [**List<VerifiedField>**](VerifiedField.md) |  | [default to const []]
**verificationStatus** | [**PartnerVerificationStatus**](PartnerVerificationStatus.md) |  | 
**verificationCompletedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


