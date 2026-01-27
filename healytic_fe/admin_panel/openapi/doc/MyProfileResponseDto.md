# admin_openapi.model.MyProfileResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**taxCode** | **String** |  | 
**legalName** | **String** |  | 
**brandName** | **String** |  | 
**businessType** | **String** |  | 
**phoneNumber** | [**Object**](.md) |  | 
**address** | [**AddressDto**](AddressDto.md) |  | 
**legalRepresentative** | [**LegalRepresentativeDto**](LegalRepresentativeDto.md) |  | 
**verificationStatus** | **String** |  | 
**rejectionDetails** | [**Object**](.md) | Field-level rejection details | 
**documents** | [**List<PartnerDocumentDto>**](PartnerDocumentDto.md) | List of documents with their status | [default to const []]
**verificationCompletedAt** | [**Object**](.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


