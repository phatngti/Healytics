# admin_openapi.model.ClinicInfoResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**coverImageUrl** | **String** |  | [optional] 
**logoImageUrl** | **String** |  | [optional] 
**gallery** | **List<String>** |  | [default to const []]
**followersLabel** | **String** |  | 
**reviewsLabel** | **String** |  | 
**description** | **String** |  | [optional] 
**trustMetrics** | [**ClinicTrustMetricsDto**](ClinicTrustMetricsDto.md) |  | 
**certifications** | [**List<ClinicCertificationDto>**](ClinicCertificationDto.md) |  | [default to const []]
**specialists** | [**List<ClinicSpecialistPreviewDto>**](ClinicSpecialistPreviewDto.md) |  | [default to const []]
**businessTypes** | **List<String>** |  | [default to const []]
**address** | **String** |  | [optional] 
**phoneNumber** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


