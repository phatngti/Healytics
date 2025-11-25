String errorMessageCode(int code) {
  switch (code) {
    case 200:
      return 'OK, the request was successful';
    case 201:
      return 'Created, the resource was created successfully';
    case 202:
      return 'Accepted, the request was accepted for processing';
    case 204:
      return 'No Content, the request was successful but there is no content to return';
    case 206:
      return 'Partial Content, the request was successful but only a partial content was returned';
    case 207:
      return 'Multi-Status, the request was successful but there are multiple statuses to return';
    case 208:
      return 'Already Reported, the request was successful but the resource has already been reported';
    case 226:
      return 'IM Used, the request was successful but the resource is being used by another request';
    case 300:
      return 'Multiple Choices, the request was successful but there are multiple choices to return';
    case 301:
      return 'Moved Permanently, the resource has been permanently moved to a new location';
    case 302:
      return 'Found, the resource has been temporarily moved to a new location';
    case 303:
      return 'See Other, the resource has been moved to a new location';
    case 304:
      return 'Not Modified, the resource has not been modified since the last request';
    case 305:
      return 'Use Proxy, the resource has been moved to a new location';
    case 306:
      return 'Switch Proxy, the resource has been moved to a new location';
    case 307:
      return 'Temporary Redirect, the resource has been moved to a new location';
    case 308:
      return 'Permanent Redirect, the resource has been moved to a new location';
    case 401:
      return 'Unauthorized, you are not authorized to access this resource';
    case 400:
      return 'Bad Request, please check your request';
    case 403:
      return 'Forbidden, you are not allowed to access this resource';
    case 404:
      return 'Not Found, the resource you are looking for is not found';
    case 500:
      return 'Internal Server Error, please try again later';
    case 502:
      return 'Bad Gateway, please try again later';
    case 503:
      return 'Service Unavailable, please try again later';
    case 504:
      return 'Gateway Timeout, please try again later';
    case 505:
      return 'HTTP Version Not Supported, please try again later';
    case 506:
      return 'Variant Also Negotiates, please try again later';
    case 507:
      return 'Insufficient Storage, please try again later';
    case 508:
      return 'Loop Detected, please try again later';
    case 509:
      return 'Bandwidth Limit Exceeded, please try again later';
    case 510:
      return 'Not Extended, please try again later';
    case 511:
      return 'Network Authentication Required, please try again later';
    case 512:
      return 'Internal Server Error, please try again later';
    case 513:
      return 'Internal Server Error, please try again later';
    case 514:
      return 'Internal Server Error, please try again later';
    case 515:
      return 'Internal Server Error, please try again later';
    case 516:
      return 'Internal Server Error, please try again later';
    case 517:
      return 'Internal Server Error, please try again later';
    case 518:
      return 'Internal Server Error, please try again later';
    case 519:
      return 'Internal Server Error, please try again later';
    case 520:
      return 'Internal Server Error, please try again later';
  }
  return 'An unknown error occurred';
}
