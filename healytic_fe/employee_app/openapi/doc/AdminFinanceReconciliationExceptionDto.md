# employee_openapi.model.AdminFinanceReconciliationExceptionDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**detectedAt** | **String** |  | 
**provider** | [**AdminFinanceProvider**](AdminFinanceProvider.md) |  | 
**providerEventId** | **String** |  | 
**relatedTransactionId** | **String** |  | [optional] 
**expectedAmount** | **num** |  | 
**providerAmount** | **num** |  | 
**difference** | **num** |  | 
**currency** | **String** |  | 
**type** | [**AdminFinanceReconciliationType**](AdminFinanceReconciliationType.md) |  | 
**status** | [**AdminFinanceReconciliationStatus**](AdminFinanceReconciliationStatus.md) |  | 
**owner** | **String** |  | 
**summary** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


