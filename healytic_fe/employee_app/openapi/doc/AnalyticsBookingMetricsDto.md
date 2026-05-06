# employee_openapi.model.AnalyticsBookingMetricsDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**totalBookings** | **num** |  | 
**delayedBookings** | **num** | Bookings exceeding delay threshold | 
**delayThresholdMinutes** | **num** | Delay threshold in minutes | 
**pendingBookings** | **num** | PENDING_PAYMENT + CONFIRMED bookings | 
**completedBookings** | **num** |  | 
**statusBreakdown** | [**List<BookingStatusBreakdownDto>**](BookingStatusBreakdownDto.md) | Per-status counts | [default to const []]
**alerts** | [**List<AnalyticsAlertDto>**](AnalyticsAlertDto.md) | Operational alerts for booking health | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


