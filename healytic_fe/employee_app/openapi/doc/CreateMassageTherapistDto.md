# employee_openapi.model.CreateMassageTherapistDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**firstName** | **String** | First name | 
**lastName** | **String** | Last name | 
**email** | **String** | Email address | 
**password** | **String** | Initial employee account password | 
**phone** | **String** | Phone number | [optional] 
**dateOfBirth** | **String** | Date of birth | [optional] 
**gender** | **String** | Gender | [optional] 
**emergencyContactName** | **String** | Emergency contact name | 
**emergencyContactPhone** | **String** | Emergency contact phone | 
**employeeId** | **String** | Unique employee identifier code | 
**employmentType** | **String** | Employment type | [optional] 
**startDate** | **String** | Start date | 
**schedule** | [**List<WorkScheduleEntryDto>**](WorkScheduleEntryDto.md) | Weekly work schedule | [default to const []]
**workHistory** | [**List<WorkHistoryEntryDto>**](WorkHistoryEntryDto.md) | Work history entries | [optional] [default to const []]
**avatar** | **String** | Avatar URL | [optional] 
**verificationDocuments** | [**List<VerificationDocumentEntryDto>**](VerificationDocumentEntryDto.md) | Verification documents (ID card, licenses, etc.) | [optional] [default to const []]
**status** | **String** | Employee status | [optional] 
**description** | **String** | Bio / description | 
**jobTitle** | **String** | Job title | [optional] 
**therapistLevel** | **String** | Therapist level | [optional] 
**strengthLevel** | **String** | Strength level | [optional] 
**commissionRate** | **num** | Commission rate percentage | [optional] 
**healthCheckDate** | **String** | Last health check date | [optional] 
**skills** | **List<String>** | Skills | [optional] [default to const []]
**partnerId** | **String** | Partner ID (auto-injected) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


