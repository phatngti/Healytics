# user_openapi.api.MapboxApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mapboxControllerDirections**](MapboxApi.md#mapboxcontrollerdirections) | **GET** /mapbox/directions | Get driving directions route geometry
[**mapboxControllerDistanceMatrix**](MapboxApi.md#mapboxcontrollerdistancematrix) | **GET** /mapbox/distance-matrix | Get travel distance and duration
[**mapboxControllerGeocode**](MapboxApi.md#mapboxcontrollergeocode) | **GET** /mapbox/geocode | Geocode an address to lat/lng
[**mapboxControllerGetClientKey**](MapboxApi.md#mapboxcontrollergetclientkey) | **GET** /mapbox/client-key | Get public access token for frontend/mobile SDKs
[**mapboxControllerReverseGeocode**](MapboxApi.md#mapboxcontrollerreversegeocode) | **GET** /mapbox/reverse-geocode | Reverse geocode lat/lng to address


# **mapboxControllerDirections**
> DirectionsResponseDto mapboxControllerDirections(origin, destination)

Get driving directions route geometry

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = MapboxApi();
final origin = 10.762622,106.660172; // String | Origin coordinate in lat,lng format
final destination = 10.823099,106.629662; // String | Destination coordinate in lat,lng format

try {
    final result = api_instance.mapboxControllerDirections(origin, destination);
    print(result);
} catch (e) {
    print('Exception when calling MapboxApi->mapboxControllerDirections: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **origin** | **String**| Origin coordinate in lat,lng format | 
 **destination** | **String**| Destination coordinate in lat,lng format | 

### Return type

[**DirectionsResponseDto**](DirectionsResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapboxControllerDistanceMatrix**
> DistanceMatrixResponseDto mapboxControllerDistanceMatrix(origins, destinations)

Get travel distance and duration

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = MapboxApi();
final origins = 10.762622,106.660172; // String | Origins — pipe-separated coordinates or addresses (e.g. \"10.762,106.660|10.823,106.629\")
final destinations = 10.823099,106.629662; // String | Destinations — pipe-separated coordinates or addresses (e.g. \"10.823,106.629|10.800,106.700\")

try {
    final result = api_instance.mapboxControllerDistanceMatrix(origins, destinations);
    print(result);
} catch (e) {
    print('Exception when calling MapboxApi->mapboxControllerDistanceMatrix: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **origins** | **String**| Origins — pipe-separated coordinates or addresses (e.g. \"10.762,106.660|10.823,106.629\") | 
 **destinations** | **String**| Destinations — pipe-separated coordinates or addresses (e.g. \"10.823,106.629|10.800,106.700\") | 

### Return type

[**DistanceMatrixResponseDto**](DistanceMatrixResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapboxControllerGeocode**
> GeocodeResponseDto mapboxControllerGeocode(address)

Geocode an address to lat/lng

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = MapboxApi();
final address = 227 Nguyen Van Cu, District 5, Ho Chi Minh City; // String | Address to geocode

try {
    final result = api_instance.mapboxControllerGeocode(address);
    print(result);
} catch (e) {
    print('Exception when calling MapboxApi->mapboxControllerGeocode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **address** | **String**| Address to geocode | 

### Return type

[**GeocodeResponseDto**](GeocodeResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapboxControllerGetClientKey**
> ClientKeyResponseDto mapboxControllerGetClientKey()

Get public access token for frontend/mobile SDKs

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = MapboxApi();

try {
    final result = api_instance.mapboxControllerGetClientKey();
    print(result);
} catch (e) {
    print('Exception when calling MapboxApi->mapboxControllerGetClientKey: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ClientKeyResponseDto**](ClientKeyResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapboxControllerReverseGeocode**
> GeocodeResponseDto mapboxControllerReverseGeocode(lat, lng)

Reverse geocode lat/lng to address

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = MapboxApi();
final lat = 10.762622; // num | Latitude
final lng = 106.660172; // num | Longitude

try {
    final result = api_instance.mapboxControllerReverseGeocode(lat, lng);
    print(result);
} catch (e) {
    print('Exception when calling MapboxApi->mapboxControllerReverseGeocode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lat** | **num**| Latitude | 
 **lng** | **num**| Longitude | 

### Return type

[**GeocodeResponseDto**](GeocodeResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

