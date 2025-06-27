String getSafeErrorMessage(dynamic errorOrMessage) {
  // Handle direct message strings (e.g., from API)
  const safeMessages = {
    "Invalid credentials",
    "Account not found",
    "Token expired",
    "No data available",
    "Unauthorized",
    "Access denied",
  };

  if (errorOrMessage is String && safeMessages.contains(errorOrMessage)) {
    return errorOrMessage;
  }

  // Handle network-related exceptions
  final errorText = errorOrMessage.toString().toLowerCase();

  if (errorText.contains('socketexception') ||
      errorText.contains('failed host lookup') ||
      errorText.contains('connection failed') ||
      errorText.contains('network is unreachable') ||
      errorText.contains('timed out') ||
      errorText.contains('connection timeout')) {
    return "📡 No internet connection. Please check your network.";
  }

  return "Something went wrong. Please try again.";
}
