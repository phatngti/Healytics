# user_openapi.model.UpdateEmployeeDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**employeeCode** | **String** |  | [optional] 
**fullName** | **String** |  | [optional] 
**email** | **String** |  | [optional] 
**role** | [**EmployeeRole**](EmployeeRole.md) |  | [optional] 
**status** | [**EmployeeStatus**](EmployeeStatus.md) |  | [optional] 
**firstName** | **String** |  | [optional] 
**lastName** | **String** |  | [optional] 
**phone** | **String** |  | [optional] 
**avatarUrl** | **String** |  | [optional] 
**dob** | **String** |  | [optional] 
**gender** | **String** |  | [optional] 
**partnerId** | **String** |  | [optional] 
**jobTitle** | **String** |  | [optional] 
**startDate** | **String** |  | [optional] 
**employmentType** | **String** |  | [optional] 
**emergencyContactName** | **String** |  | [optional] 
**emergencyContactPhone** | **String** |  | [optional] 
**description** | **String** |  | [optional] 
**verificationDocuments** | [**List<VerificationDocumentEntryDto>**](VerificationDocumentEntryDto.md) |  | [optional] [default to const []]
**schedule** | [**List<WorkScheduleEntryDto>**](WorkScheduleEntryDto.md) |  | [optional] [default to const []]
**workHistory** | [**List<WorkHistoryEntryDto>**](WorkHistoryEntryDto.md) |  | [optional] [default to const []]
**doctorProfile** | [**CreateDoctorProfileDto**](CreateDoctorProfileDto.md) |  | [optional] 
**therapistProfile** | [**CreateTherapistProfileDto**](CreateTherapistProfileDto.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


