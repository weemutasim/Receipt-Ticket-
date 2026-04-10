import 'package:flutter/material.dart';
import 'package:receipt_ticket/model/mdReceipt.dart';

import '../fonts/appColor.dart';
import '../receipt/invoice.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<dynamic> companies = [
    {"code": "05926", "name": "3T DMC Co., Ltd. (Green Mind Travel)", "taxId": "0123456789012", "address": "123 Green Way, Bangkok"},
    {"code": "07399", "name": "888 Travel and Transport", "taxId": "0987654321098", "address": "456 Transport Rd, Bangkok"},
    {"code": "07637", "name": "A & D Holidays Co., Ltd. (Other)", "taxId": "1122334455667", "address": "789 Holiday Ave, Phuket"},
    {"code": "07796", "name": "A & S Travel Service (Thailand) Co., Ltd.", "taxId": "0835560017615", "address": "197 Pracharuamjai 59, Sai Kongdintai, Klong Sam Wa, Bangkok 10250"},
    {"code": "E0149", "name": "A Class Worldwide Co., Ltd.", "taxId": "9988776655443", "address": "101 Classy Blvd, Chiang Mai"},
  ];

  final List<dynamic> taxRecords = [
    {"res_code": "LE57V", "voucher": "3376239", "pax": "1", "mintax": "0300229018", "maxtax": "0300229018", "status": "S+D"},
    {"res_code": "LER1X", "voucher": "Naveen", "pax": "4", "mintax": "0400597178", "maxtax": "0400597181", "status": "S+D"},
    {"res_code": "LEN9Y", "voucher": "3369279", "pax": "4", "mintax": "0500709190", "maxtax": "0500709193", "status": "S+D"},
  ];

  String selectedCompanyCode = "05926";
  bool isReceiptSelected = true;

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  // List<dynamic> itemList = []; //รายการโหลด

  @override
  void initState() {
    final initialCompany = companies.firstWhere((c) => c['code'] == selectedCompanyCode);
    _codeController = TextEditingController(text: initialCompany['code']);
    _nameController = TextEditingController(text: initialCompany['name']);
    _addressController = TextEditingController(text: initialCompany['address']);

    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void _updateFormFields(Map<String, String> company) {
    _codeController.text = company['code'] ?? '';
    _nameController.text = company['name'] ?? '';
    _addressController.text = company['address'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Row Tax', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Row(
        children: [
          // LEFT PANEL: Master List
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
          // RIGHT PANEL: Details & Data
          Expanded(
            flex: 5,
            child: Padding(
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
                        onPressed: () {
                          Invoice().generateInvoice(data: Detail(), itemList: []).then((onValue) {

                          });
                        },
                        icon: const Icon(Icons.print_rounded, size: 20),
                        label: const Text('Save /Print', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildCompanyDetailsCard(), // Now contains editable fields
                  const SizedBox(height: 24),
                  const Text('รายการโหลด /วัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        listHeader('Res code', 2),
                        listHeader('Voucher', 3),
                        listHeader('Pax', 2),
                        listHeader('Mintax', 3),
                        listHeader('Maxtax', 3),
                        listHeader('Status', 2),
                      ],
                    ),
                  ),
                  if (taxRecords.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(child: Text("ไม่มีรายการโหลด", style: TextStyle(color: Colors.grey))),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taxRecords.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final item = taxRecords[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              listBody(item['res_code'] ?? '', 2, TextAlign.left),
                              listBody(item['voucher']  ?? '', 3, TextAlign.left),
                              listBody(item['pax']  ?? '', 2, TextAlign.left),
                              listBody(item['mintax'] ?? '', 3, TextAlign.left),
                              listBody(item['maxtax'] ?? '', 3, TextAlign.left),
                              listBody(item['status'] ?? '', 2, TextAlign.left, isBold: true),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern Header & Search
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
                    },
                    child: const Text('รายการ Reprint', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Modern pill shape
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
        
        // Modern List View
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: companies.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8), // Gap between cards
            itemBuilder: (context, index) {
              final company = companies[index];
              final isSelected = company['code'] == selectedCompanyCode;
              
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
                    if (!isSelected) // Only show shadow if not selected (makes selected look "pressed")
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
                    company['name']!,
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
                          'Code:',
                          style: TextStyle(
                            color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.8) : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          company['code']!,
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
                      selectedCompanyCode = company['code']!;
                      _updateFormFields(company); 
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
            // Modern Header for the Card
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.domain, // Business/Building icon
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

            // Form Fields Layout
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
        fillColor: Colors.grey.shade50, // Soft background color
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
        // Adjust padding to make it breathe
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
}