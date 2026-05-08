# employee_openapi.model.PartnerRequestDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**taxCode** | **String** | Tax code of the business (unique identifier) | 
**legalName** | **String** | Legal name of the business | 
**brandName** | **String** | Brand name of the business | 
**businessType** | [**List<BusinessType>**](BusinessType.md) |  | [default to const []]
**provinceId** | **String** | UUID of the province (from Location tree) | 
**districtId** | **String** | UUID of the district (from Location tree) | 
**wardId** | **String** | UUID of the ward (from Location tree) | 
**streetAddress** | **String** | Street address of the business | 
**phoneNumber** | **String** | Clinic/business contact phone number. This is the public-facing phone shown on the clinic info screen — NOT the legal representative's personal phone. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


