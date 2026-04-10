import 'package:number_to_thai_words/number_to_thai_words.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import '../model/mdItemList.dart';
import '../model/mdReceipt.dart';
import '../util/dateformat.dart';
import '../util/numberFormat.dart';

class Invoice {
  pw.Font? pgvim;
  pw.Font? tranJan;
  pw.Font? tranJanPro;

  Future<Uint8List> generateInvoice({required Detail data, required List<ItemListModel> itemList}) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    const pageFormat1 = PdfPageFormat(29.7 * PdfPageFormat.cm, 21.0 * PdfPageFormat.cm, marginAll: 0); //29.7, 21
    // const pageFormat = PdfPageFormat(20.5 * PdfPageFormat.cm, 14 * PdfPageFormat.cm, marginAll: 0);

    pgvim = pw.Font.ttf(await rootBundle.load("assets/fonts/pgvim.ttf"));
    tranJan = pw.Font.ttf(await rootBundle.load("assets/fonts/trajanpro-regular.ttf"));
    tranJanPro = pw.Font.ttf(await rootBundle.load("assets/fonts/trajanpro-bold.ttf"));

    // final imageBg = await imageFromAssetBundle('assets/images/in.jpg');
    final bank = await imageFromAssetBundle('assets/images/bank.jpg');
    final credit = await imageFromAssetBundle('assets/images/credit.jpg');
    final cash = await imageFromAssetBundle('assets/images/cash.jpg');

    double amount = itemList.fold(0, (sum, item) => sum + (item.total ?? 0));
    double vat = itemList.fold(0, (sum, item) => sum + (item.vat ?? 0));
    double beforeVat = itemList.fold(0, (sum, item) => sum + (item.beforevat ?? 0));

    PdfColor color = PdfColors.black;
    
