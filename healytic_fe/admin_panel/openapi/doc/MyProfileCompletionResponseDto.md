# admin_openapi.model.MyProfileCompletionResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**clinicIdentity** | [**PartnerProfileCompletionIdentityDto**](PartnerProfileCompletionIdentityDto.md) |  |
**coverImageUrl** | [**Object**](.md) |  | [optional]
**logoImageUrl** | [**Object**](.md) |  | [optional]
**description** | [**Object**](.md) |  | [optional]
**gallery** | **List<String>** |  | [default to const []]
**certifications** | [**List<PartnerProfileCompletionCertificationDto>**](PartnerProfileCompletionCertificationDto.md) |  | [default to const []]
**checklist** | [**List<CompletionChecklistItemDto>**](CompletionChecklistItemDto.md) |  | [default to const []]
**completionPercent** | **num** |  |
**isCompleted** | **bool** | Always true when returned from a successful profile-completion update, because the request DTO enforces all required checklist constraints. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


