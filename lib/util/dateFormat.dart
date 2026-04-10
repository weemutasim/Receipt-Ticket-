import 'package:intl/intl.dart';

String dateformat({required DateTime date, required String type}) {
  switch (type) {
    case "db":
      return DateFormat('yyyy-MM-dd').format(date);
    case "dn":
      return DateFormat('dd-MM-yyyy').format(date);
    case "dsn":
      return DateFormat('dd/MM/yyyy').format(date);
    case 'dmy':
      return DateFormat('ddMMyy').format(date); 
    case 'dy':
      return DateFormat("dd MMM yy").format(date);
    case 'dyy':
      return DateFormat("dd MMM yyyy").format(date);
    case 'df':
      return DateFormat("dd MMMM yyyy").format(date);
    case 'cd':
      return DateFormat("dd/MM/yy HH:mm:ss").format(date);
    default:
      return date.toString();
  }
}

String formatThaiDate(DateTime date) {
  final buddhistYear = date.year + 543;
  final thaiMonths = [
    '', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
  ];

  final day = DateFormat('dd').format(date);
  final month = thaiMonths[date.month];
  return '$day $month $buddhistYear';
}