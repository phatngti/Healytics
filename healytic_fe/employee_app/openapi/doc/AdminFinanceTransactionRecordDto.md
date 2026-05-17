# employee_openapi.model.AdminFinanceTransactionRecordDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**createdAt** | **String** |  | 
**reference** | **String** |  | 
**partnerName** | **String** |  | 
**customerName** | **String** |  | 
**sourceType** | [**PartnerCommerceSourceType**](PartnerCommerceSourceType.md) |  | 
**type** | [**PartnerTransactionType**](PartnerTransactionType.md) |  | 
**grossAmount** | **num** |  | 
**feeAmount** | **num** |  | 
**netAmount** | **num** |  | 
**currency** | **String** |  | 
**transactionStatus** | [**PartnerTransactionStatus**](PartnerTransactionStatus.md) |  | 
**settlementStatus** | [**PartnerSettlementStatus**](PartnerSettlementStatus.md) |  | 
**payoutStatus** | [**PartnerPayoutStatus**](PartnerPayoutStatus.md) |  | 
**provider** | [**AdminFinanceProvider**](AdminFinanceProvider.md) |  | 
**isFlagged** | **bool** |  | 
**notesCount** | **num** |  | 
**payoutId** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


