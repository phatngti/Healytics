# user_openapi.model.PartnerTransactionRecordDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**createdAt** | **String** |  |
**type** | [**PartnerTransactionType**](PartnerTransactionType.md) |  |
**sourceType** | [**PartnerCommerceSourceType**](PartnerCommerceSourceType.md) |  |
**reference** | **String** |  |
**customerName** | **String** |  |
**grossAmount** | **num** |  |
**feeAmount** | **num** |  |
**netAmount** | **num** |  |
**currency** | **String** |  |
**status** | [**PartnerTransactionStatus**](PartnerTransactionStatus.md) |  |
**settlementStatus** | [**PartnerSettlementStatus**](PartnerSettlementStatus.md) |  |
**payoutStatus** | [**PartnerPayoutStatus**](PartnerPayoutStatus.md) |  |
**paymentMethod** | **String** |  |
**sourceTitle** | **String** |  |
**sourceSubtitle** | **String** |  |
**timeline** | [**List<PartnerTransactionTimelineEventDto>**](PartnerTransactionTimelineEventDto.md) |  | [default to const []]
**flaggedForReview** | **bool** |  |
**notes** | **String** |  | [optional]
**payoutId** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


