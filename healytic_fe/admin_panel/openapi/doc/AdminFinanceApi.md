# admin_openapi.api.AdminFinanceApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminFinanceControllerAddNote**](AdminFinanceApi.md#adminfinancecontrolleraddnote) | **POST** /admin/finance/notes | Add a note to a finance entity
[**adminFinanceControllerApproveRefundCase**](AdminFinanceApi.md#adminfinancecontrollerapproverefundcase) | **POST** /admin/finance/refund-cases/{id}/approve | Approve a refund or dispute case
[**adminFinanceControllerCreateExport**](AdminFinanceApi.md#adminfinancecontrollercreateexport) | **POST** /admin/finance/exports | Create a finance export job
[**adminFinanceControllerFlagTransaction**](AdminFinanceApi.md#adminfinancecontrollerflagtransaction) | **PATCH** /admin/finance/transactions/{id}/review-flag | Flag or unflag a transaction for finance review
[**adminFinanceControllerGetAlerts**](AdminFinanceApi.md#adminfinancecontrollergetalerts) | **GET** /admin/finance/alerts | Get derived operational finance alerts
[**adminFinanceControllerGetExports**](AdminFinanceApi.md#adminfinancecontrollergetexports) | **GET** /admin/finance/exports | List finance export jobs
[**adminFinanceControllerGetPartnerExposure**](AdminFinanceApi.md#adminfinancecontrollergetpartnerexposure) | **GET** /admin/finance/partner-exposure | Rank partner financial exposure
[**adminFinanceControllerGetPayoutDetail**](AdminFinanceApi.md#adminfinancecontrollergetpayoutdetail) | **GET** /admin/finance/payouts/{id} | Get payout detail
[**adminFinanceControllerGetPayouts**](AdminFinanceApi.md#adminfinancecontrollergetpayouts) | **GET** /admin/finance/payouts | List platform payouts
[**adminFinanceControllerGetReconciliation**](AdminFinanceApi.md#adminfinancecontrollergetreconciliation) | **GET** /admin/finance/reconciliation | List reconciliation exceptions
[**adminFinanceControllerGetReconciliationDetail**](AdminFinanceApi.md#adminfinancecontrollergetreconciliationdetail) | **GET** /admin/finance/reconciliation/{id} | Get reconciliation exception detail
[**adminFinanceControllerGetRefundCaseDetail**](AdminFinanceApi.md#adminfinancecontrollergetrefundcasedetail) | **GET** /admin/finance/refund-cases/{id} | Get refund or dispute case detail
[**adminFinanceControllerGetRefundCases**](AdminFinanceApi.md#adminfinancecontrollergetrefundcases) | **GET** /admin/finance/refund-cases | List platform refund and dispute cases
[**adminFinanceControllerGetSummary**](AdminFinanceApi.md#adminfinancecontrollergetsummary) | **GET** /admin/finance/summary | Get platform-wide admin finance summary metrics
[**adminFinanceControllerGetTransactionDetail**](AdminFinanceApi.md#adminfinancecontrollergettransactiondetail) | **GET** /admin/finance/transactions/{id} | Get platform ledger transaction detail
[**adminFinanceControllerGetTransactions**](AdminFinanceApi.md#adminfinancecontrollergettransactions) | **GET** /admin/finance/transactions | List platform ledger transactions
[**adminFinanceControllerGetTrend**](AdminFinanceApi.md#adminfinancecontrollergettrend) | **GET** /admin/finance/trend | Get platform-wide finance trend data
[**adminFinanceControllerHoldPayout**](AdminFinanceApi.md#adminfinancecontrollerholdpayout) | **POST** /admin/finance/payouts/{id}/hold | Place an admin hold on a payout
[**adminFinanceControllerMarkSettlement**](AdminFinanceApi.md#adminfinancecontrollermarksettlement) | **PATCH** /admin/finance/transactions/{id}/settlement | Mark transaction settlement status with an admin note
[**adminFinanceControllerRejectRefundCase**](AdminFinanceApi.md#adminfinancecontrollerrejectrefundcase) | **POST** /admin/finance/refund-cases/{id}/reject | Reject a refund or dispute case
[**adminFinanceControllerReleasePayoutHold**](AdminFinanceApi.md#adminfinancecontrollerreleasepayouthold) | **POST** /admin/finance/payouts/{id}/release-hold | Release an admin hold from a payout
[**adminFinanceControllerReopenReconciliation**](AdminFinanceApi.md#adminfinancecontrollerreopenreconciliation) | **POST** /admin/finance/reconciliation/{id}/reopen | Reopen a reconciliation exception
[**adminFinanceControllerResolveReconciliation**](AdminFinanceApi.md#adminfinancecontrollerresolvereconciliation) | **POST** /admin/finance/reconciliation/{id}/resolve | Resolve a reconciliation exception
[**adminFinanceControllerRetryPayout**](AdminFinanceApi.md#adminfinancecontrollerretrypayout) | **POST** /admin/finance/payouts/{id}/retry | Retry a failed or held payout


# **adminFinanceControllerAddNote**
> AdminFinanceNoteDto adminFinanceControllerAddNote(adminFinanceCreateNoteDto)

Add a note to a finance entity

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final adminFinanceCreateNoteDto = AdminFinanceCreateNoteDto(); // AdminFinanceCreateNoteDto |

try {
    final result = api_instance.adminFinanceControllerAddNote(adminFinanceCreateNoteDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerAddNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminFinanceCreateNoteDto** | [**AdminFinanceCreateNoteDto**](AdminFinanceCreateNoteDto.md)|  |

### Return type

[**AdminFinanceNoteDto**](AdminFinanceNoteDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerApproveRefundCase**
> AdminFinanceRefundCaseDetailDto adminFinanceControllerApproveRefundCase(id, adminFinanceNoteActionDto)

Approve a refund or dispute case

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceNoteActionDto = AdminFinanceNoteActionDto(); // AdminFinanceNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerApproveRefundCase(id, adminFinanceNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerApproveRefundCase: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceNoteActionDto** | [**AdminFinanceNoteActionDto**](AdminFinanceNoteActionDto.md)|  |

### Return type

[**AdminFinanceRefundCaseDetailDto**](AdminFinanceRefundCaseDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerCreateExport**
> AdminFinanceExportJobDto adminFinanceControllerCreateExport(adminFinanceCreateExportDto)

Create a finance export job

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final adminFinanceCreateExportDto = AdminFinanceCreateExportDto(); // AdminFinanceCreateExportDto |

try {
    final result = api_instance.adminFinanceControllerCreateExport(adminFinanceCreateExportDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerCreateExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminFinanceCreateExportDto** | [**AdminFinanceCreateExportDto**](AdminFinanceCreateExportDto.md)|  |

### Return type

[**AdminFinanceExportJobDto**](AdminFinanceExportJobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerFlagTransaction**
> AdminFinanceTransactionRecordDto adminFinanceControllerFlagTransaction(id, adminFinanceReviewFlagActionDto)

Flag or unflag a transaction for finance review

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceReviewFlagActionDto = AdminFinanceReviewFlagActionDto(); // AdminFinanceReviewFlagActionDto |

try {
    final result = api_instance.adminFinanceControllerFlagTransaction(id, adminFinanceReviewFlagActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerFlagTransaction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceReviewFlagActionDto** | [**AdminFinanceReviewFlagActionDto**](AdminFinanceReviewFlagActionDto.md)|  |

### Return type

[**AdminFinanceTransactionRecordDto**](AdminFinanceTransactionRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetAlerts**
> List<AdminFinanceAlertDto> adminFinanceControllerGetAlerts(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

Get derived operational finance alerts

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetAlerts(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetAlerts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**List<AdminFinanceAlertDto>**](AdminFinanceAlertDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetExports**
> List<AdminFinanceExportJobDto> adminFinanceControllerGetExports()

List finance export jobs

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();

try {
    final result = api_instance.adminFinanceControllerGetExports();
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetExports: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminFinanceExportJobDto>**](AdminFinanceExportJobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetPartnerExposure**
> List<AdminFinancePartnerExposureDto> adminFinanceControllerGetPartnerExposure(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

Rank partner financial exposure

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetPartnerExposure(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetPartnerExposure: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**List<AdminFinancePartnerExposureDto>**](AdminFinancePartnerExposureDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetPayoutDetail**
> AdminFinancePayoutDetailDto adminFinanceControllerGetPayoutDetail(id)

Get payout detail

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |

try {
    final result = api_instance.adminFinanceControllerGetPayoutDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetPayoutDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**AdminFinancePayoutDetailDto**](AdminFinancePayoutDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetPayouts**
> AdminFinancePayoutPageDto adminFinanceControllerGetPayouts(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

List platform payouts

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetPayouts(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetPayouts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**AdminFinancePayoutPageDto**](AdminFinancePayoutPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetReconciliation**
> AdminFinanceReconciliationPageDto adminFinanceControllerGetReconciliation(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

List reconciliation exceptions

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetReconciliation(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetReconciliation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**AdminFinanceReconciliationPageDto**](AdminFinanceReconciliationPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetReconciliationDetail**
> AdminFinanceReconciliationDetailDto adminFinanceControllerGetReconciliationDetail(id)

Get reconciliation exception detail

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |

try {
    final result = api_instance.adminFinanceControllerGetReconciliationDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetReconciliationDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**AdminFinanceReconciliationDetailDto**](AdminFinanceReconciliationDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetRefundCaseDetail**
> AdminFinanceRefundCaseDetailDto adminFinanceControllerGetRefundCaseDetail(id)

Get refund or dispute case detail

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |

try {
    final result = api_instance.adminFinanceControllerGetRefundCaseDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetRefundCaseDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**AdminFinanceRefundCaseDetailDto**](AdminFinanceRefundCaseDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetRefundCases**
> AdminFinanceRefundCasePageDto adminFinanceControllerGetRefundCases(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

List platform refund and dispute cases

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetRefundCases(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetRefundCases: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**AdminFinanceRefundCasePageDto**](AdminFinanceRefundCasePageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetSummary**
> AdminFinanceOverviewDto adminFinanceControllerGetSummary(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

Get platform-wide admin finance summary metrics

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetSummary(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**AdminFinanceOverviewDto**](AdminFinanceOverviewDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetTransactionDetail**
> AdminFinanceTransactionDetailDto adminFinanceControllerGetTransactionDetail(id)

Get platform ledger transaction detail

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |

try {
    final result = api_instance.adminFinanceControllerGetTransactionDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetTransactionDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**AdminFinanceTransactionDetailDto**](AdminFinanceTransactionDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetTransactions**
> AdminFinanceTransactionPageDto adminFinanceControllerGetTransactions(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

List platform ledger transactions

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetTransactions(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**AdminFinanceTransactionPageDto**](AdminFinanceTransactionPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerGetTrend**
> List<AdminFinanceTrendPointDto> adminFinanceControllerGetTrend(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit)

Get platform-wide finance trend data

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final search = search_example; // String |
final period = ; // AdminFinancePeriod |
final startDate = 2013-10-20; // DateTime |
final endDate = 2013-10-20; // DateTime |
final partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final sourceType = ; // PartnerCommerceSourceType |
final transactionType = ; // PartnerTransactionType |
final transactionStatus = ; // PartnerTransactionStatus |
final settlementStatus = ; // PartnerSettlementStatus |
final payoutStatus = ; // PartnerPayoutStatus |
final refundCaseStatus = ; // PartnerRefundCaseStatus |
final refundCaseType = ; // PartnerRefundCaseType |
final reconciliationStatus = ; // AdminFinanceReconciliationStatus |
final provider = ; // AdminFinanceProvider |
final currency = VND; // String |
final minAmount = 8.14; // num |
final maxAmount = 8.14; // num |
final onlyFlagged = true; // bool |
final onlySlaBreached = true; // bool |
final page = 8.14; // num |
final limit = 8.14; // num |

try {
    final result = api_instance.adminFinanceControllerGetTrend(search, period, startDate, endDate, partnerId, customerId, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, refundCaseStatus, refundCaseType, reconciliationStatus, provider, currency, minAmount, maxAmount, onlyFlagged, onlySlaBreached, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerGetTrend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **period** | [**AdminFinancePeriod**](.md)|  | [optional]
 **startDate** | **DateTime**|  | [optional]
 **endDate** | **DateTime**|  | [optional]
 **partnerId** | **String**|  | [optional]
 **customerId** | **String**|  | [optional]
 **sourceType** | [**PartnerCommerceSourceType**](.md)|  | [optional]
 **transactionType** | [**PartnerTransactionType**](.md)|  | [optional]
 **transactionStatus** | [**PartnerTransactionStatus**](.md)|  | [optional]
 **settlementStatus** | [**PartnerSettlementStatus**](.md)|  | [optional]
 **payoutStatus** | [**PartnerPayoutStatus**](.md)|  | [optional]
 **refundCaseStatus** | [**PartnerRefundCaseStatus**](.md)|  | [optional]
 **refundCaseType** | [**PartnerRefundCaseType**](.md)|  | [optional]
 **reconciliationStatus** | [**AdminFinanceReconciliationStatus**](.md)|  | [optional]
 **provider** | [**AdminFinanceProvider**](.md)|  | [optional]
 **currency** | **String**|  | [optional]
 **minAmount** | **num**|  | [optional]
 **maxAmount** | **num**|  | [optional]
 **onlyFlagged** | **bool**|  | [optional]
 **onlySlaBreached** | **bool**|  | [optional]
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**List<AdminFinanceTrendPointDto>**](AdminFinanceTrendPointDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerHoldPayout**
> AdminFinancePayoutDetailDto adminFinanceControllerHoldPayout(id, adminFinanceRequiredNoteActionDto)

Place an admin hold on a payout

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceRequiredNoteActionDto = AdminFinanceRequiredNoteActionDto(); // AdminFinanceRequiredNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerHoldPayout(id, adminFinanceRequiredNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerHoldPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceRequiredNoteActionDto** | [**AdminFinanceRequiredNoteActionDto**](AdminFinanceRequiredNoteActionDto.md)|  |

### Return type

[**AdminFinancePayoutDetailDto**](AdminFinancePayoutDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerMarkSettlement**
> AdminFinanceTransactionRecordDto adminFinanceControllerMarkSettlement(id, adminFinanceSettlementActionDto)

Mark transaction settlement status with an admin note

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceSettlementActionDto = AdminFinanceSettlementActionDto(); // AdminFinanceSettlementActionDto |

try {
    final result = api_instance.adminFinanceControllerMarkSettlement(id, adminFinanceSettlementActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerMarkSettlement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceSettlementActionDto** | [**AdminFinanceSettlementActionDto**](AdminFinanceSettlementActionDto.md)|  |

### Return type

[**AdminFinanceTransactionRecordDto**](AdminFinanceTransactionRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerRejectRefundCase**
> AdminFinanceRefundCaseDetailDto adminFinanceControllerRejectRefundCase(id, adminFinanceRequiredNoteActionDto)

Reject a refund or dispute case

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceRequiredNoteActionDto = AdminFinanceRequiredNoteActionDto(); // AdminFinanceRequiredNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerRejectRefundCase(id, adminFinanceRequiredNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerRejectRefundCase: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceRequiredNoteActionDto** | [**AdminFinanceRequiredNoteActionDto**](AdminFinanceRequiredNoteActionDto.md)|  |

### Return type

[**AdminFinanceRefundCaseDetailDto**](AdminFinanceRefundCaseDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerReleasePayoutHold**
> AdminFinancePayoutDetailDto adminFinanceControllerReleasePayoutHold(id, adminFinanceNoteActionDto)

Release an admin hold from a payout

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceNoteActionDto = AdminFinanceNoteActionDto(); // AdminFinanceNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerReleasePayoutHold(id, adminFinanceNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerReleasePayoutHold: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceNoteActionDto** | [**AdminFinanceNoteActionDto**](AdminFinanceNoteActionDto.md)|  |

### Return type

[**AdminFinancePayoutDetailDto**](AdminFinancePayoutDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerReopenReconciliation**
> AdminFinanceReconciliationDetailDto adminFinanceControllerReopenReconciliation(id, adminFinanceNoteActionDto)

Reopen a reconciliation exception

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceNoteActionDto = AdminFinanceNoteActionDto(); // AdminFinanceNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerReopenReconciliation(id, adminFinanceNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerReopenReconciliation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceNoteActionDto** | [**AdminFinanceNoteActionDto**](AdminFinanceNoteActionDto.md)|  |

### Return type

[**AdminFinanceReconciliationDetailDto**](AdminFinanceReconciliationDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerResolveReconciliation**
> AdminFinanceReconciliationDetailDto adminFinanceControllerResolveReconciliation(id, adminFinanceRequiredNoteActionDto)

Resolve a reconciliation exception

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceRequiredNoteActionDto = AdminFinanceRequiredNoteActionDto(); // AdminFinanceRequiredNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerResolveReconciliation(id, adminFinanceRequiredNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerResolveReconciliation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceRequiredNoteActionDto** | [**AdminFinanceRequiredNoteActionDto**](AdminFinanceRequiredNoteActionDto.md)|  |

### Return type

[**AdminFinanceReconciliationDetailDto**](AdminFinanceReconciliationDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFinanceControllerRetryPayout**
> AdminFinancePayoutDetailDto adminFinanceControllerRetryPayout(id, adminFinanceNoteActionDto)

Retry a failed or held payout

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminFinanceApi();
final id = id_example; // String |
final adminFinanceNoteActionDto = AdminFinanceNoteActionDto(); // AdminFinanceNoteActionDto |

try {
    final result = api_instance.adminFinanceControllerRetryPayout(id, adminFinanceNoteActionDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminFinanceApi->adminFinanceControllerRetryPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **adminFinanceNoteActionDto** | [**AdminFinanceNoteActionDto**](AdminFinanceNoteActionDto.md)|  |

### Return type

[**AdminFinancePayoutDetailDto**](AdminFinancePayoutDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

