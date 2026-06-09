# user_openapi.model.AdminPartnerItemDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**taxCode** | **String** |  | 
**legalName** | **String** |  | 
**brandName** | **String** |  | 
**email** | **String** |  | 
**businessType** | [**List<BusinessType>**](BusinessType.md) |  | [default to const []]
**verificationStatus** | [**PartnerVerificationStatus**](PartnerVerificationStatus.md) |  | 
**priority** | [**PartnerPriority**](PartnerPriority.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**verificationCompletedAt** | [**Object**](.md) |  | [optional] 
**isAccountActive** | **bool** | Whether the linked account is active | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


