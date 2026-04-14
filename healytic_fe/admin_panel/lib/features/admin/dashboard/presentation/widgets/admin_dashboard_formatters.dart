import 'package:intl/intl.dart';

String formatAdminCurrency(double amount) {
  final formatter = NumberFormat.compactCurrency(
    locale: 'vi_VN',
    symbol: 'VND ',
    decimalDigits: 1,
  );
  return formatter.format(amount);
}

String formatAdminCurrencyFull(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VND ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

String formatAdminPercent(double value) => '${value.toStringAsFixed(2)}%';

String formatAdminDate(DateTime date) => DateFormat('dd MMM').format(date);

String formatAdminDateTime(DateTime date) =>
    DateFormat('dd MMM yyyy, HH:mm').format(date);

String formatRelativeTime(DateTime date, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final diff = current.difference(date);
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  }
  return '${diff.inDays}d ago';
}