    pdf.addPage(
      pw.MultiPage(
        // pageFormat: pageFormat,
        pageFormat: pageFormat1,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) {
          return genBody(bank, credit, cash, color, data, itemList, amount, vat, beforeVat);
        },
      )
    );

    return pdf.save();
  }

  List<pw.Widget> genBody(pw.ImageProvider bank,  pw.ImageProvider credit,  pw.ImageProvider cash, PdfColor color, Detail data, List<ItemListModel> itemList, double amount, double vat, double beforeVat){
    String thaiWords = NumberToThaiWords.convert(amount);

    return [
      pw.Stack(
        children: [
          pw.Container(
            width: 29.7 * PdfPageFormat.cm,
            height: 21.0 * PdfPageFormat.cm
          ),
          pw.Positioned(
            top: 156, // 156 bgColors 141
            left: 119.5,
            child: pw.Text(
              data.agentname ?? '',
              style: pw.TextStyle(fontSize: 13.5, color: color, font: pgvim),
            ), 
          ),
          pw.Positioned(
            top: 154, //154 bgColors 139
            right: 42,
            child: pw.Text(
              data.trrunno ?? '',
              style: pw.TextStyle(fontSize: 16, color: color, font: tranJanPro),
            ), 
          ),
          pw.Positioned(
            top: 191, //191 bgColors 176
            left: 119.5,
            child: pw.Container(
              width: 550,
              child: pw.Text(
                data.address ?? '',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: pgvim),
              ),
            ) 
          ),
          pw.Positioned(
            top: 191, //bgColors 176
            right: 42,
            child: pw.Text(
              dateformat(date: DateTime.parse(data.docdate!), type: 'dn'),
              style: pw.TextStyle(fontSize: 15, color: color, font: tranJanPro),
            ), 
          ),
          pw.Positioned(
            bottom: 30, //bgColors 176
            left: 70,
            child: pw.Text(
              'issue: ${dateformat(date: DateTime.now(), type: 'cd')}',
              style: pw.TextStyle(fontSize: 10, color: color, font: pgvim),
            ), 
          ),

          //---------------------------------------- รายการ ---------------------------------------- 
          pw.Positioned(
            top: 257,
            left: 73,
            child: pw.Column(
              children: List.generate(itemList.length, (index) {
                final item = itemList[index];

                // double vats = (item.total ?? 0) * 7 / 107;
                // double grandTotal = (item.total ?? 0) - vats;

                return pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 42,
                      child: pw.Text(
                        '${index + 1}',
                        style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
                      ),
                    ), 
                    pw.SizedBox(
                      width: 266,
                      child: pw.Text(
                        item.description ?? '',
                        style: pw.TextStyle(fontSize: 13, color: color, font: pgvim),
                      ),
                    ),
                    pw.Container(
                      width: 28,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        '${item.qty ?? ''}',
                        style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
                      ),
                    ),
                    pw.Container(
                      width: 80,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        formatterDec.format(item.unit ?? 0),
                        style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
                      ),
                    ),
                    pw.Container(
                      width: 99,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        formatterDec.format(item.beforevat ?? 0),
                        style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
                      ),
                    ),
                    pw.Container(
                      width: 103,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        formatterDec.format(item.vat ?? 0),
                        style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
                      ),
                    ),
                    pw.Container(
                      width: 105,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        formatterDec.format(item.total ?? 0),
                        style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
                      ),
                    ),
                  ]
                );
              })
            )
          ),
          //---------------------------------------- รายการ ---------------------------------------- 

          pw.Positioned(
            top: 362, //362 bgColors 355
            left: 196,
            child: pw.Text(
              thaiWords,
              style: pw.TextStyle(fontSize: 13, color: color, font: pgvim),
            ), 
          ),
          pw.Positioned(
            top: 362,
            right: 253,
            child: pw.Text(
              formatterDec.format(beforeVat),
              style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
            ), 
          ),
          pw.Positioned(
            top: 362,
            right: 150,
            child: pw.Text(
              formatterDec.format(vat),
              style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
            ), 
          ),
          pw.Positioned(
            top: 362,
            right: 45,
            child: pw.Text(
              formatterDec.format(amount),
              style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
            ), 
          ),
          if(data.accode == '113') ...[
            pw.Positioned(
              top: 412, //412 bgColors 406
              left: 460,
              child: pw.Text(
                'X ',
                style: pw.TextStyle(fontSize: 13, color: color, font: tranJanPro),
              ), 
            ),
            pw.Positioned( //amt
              top: 412,
              right: 90,
              child: pw.Text(
                '5,000.00 ',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
              ), 
            ),
            pw.Positioned(
              top: 434.5, // 427 bgColors 434.5
              left: 180,
              child: pw.Text(
                data.acReportName ?? '',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: pgvim),
              ), 
            ),
            pw.Positioned(
              top: 434.5,
              left: 420,
              child: pw.Text(
                data.bankAccount ?? '',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
              ), 
            ),
            pw.Positioned(
              top: 434.5,
              right: 100,
              child: pw.Text(
                data.referno ?? '',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
              ), 
            ),
          ],
          if(data.accode == '114') ...[
            pw.Positioned(
              top: 400, //412 bgColors 406
              left: 460,
              child: pw.Text(
                'X ',
                style: pw.TextStyle(fontSize: 13, color: color, font: tranJanPro),
              ), 
            ),
            pw.Positioned( //amt
              top: 400, //412 bgColors 406
              right: 90,
              child: pw.Text(
                '5,000.00',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
              ), 
            ),
          ],
          if(data.accode == '111') ...[
            pw.Positioned(
              top: 400, //412 bgColors 406
              left: 160,
              child: pw.Text(
                'X ',
                style: pw.TextStyle(fontSize: 13, color: color, font: tranJanPro),
              ), 
            ),
            pw.Positioned( //amt
              top: 400, //412 bgColors 406
              left: 320,
              child: pw.Text(
                '5,000.00',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
              ), 
            ),
          ],
          if(data.accode == '112') ...[
            pw.Positioned(
              top: 412, //412 bgColors 406
              left: 160,
              child: pw.Text(
                'X ',
                style: pw.TextStyle(fontSize: 13, color: color, font: tranJanPro),
              ), 
            ),
            pw.Positioned( //amt
              top: 412, //412 bgColors 406
              left: 320,
              child: pw.Text(
                '5,000.00',
                style: pw.TextStyle(fontSize: 13.5, color: color, font: tranJanPro),
              ), 
            ),
          ],
        ],
      )
    ];
  }
}