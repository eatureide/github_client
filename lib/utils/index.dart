import 'dart:developer';
import 'dart:convert';

void console(dynamic data) {
  try {
    if (data is Map || data is List) {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String prettyData = encoder.convert(data);
      log(prettyData);
    } else {
      log(data.toString());
    }
  } catch (e) {
    log('Error logging response body: $e');
  }
}
