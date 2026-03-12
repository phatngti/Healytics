# admin_openapi.model.CreateMassageTherapistDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**firstName** | **String** | First name | 
**lastName** | **String** | Last name | 
**email** | **String** | Email address | 
**phone** | **String** | Phone number | [optional] 
**dateOfBirth** | **String** | Date of birth | [optional] 
**gender** | **String** | Gender | [optional] 
**emergencyContactName** | **String** | Emergency contact name | [optional] 
**emergencyContactPhone** | **String** | Emergency contact phone | [optional] 
**employeeId** | **String** | Unique employee identifier code | 
**employmentType** | **String** | Employment type | [optional] 
**startDate** | **String** | Start date | [optional] 
**schedule** | [**List<WorkScheduleEntryDto>**](WorkScheduleEntryDto.md) | Weekly work schedule | [optional] [default to const []]
**avatar** | **String** | Avatar URL | [optional] 
**idCardUrl** | **String** | ID card URL | [optional] 
**status** | **String** | Employee status | [optional] 
**branch** | **String** | Branch ID or name | [optional] 
**password** | **String** | Account password | [optional] 
**description** | **String** | Bio / description | [optional] 
**jobTitle** | **String** | Job title | [optional] 
**therapistLevel** | **String** | Therapist level | [optional] 
**strengthLevel** | **String** | Strength level | [optional] 
**commissionRate** | **num** | Commission rate percentage | [optional] 
**healthCheckDate** | **String** | Last health check date | [optional] 
**skills** | **List<String>** | Skills | [optional] [default to const []]
**licenseUrl** | **String** | License URL | [optional] 
**partnerId** | **String** | Partner ID (auto-injected) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


