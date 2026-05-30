# admin_openapi.model.AdminFinancePayoutDetailDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**record** | [**AdminFinancePayoutRecordDto**](AdminFinancePayoutRecordDto.md) |  |
**includedTransactions** | [**List<AdminFinanceTransactionRecordDto>**](AdminFinanceTransactionRecordDto.md) |  | [default to const []]
**attempts** | [**List<AdminFinancePayoutAttemptDto>**](AdminFinancePayoutAttemptDto.md) |  | [default to const []]
**maskedDestination** | **String** |  |
**auditTrail** | [**List<AdminFinanceAuditEventDto>**](AdminFinanceAuditEventDto.md) |  | [default to const []]
**notes** | [**List<AdminFinanceNoteDto>**](AdminFinanceNoteDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


