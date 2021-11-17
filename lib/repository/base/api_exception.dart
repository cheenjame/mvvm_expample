class ApiException {
  ApiException(this.errorCode, this.errorMessage);
  final int errorCode;
  final String errorMessage;
  @override
  String toString() {
    return 'ApiException{errorCode : $errorCode, errorMessage: $errorMessage}';
  }
}

class TwoTypes<F, S> {
  TwoTypes(this.first, this.second);
  final F first;
  final S second;
}
