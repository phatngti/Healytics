# user_openapi.model.PublicClinicInfoResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**address** | **String** |  | 
**isVerified** | **bool** |  | 
**coverImageUrl** | [**Object**](.md) |  | [optional] 
**logoImageUrl** | [**Object**](.md) |  | [optional] 
**gallery** | **List<String>** |  | [default to const []]
**rating** | **num** |  | 
**reviewCount** | **num** |  | 
**followersLabel** | **String** |  | 
**phone** | [**Object**](.md) |  | [optional] 
**coordinates** | [**Object**](.md) |  | [optional] 
**chatPartnerId** | [**Object**](.md) |  | [optional] 
**description** | [**Object**](.md) |  | [optional] 
**trustMetrics** | [**PublicClinicTrustMetricsDto**](PublicClinicTrustMetricsDto.md) |  | 
**certifications** | [**List<PublicClinicCertificationDto>**](PublicClinicCertificationDto.md) |  | [default to const []]
**specialists** | [**List<PublicClinicSpecialistPreviewDto>**](PublicClinicSpecialistPreviewDto.md) |  | [default to const []]
**facilityImages** | [**List<PublicClinicFacilityImageDto>**](PublicClinicFacilityImageDto.md) |  | [default to const []]
**featuredServices** | [**List<PublicClinicFeaturedServiceDto>**](PublicClinicFeaturedServiceDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


