# user_openapi.model.UpdatePartnerDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**taxCode** | **String** | Tax code (updatable if rejected) | [optional] 
**businessType** | **String** | Business Type | [optional] 
**legalName** | **String** | Legal name of the business | [optional] 
**brandName** | **String** | Brand name of the business | [optional] 
**phoneNumber** | **String** | Contact phone number | [optional] 
**provinceId** | **String** | Province ID (administrative division) | [optional] 
**districtId** | **String** | District ID (administrative division) | [optional] 
**wardId** | **String** | Ward ID (administrative division) | [optional] 
**streetAddress** | **String** | Street address | [optional] 
**legalRepresentative** | [**UpdateLegalRepresentativeDto**](UpdateLegalRepresentativeDto.md) | Legal representative information to update | [optional] 
**documents** | [**List<DocumentUpdateDto>**](DocumentUpdateDto.md) | List of documents to update or upload | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


