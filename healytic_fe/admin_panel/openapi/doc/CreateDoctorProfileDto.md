# admin_openapi.model.CreateDoctorProfileDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** | Title of the doctor | [optional]
**medicalCredentials** | [**List<MedicalCredentialResponseDto>**](MedicalCredentialResponseDto.md) | Medical credentials (titles + licenses) | [optional] [default to const []]
**experienceYears** | **num** | Years of experience | [optional]
**consultationFee** | **num** | Consultation fee | [optional]
**specializations** | **List<String>** | Specializations | [optional] [default to const []]
**education** | **List<String>** | Education history | [optional] [default to const []]
**certifications** | **List<String>** | Certifications | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


