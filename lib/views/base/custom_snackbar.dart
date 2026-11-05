import 'package:kmsmerino/utils/common_toast.dart';

/// Legacy helper redirected to centralized [CommonToast].
void showCustomSnackBar(String message, {bool isError = true}) {
  if (message.isNotEmpty) {
    if (isError) {
      CommonToast.error(message);
    } else {
      CommonToast.success(message);
    }
  }
}
