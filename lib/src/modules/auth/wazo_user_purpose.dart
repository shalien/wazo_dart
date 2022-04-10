enum WazoUserPurpose {
  user,
  internal,
  externalApi;

  @override
  String toString() {
    switch (this) {
      case WazoUserPurpose.user:
        return 'user';
      case WazoUserPurpose.internal:
        return 'internal';
      case WazoUserPurpose.externalApi:
        return 'external_api';
    }
  }
}
