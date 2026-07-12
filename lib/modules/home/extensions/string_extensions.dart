import 'package:intl/intl.dart';

/// String formatting helpers used across home module screens.
extension StringExtesions on String {
  /// Formats an ISO date-time string as `dd-MMM-yyyy hh:mm aa`.
  ///
  /// Returns the original string when parsing fails.
  String getFormattedDateTime() {
    var dateFormatter = DateFormat("dd-MMM-yyyy hh:mm aa");
    return DateTime.tryParse(this) != null
        ? dateFormatter.format(DateTime.parse(this))
        : this;
  }
}
