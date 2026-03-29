# admin_openapi.model.UpdateEmployeeDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**employeeCode** | **String** | Unique employee code | [optional] 
**firstName** | **String** | First name | [optional] 
**lastName** | **String** | Last name | [optional] 
**fullName** | **String** | Full name of the employee | [optional] 
**email** | **String** | Email address | [optional] 
**phone** | **String** | Phone number | [optional] 
**avatarUrl** | **String** | Avatar URL | [optional] 
**dob** | **String** | Date of birth | [optional] 
**gender** | **String** | Gender | [optional] 
**role** | **String** | Role of the employee | [optional] 
**status** | **String** | Status of the employee | [optional] 
**partnerId** | **String** | Partner ID the employee belongs to | [optional] 
**jobTitle** | **String** | Job title | [optional] 
**startDate** | **String** | Start date | [optional] 
**employmentType** | **String** | Employment type | [optional] 
**emergencyContactName** | **String** | Emergency contact name | [optional] 
**emergencyContactPhone** | **String** | Emergency contact phone | [optional] 
**verificationDocuments** | [**List<VerificationDocumentEntryDto>**](VerificationDocumentEntryDto.md) | Verification documents (ID card, licenses, etc.) | [optional] [default to const []]
**description** | **String** | Bio / description | [optional] 
**schedule** | [**List<WorkScheduleEntryDto>**](WorkScheduleEntryDto.md) | Weekly work schedule | [optional] [default to const []]
**workHistory** | [**List<WorkHistoryEntryDto>**](WorkHistoryEntryDto.md) | Work history entries | [optional] [default to const []]
**doctorProfile** | [**CreateDoctorProfileDto**](CreateDoctorProfileDto.md) | Doctor profile data if role is DOCTOR | [optional] 
**therapistProfile** | [**CreateTherapistProfileDto**](CreateTherapistProfileDto.md) | Therapist profile data if role is THERAPIST | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


