# user_openapi.model.LegalRepresentativeRequestDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**fullName** | **String** | Full name of legal representative | 
**position** | **String** | Position in the company | [optional] 
**phoneNumber** | **String** | Phone number of legal representative | [optional] 
**idType** | **String** | Type of identification document | 
**idNumber** | **String** | ID number (9 or 12 digits for Vietnam) | 
**idIssueDate** | **String** | Date of ID issuance (ISO 8601 format) | 
**documents** | [**List<PartnerDocumentVerificationDto>**](PartnerDocumentVerificationDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


