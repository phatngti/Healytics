# employee_openapi.model.AdminPartnerStatsResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**pendingReview** | **num** | Partners awaiting admin review | 
**highPriority** | **num** | Review-queue partners with HIGH or URGENT priority | 
**activeToday** | **num** | Approved providers (active today v1) | 
**avgWaitSeconds** | **num** | Average wait time in seconds | 
**avgWaitTime** | **String** | Formatted average wait time | 
**totalProviders** | **num** | Total providers across all statuses | 
**requiredResubmit** | **num** | Partners in REQUIRED_RESUBMIT status | 
**approved** | **num** | Partners with APPROVED status | 
**rejected** | **num** | Partners with REJECTED status | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


