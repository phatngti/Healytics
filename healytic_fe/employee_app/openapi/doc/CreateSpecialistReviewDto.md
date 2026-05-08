# employee_openapi.model.CreateSpecialistReviewDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**appointmentId** | **String** | ID of the completed appointment | 
**specialistId** | **String** | ID of the specialist/employee who performed the service | 
**rating** | **num** | Rating from 1 to 5 | 
**comment** | **String** | Free-text comment (max 2000 chars) | [optional] 
**tags** | **List<String>** | Feedback tags (max 10) | [optional] [default to const []]
**wouldRecommend** | **bool** | Whether the user would recommend this specialist | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


