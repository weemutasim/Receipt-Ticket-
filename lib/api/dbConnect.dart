import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/mdReceiptTicket.dart';

class DbConnect {
  String api = 'http://172.2.100.14/clientele_cm/receiptticket_cm.php';

  Future<List<TkReceiptModel>?> getTkReceipt() async {
    FormData formData = FormData.fromMap({
      "function": "list_receipttk",
      // "startdate": "2026-03-01",
      // "enddate": "2026-03-31",
      // "rsvn": "xb"
    });
    try {
      Response response = await Dio().post(api, data: formData);
      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.data);
        final data = TkReceiptModel.fromJsonList(rawData);
        // print('listqueque โหลดข้อมูลสำเร็จ');
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }

  Future<dynamic> insertReceipt({required dynamic data}) async {
    FormData formData = FormData.fromMap({
      "function": "postreceive",
      "data": jsonEncode(data)
    });
    try {
      await Dio().post(api, data: formData);
      /* if (response.statusCode == 200) {
        var rawData = jsonDecode(response.data);
        final data = TkReceiptModel.fromJsonList(rawData);
        // print('listqueque โหลดข้อมูลสำเร็จ');
        return data;
      } else {
        throw Exception('Failed to load data');
      } */
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }
}