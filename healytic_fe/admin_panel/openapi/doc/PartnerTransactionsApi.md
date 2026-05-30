# admin_openapi.api.PartnerTransactionsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerTransactionsControllerFlagForReview**](PartnerTransactionsApi.md#partnertransactionscontrollerflagforreview) | **PATCH** /partner/transactions/{transactionId}/review-flag | Flag or unflag transaction for review
[**partnerTransactionsControllerGetSummary**](PartnerTransactionsApi.md#partnertransactionscontrollergetsummary) | **GET** /partner/transactions/finance/summary | Get aggregated finance summary metrics
[**partnerTransactionsControllerGetTransactionDetail**](PartnerTransactionsApi.md#partnertransactionscontrollergettransactiondetail) | **GET** /partner/transactions/{transactionId} | Get transaction detail with payout and refund cases
[**partnerTransactionsControllerGetTransactions**](PartnerTransactionsApi.md#partnertransactionscontrollergettransactions) | **GET** /partner/transactions | List partner transactions with filters and pagination
[**partnerTransactionsControllerGetTrend**](PartnerTransactionsApi.md#partnertransactionscontrollergettrend) | **GET** /partner/transactions/finance/trend | Get finance trend data (daily buckets)
[**partnerTransactionsControllerMarkSettled**](PartnerTransactionsApi.md#partnertransactionscontrollermarksettled) | **PATCH** /partner/transactions/{transactionId}/settlement | Mark transaction settlement status


# **partnerTransactionsControllerFlagForReview**
> PartnerTransactionRecordDto partnerTransactionsControllerFlagForReview(transactionId, flagReviewDto)

Flag or unflag transaction for review

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerTransactionsApi();
final transactionId = transactionId_example; // String |
final flagReviewDto = FlagReviewDto(); // FlagReviewDto |

try {
    final result = api_instance.partnerTransactionsControllerFlagForReview(transactionId, flagReviewDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerTransactionsApi->partnerTransactionsControllerFlagForReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionId** | **String**|  |
 **flagReviewDto** | [**FlagReviewDto**](FlagReviewDto.md)|  |

### Return type

[**PartnerTransactionRecordDto**](PartnerTransactionRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTransactionsControllerGetSummary**
> PartnerFinanceSummaryDto partnerTransactionsControllerGetSummary(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency)

Get aggregated finance summary metrics

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerTransactionsApi();
final search = BK-240408; // String | Free-text search (max 120 chars)
final startDate = 2026-04-01; // String | Inclusive start date (ISO 8601)
final endDate = 2026-04-30; // String | Inclusive end date (ISO 8601)
final period = ; // PartnerFinancePeriod | Relative time window (ignored when both startDate and endDate are set)
final sourceType = ; // PartnerCommerceSourceType | Filter by commerce source
final transactionType = ; // PartnerTransactionType | Filter by transaction type
final transactionStatus = ; // PartnerTransactionStatus | Filter by transaction status
final settlementStatus = ; // PartnerSettlementStatus | Filter by settlement status
final payoutStatus = ; // PartnerPayoutStatus | Filter by payout status
final currency = VND; // String | ISO 4217 currency code

try {
    final result = api_instance.partnerTransactionsControllerGetSummary(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency);
    print(result);
} catch (e) {
    print('Exception when calling PartnerTransactionsApi->partnerTransactionsControllerGetSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**| Free-text search (max 120 chars) | [optional]
 **startDate** | **String**| Inclusive start date (ISO 8601) | [optional]
 **endDate** | **String**| Inclusive end date (ISO 8601) | [optional]
 **period** | [**PartnerFinancePeriod**](.md)| Relative time window (ignored when both startDate and endDate are set) | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)| Filter by commerce source | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)| Filter by transaction type | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)| Filter by transaction status | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)| Filter by settlement status | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)| Filter by payout status | [optional]
 **currency** | **String**| ISO 4217 currency code | [optional]

### Return type

[**PartnerFinanceSummaryDto**](PartnerFinanceSummaryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTransactionsControllerGetTransactionDetail**
> PartnerTransactionDetailDto partnerTransactionsControllerGetTransactionDetail(transactionId)

Get transaction detail with payout and refund cases

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerTransactionsApi();
final transactionId = transactionId_example; // String |

try {
    final result = api_instance.partnerTransactionsControllerGetTransactionDetail(transactionId);
    print(result);
} catch (e) {
    print('Exception when calling PartnerTransactionsApi->partnerTransactionsControllerGetTransactionDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionId** | **String**|  |

### Return type

[**PartnerTransactionDetailDto**](PartnerTransactionDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTransactionsControllerGetTransactions**
> partnerTransactionsControllerGetTransactions(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency, page, limit)

List partner transactions with filters and pagination

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerTransactionsApi();
final search = BK-240408; // String | Free-text search (max 120 chars)
final startDate = 2026-04-01; // String | Inclusive start date (ISO 8601)
final endDate = 2026-04-30; // String | Inclusive end date (ISO 8601)
final period = ; // PartnerFinancePeriod | Relative time window (ignored when both startDate and endDate are set)
final sourceType = ; // PartnerCommerceSourceType | Filter by commerce source
final transactionType = ; // PartnerTransactionType | Filter by transaction type
final transactionStatus = ; // PartnerTransactionStatus | Filter by transaction status
final settlementStatus = ; // PartnerSettlementStatus | Filter by settlement status
final payoutStatus = ; // PartnerPayoutStatus | Filter by payout status
final currency = VND; // String | ISO 4217 currency code
final page = 1; // num | Page number (1-indexed)
final limit = 10; // num | Items per page (1-100)

try {
    api_instance.partnerTransactionsControllerGetTransactions(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency, page, limit);
} catch (e) {
    print('Exception when calling PartnerTransactionsApi->partnerTransactionsControllerGetTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**| Free-text search (max 120 chars) | [optional]
 **startDate** | **String**| Inclusive start date (ISO 8601) | [optional]
 **endDate** | **String**| Inclusive end date (ISO 8601) | [optional]
 **period** | [**PartnerFinancePeriod**](.md)| Relative time window (ignored when both startDate and endDate are set) | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)| Filter by commerce source | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)| Filter by transaction type | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)| Filter by transaction status | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)| Filter by settlement status | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)| Filter by payout status | [optional]
 **currency** | **String**| ISO 4217 currency code | [optional]
 **page** | **num**| Page number (1-indexed) | [optional] [default to 1]
 **limit** | **num**| Items per page (1-100) | [optional] [default to 10]

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTransactionsControllerGetTrend**
> List<PartnerFinanceTrendPointDto> partnerTransactionsControllerGetTrend(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency)

Get finance trend data (daily buckets)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerTransactionsApi();
final search = BK-240408; // String | Free-text search (max 120 chars)
final startDate = 2026-04-01; // String | Inclusive start date (ISO 8601)
final endDate = 2026-04-30; // String | Inclusive end date (ISO 8601)
final period = ; // PartnerFinancePeriod | Relative time window (ignored when both startDate and endDate are set)
final sourceType = ; // PartnerCommerceSourceType | Filter by commerce source
final transactionType = ; // PartnerTransactionType | Filter by transaction type
final transactionStatus = ; // PartnerTransactionStatus | Filter by transaction status
final settlementStatus = ; // PartnerSettlementStatus | Filter by settlement status
final payoutStatus = ; // PartnerPayoutStatus | Filter by payout status
final currency = VND; // String | ISO 4217 currency code

try {
    final result = api_instance.partnerTransactionsControllerGetTrend(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency);
    print(result);
} catch (e) {
    print('Exception when calling PartnerTransactionsApi->partnerTransactionsControllerGetTrend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**| Free-text search (max 120 chars) | [optional]
 **startDate** | **String**| Inclusive start date (ISO 8601) | [optional]
 **endDate** | **String**| Inclusive end date (ISO 8601) | [optional]
 **period** | [**PartnerFinancePeriod**](.md)| Relative time window (ignored when both startDate and endDate are set) | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)| Filter by commerce source | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)| Filter by transaction type | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)| Filter by transaction status | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)| Filter by settlement status | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)| Filter by payout status | [optional]
 **currency** | **String**| ISO 4217 currency code | [optional]

### Return type

[**List<PartnerFinanceTrendPointDto>**](PartnerFinanceTrendPointDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTransactionsControllerMarkSettled**
> PartnerTransactionRecordDto partnerTransactionsControllerMarkSettled(transactionId, markSettlementDto)

Mark transaction settlement status

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerTransactionsApi();
final transactionId = transactionId_example; // String |
final markSettlementDto = MarkSettlementDto(); // MarkSettlementDto |

try {
    final result = api_instance.partnerTransactionsControllerMarkSettled(transactionId, markSettlementDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerTransactionsApi->partnerTransactionsControllerMarkSettled: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionId** | **String**|  |
 **markSettlementDto** | [**MarkSettlementDto**](MarkSettlementDto.md)|  |

### Return type

[**PartnerTransactionRecordDto**](PartnerTransactionRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

