# employee_openapi.model.EmployeeResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique employee identifier | 
**employeeCode** | **String** | Employee code | 
**firstName** | [**Object**](.md) | First name | [optional] 
**lastName** | [**Object**](.md) | Last name | [optional] 
**fullName** | **String** | Full name | 
**email** | **String** | Email address | 
**phone** | [**Object**](.md) | Phone number | [optional] 
**avatarUrl** | [**Object**](.md) | Avatar URL | [optional] 
**jobTitle** | [**Object**](.md) | Job title | [optional] 
**startDate** | [**Object**](.md) | Start date | [optional] 
**employmentType** | [**Object**](.md) | Employment type | [optional] 
**description** | [**Object**](.md) | Description/bio | [optional] 
**emergencyContactName** | [**Object**](.md) | Emergency contact name | [optional] 
**emergencyContactPhone** | [**Object**](.md) | Emergency contact phone | [optional] 
**verificationDocuments** | [**List<VerificationDocumentEntryDto>**](VerificationDocumentEntryDto.md) | Verification documents | [optional] [default to const []]
**schedule** | [**List<WorkScheduleEntryDto>**](WorkScheduleEntryDto.md) | Work schedule | [optional] [default to const []]
**workHistory** | [**List<WorkHistoryEntryDto>**](WorkHistoryEntryDto.md) | Work history | [optional] [default to const []]
**dob** | [**Object**](.md) | Date of birth | [optional] 
**gender** | **String** | Gender | [optional] 
**role** | **String** | Employee role | 
**status** | **String** | Employee status | 
**rating** | **num** | Rating (0-5) | 
**reviewCount** | **num** | Number of reviews | 
**partnerId** | [**Object**](.md) | Partner ID the employee belongs to | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update timestamp | 
**doctorProfile** | [**DoctorProfileResponseDto**](DoctorProfileResponseDto.md) | Doctor profile | [optional] 
**therapistProfile** | [**TherapistProfileResponseDto**](TherapistProfileResponseDto.md) | Therapist profile | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


