# employee_openapi.model.CreateFacilityReviewDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**appointmentId** | **String** | ID of the completed appointment to review | 
**facilityId** | **String** | ID of the clinic or facility being reviewed | 
**rating** | **num** | Rating from 1 to 5 | 
**comment** | **String** | Free-text comment (max 2000 chars) | [optional] 
**tags** | **List<String>** | Feedback tags (max 10) | [optional] [default to const []]
**photoKeys** | **List<String>** | S3 keys of uploaded photos (max 5). Upload via POST /v1/s3/presign first. | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


