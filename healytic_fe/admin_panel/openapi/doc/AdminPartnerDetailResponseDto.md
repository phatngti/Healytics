# admin_openapi.model.AdminPartnerDetailResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**email** | **String** |  | 
**taxCode** | **String** |  | 
**legalName** | **String** |  | 
**brandName** | **String** |  | 
**businessType** | **String** |  | 
**phoneNumber** | [**Object**](.md) |  | 
**address** | [**AddressDto**](AddressDto.md) |  | 
**verificationStatus** | **String** |  | 
**verificationCompletedAt** | [**Object**](.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**legalRepresentative** | [**AdminLegalRepresentativeDto**](AdminLegalRepresentativeDto.md) |  | 
**documents** | [**List<PartnerDocumentDto>**](PartnerDocumentDto.md) |  | [default to const []]
**rejectionDetails** | [**Object**](.md) | Field-level rejection details | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


