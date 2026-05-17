# admin_openapi.model.EmployeeResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique employee identifier | 
**employeeCode** | **String** | Employee code | 
**firstName** | **String** | First name | [optional] 
**lastName** | **String** | Last name | [optional] 
**fullName** | **String** | Full name | 
**email** | **String** | Email address | 
**phone** | **String** | Phone number | [optional] 
**avatarUrl** | **String** | Avatar URL | [optional] 
**jobTitle** | **String** | Job title | [optional] 
**startDate** | [**DateTime**](DateTime.md) | Start date | [optional] 
**employmentType** | **String** | Employment type | [optional] 
**description** | **String** | Description/bio | [optional] 
**emergencyContactName** | **String** | Emergency contact name | [optional] 
**emergencyContactPhone** | **String** | Emergency contact phone | [optional] 
**verificationDocuments** | [**List<VerificationDocumentEntryDto>**](VerificationDocumentEntryDto.md) | Verification documents | [optional] [default to const []]
**schedule** | [**List<WorkScheduleEntryDto>**](WorkScheduleEntryDto.md) | Work schedule | [optional] [default to const []]
**workHistory** | [**List<WorkHistoryEntryDto>**](WorkHistoryEntryDto.md) | Work history | [optional] [default to const []]
**dob** | [**DateTime**](DateTime.md) | Date of birth | [optional] 
**gender** | [**Gender**](Gender.md) |  | [optional] 
**role** | [**EmployeeRole**](EmployeeRole.md) |  | 
**status** | [**EmployeeStatus**](EmployeeStatus.md) |  | 
**rating** | **num** | Rating (0-5) | 
**reviewCount** | **num** | Number of reviews | 
**partnerId** | **String** | Partner ID the employee belongs to | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**doctorProfile** | [**DoctorProfileResponseDto**](DoctorProfileResponseDto.md) | Doctor profile | [optional] 
**therapistProfile** | [**TherapistProfileResponseDto**](TherapistProfileResponseDto.md) | Therapist profile | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


