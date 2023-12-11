import 'package:intl/intl.dart';

const String baseUrl = "http://192.168.174.41:8000/api";

String formatWaktuKejadian(String inputDate) {
  DateFormat inputFormat = DateFormat('yyyy-MM-dd');
  DateFormat outputFormat = DateFormat('dd MMM yyyy');
  DateTime date = inputFormat.parse(inputDate);
  return outputFormat.format(date);
}

String formatCreatedAt(String apiDate) {
  DateTime date = DateTime.parse(apiDate).toLocal();
  DateFormat outputFormat = DateFormat('dd MMM yyyy HH:mm:ss');
  return outputFormat.format(date);
}
