import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipt_ticket/api/dbConnect.dart';
import 'package:receipt_ticket/model/mdReceipt.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import '../fonts/appColor.dart';
import '../model/mdReceiptTicket.dart';
import '../receipt/invoice.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCompanyCode = "";

  TextEditingController searchController = TextEditingController();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  List<TkReceiptModel> dataTkRecipt = []; //รายการโหลด
  List<TkReceiptModel> dataTkReciptFilter = [];
  TkReceiptModel? dataTkReciptOnly; //รายการโหลด 1 รายการ

  @override
  void initState() {
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _dBTkReceipt();

    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  Future<void> _dBTkReceipt() async {
    await DbConnect().getTkReceipt().then((onValue) {
      if(onValue != null) {
        setState(() {
          dataTkRecipt = onValue;
          dataTkReciptFilter = onValue;
        });
      }
    });
  }

  void search(String keyword) {
    final result = dataTkRecipt.where((item) {
      final rsvn = item.rsvn?.toLowerCase() ?? '';
      final voucher = item.voucher?.toLowerCase() ?? '';
      final input = keyword.toLowerCase();

      return rsvn.contains(input) || voucher.contains(input);
    }).toList();

    setState(() {
      dataTkReciptFilter = result;
    });
  }

  void _updateFormFields(TkReceiptModel data) {
    _codeController.text = data.agentcode ?? '';
    _nameController.text = data.customerName ?? '';
    _addressController.text = '${data.addressPp1}'; //${data.addressPp2} ${data.pppostCode}
  }

  void _printDirectly(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], "application/pdf");
    final url = html.Url.createObjectUrlFromBlob(blob);
    js.context.callMethod("autoPrint", [url]);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    String getType() {
      final hasTk = double.parse(dataTkReciptOnly?.tk ?? '0') > 0;
      final hasTr = double.parse(dataTkReciptOnly?.tr ?? '0') > 0;
    
      if (hasTk && hasTr) return 'TK+TR';
      if (hasTk) return 'TK';
      if (hasTr) return 'TR';
      return '';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Receipt Ticket', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text('v1.0.1', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
          ],
        ),
        backgroundColor: AppColors.pinkcm,
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
                color: Colors.grey.shade50,
              ),
              child: _buildCompanyList(),
            ),
          ),
          Expanded(
            flex: 5,
            child: _buildCompanyInfo(getType()),
          ),
        ],
      ),
    );
  }

  Padding _buildCompanyInfo(String getType) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('รายละเอียด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkPink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                onPressed: () async {
                  TkReceiptModel dataSave = TkReceiptModel();
                  dataSave.rsvn = dataTkReciptOnly?.rsvn;
                  dataSave.id = dataTkReciptOnly?.id;
                  dataSave.voucher = dataTkReciptOnly?.voucher;
                  dataSave.mintax = dataTkReciptOnly?.mintax;
                  dataSave.maxtax = dataTkReciptOnly?.maxtax;
                  dataSave.pax = dataTkReciptOnly?.pax;
                  dataSave.accode = dataTkReciptOnly?.accode;
                  dataSave.agentcode = dataTkReciptOnly?.agentcode;
                  dataSave.customerName = dataTkReciptOnly?.customerName;
                  dataSave.custaxidno = dataTkReciptOnly?.custaxidno;
                  dataSave.ppcName = dataTkReciptOnly?.ppcName;
                  dataSave.addressPp1 = dataTkReciptOnly?.addressPp1;
                  dataSave.addressPp2 = dataTkReciptOnly?.addressPp2;
                  dataSave.pppostCode = dataTkReciptOnly?.pppostCode;
                  dataSave.branchtax = dataTkReciptOnly?.branchtax;
                  dataSave.docno = dataTkReciptOnly?.docno;
                  dataSave.tk = dataTkReciptOnly?.tk;
                  dataSave.tr = dataTkReciptOnly?.tr;
                  dataSave.total = dataTkReciptOnly?.total;

                  // await DbConnect().insertReceipt(data: dataSave);
                  print('save: ${jsonEncode(dataSave)}');
                  _codeController.clear();
                  _nameController.clear();
                  _addressController.clear();
                  dataTkReciptOnly = null;
                  setState(() {
                    selectedCompanyCode = '';
                  });
                  // DbConnect().insertReceipt(data)
                  /* dataRecipt.add(
                    Detail(
                      acReportName: 'Credit',
                      accode: '114',
                      address: 'A Class Worldwide Co., Ltd.9988776655443 101 Classy Blvd, Chiang Mai',
                      agentname: '',
                      amount: '4100.00',
                      bankAccount: '0123456789',
                      docdate: '2025-11-30 00:00:00',
                      docno: '2025-11-30 00:00:00',
                      extcode: '02444',
                      issue: '2025-11-30 17:52:04',
                      recivetype: '0=1235',
                      referno: '29-11-25',
                      trdate: '2025-11-30 17:52:04',
                      trrunno: 'CP000012345'
                    )
                  ); 
                  Invoice().generateInvoice(data: , itemList: []).then((onValue) {
                    _printDirectly(onValue);
                  });*/
                },
                icon: const Icon(Icons.print_rounded, size: 20),
                label: const Text('Save /Print', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCompanyDetailsCard(),
          const SizedBox(height: 24),
          const Text('รายการโหลด /วัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                listHeader('RSVN', 2),
                listHeader('Voucher', 3),
                listHeader('Pax', 2),
                listHeader('Mintax', 3),
                listHeader('Maxtax', 3),
                listHeader('Status', 2),
              ],
            ),
          ),
          if (dataTkReciptOnly == null)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: Text("ไม่มีรายการโหลด", style: TextStyle(color: Colors.grey))),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  listBody(dataTkReciptOnly?.rsvn ?? '', 2, TextAlign.left),
                  listBody(dataTkReciptOnly?.voucher  ?? '', 3, TextAlign.left),
                  listBody(dataTkReciptOnly?.pax  ?? '', 2, TextAlign.left),
                  listBody(dataTkReciptOnly?.mintax ?? '', 3, TextAlign.left),
                  listBody(dataTkReciptOnly?.maxtax ?? '', 3, TextAlign.left),
                  listBody(getType, 2, TextAlign.left, isBold: true),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildCompanyList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Agent',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.darkPink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/reprint');
                      _codeController.clear();
                      _nameController.clear();
                      _addressController.clear();
                      dataTkReciptOnly = null;
                      setState(() {
                        selectedCompanyCode = '';
                      });
                    },
                    child: const Text('รายการ Reprint', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  search(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, color: Colors.grey.shade600),
                        onPressed: () {
                          searchController.clear();
                          search('');
                        },
                      )
                    : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: dataTkReciptFilter.isEmpty ? _buildEmptyState(Icons.manage_search_rounded, 'ไม่พบข้อมูลที่ค้นหา') : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: dataTkReciptFilter.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = dataTkReciptFilter[index];
              final isSelected = item.id == selectedCompanyCode;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.5) : Colors.transparent,
                    width: 1,
                  ),
                  boxShadow: [
                    if (!isSelected)
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  /* leading: CircleAvatar(
                    backgroundColor: isSelected  ? Theme.of(context).colorScheme.primary  : Colors.grey.shade100,
                    foregroundColor: isSelected ? Colors.white : Colors.grey.shade700,
                    child: Text(
                      company['name']!.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ), */
                  title: Text(
                    item.customerName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Text(
                          'rsvn: ${item.rsvn ?? ''}',
                          style: TextStyle(
                            color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.8) : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if(item.voucher != '') Text(
                          'voucher: ${item.voucher ?? ''}',
                          style: TextStyle(
                            color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.8) : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCompanyCode = item.id ?? '';
                      dataTkReciptOnly = item;
                      _updateFormFields(item);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompanyDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.domain,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Company Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildModernTextField('Code', _codeController, icon: Icons.tag),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: _buildModernTextField('Name', _nameController, icon: Icons.badge_outlined),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildModernTextField('Address', _addressController, maxLines: 1, icon: Icons.location_on_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField(String label, TextEditingController controller, {int maxLines = 1, IconData? icon}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.normal),
        floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
        prefixIcon: icon != null 
            ? Icon(icon, size: 20, color: Colors.grey.shade400) 
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), 
      ),
    );
  }

  Widget listHeader(String value, int flex, {TextAlign textAlign = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        textAlign: textAlign,
      ),
    );
  }

  Widget listBody(String value, int flex, TextAlign textAlign, {bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade300), //inbox_rounded
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}