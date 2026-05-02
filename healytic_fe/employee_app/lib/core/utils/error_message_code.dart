String errorMessageCode(int code) {
  switch (code) {
    case 400:
      return 'Bad Request, please check your request';
    case 401:
      return 'Unauthorized, you are not authorized';
    case 403:
      return 'Forbidden, access denied';
    case 404:
      return 'Not Found, resource not found';
    case 500:
      return 'Internal Server Error, try again later';
    case 502:
      return 'Bad Gateway, please try again later';
    case 503:
      return 'Service Unavailable, try again later';
  }
  return 'An unknown error occurred';
}
