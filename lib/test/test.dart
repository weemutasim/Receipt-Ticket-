import 'package:flutter/material.dart';

import '../fonts/appColor.dart';

class ModernReprintScreen extends StatefulWidget {
  const ModernReprintScreen({Key? key}) : super(key: key);

  @override
  State<ModernReprintScreen> createState() => _ModernReprintScreenState();
}

class _ModernReprintScreenState extends State<ModernReprintScreen> {
  DateTimeRange? _selectedDateRange;

  // Helper method to format dates nicely without needing the 'intl' package
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  // Mock data utilizing real DateTime objects for accurate filtering
  late final List<Map<String, dynamic>> _reprintData;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _reprintData = List.generate(
      15,
      (index) {
        // Generate mock dates spread across the last 30 days
        final itemDate = now.subtract(Duration(days: index * 2));
        return {
          'rawDate': itemDate,
          'dateStr': _formatDate(itemDate),
          'docNo': 'RE-${800120 + index}',
          'customer': 'Der Asia Tours Co., Ltd.',
          'amount': (1250.00 + (index * 150)).toStringAsFixed(2),
          'status': index % 4 == 0 ? 'Cancelled' : 'Completed',
        };
      },
    );
  }

  // The getter that actively filters the list based on the selected date range
  List<Map<String, dynamic>> get _filteredData {
    if (_selectedDateRange == null) return _reprintData;

    return _reprintData.where((item) {
      DateTime itemDate = item['rawDate'];
      // Check if the date falls inside the selected range (inclusive)
      return itemDate.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
             itemDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

  // Function to show the Date Range Picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000), // Adjust to your business logic
      lastDate: DateTime.now().add(const Duration(days: 365)), 
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB), // Matches your primary blue
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pinkcm,
        title: const Text('Reprint', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSearchAndFilter(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'รายการพิมพ์ใบเสร็จย้อนหลัง',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage and reprint your previous receipts and documents.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    final hasFilter = _selectedDateRange != null;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Document No. or Customer...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const Spacer(flex: 3),
        
        // Dynamic Date Filter Button
        OutlinedButton.icon(
          onPressed: hasFilter ? () => setState(() => _selectedDateRange = null) : _selectDateRange,
          icon: Icon(
            hasFilter ? Icons.clear : Icons.calendar_today_outlined, 
            size: 18,
            color: hasFilter ? Colors.redAccent : const Color(0xFF0F172A),
          ),
          label: Text(
            hasFilter 
              ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}' 
              : 'Filter by Date',
            style: TextStyle(
              color: hasFilter ? Colors.redAccent : const Color(0xFF0F172A),
              fontWeight: hasFilter ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: hasFilter ? Colors.red.shade50 : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            side: BorderSide(color: hasFilter ? Colors.redAccent.shade100 : Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    final dataToDisplay = _filteredData; // Use the dynamically filtered list

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                _tableHeaderCell('Date', flex: 2),
                _tableHeaderCell('Document No.', flex: 2),
                _tableHeaderCell('Customer / Agent', flex: 4),
                _tableHeaderCell('Amount (THB)', flex: 2, isRightAligned: true),
                _tableHeaderCell('Status', flex: 2, isCentered: true),
                _tableHeaderCell('Action', flex: 1, isCentered: true),
              ],
            ),
          ),
          
          // Table Body or Empty State
          Expanded(
            child: dataToDisplay.isEmpty
                ? Center(
                    child: Text(
                      'No documents found for this date range.',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: dataToDisplay.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                    ),
                    itemBuilder: (context, index) {
                      final item = dataToDisplay[index];
                      return _buildTableRow(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> item) {
    final bool isCompleted = item['status'] == 'Completed';

    return InkWell(
      onTap: () {},
      hoverColor: const Color(0xFFF8FAFC),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            _tableDataCell(item['dateStr'], flex: 2),
            _tableDataCell(item['docNo'], flex: 2, isBold: true),
            _tableDataCell(item['customer'], flex: 4),
            _tableDataCell(item['amount'], flex: 2, isRightAligned: true, isBold: true),
            
            // Status Badge
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ),
            ),

            // Action Button
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(Icons.print_rounded),
                  color: AppColors.darkPink,
                  tooltip: 'Reprint Document',
                  splashRadius: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for Table ---

  Widget _tableHeaderCell(String text, {int flex = 1, bool isRightAligned = false, bool isCentered = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: isCentered ? TextAlign.center : (isRightAligned ? TextAlign.right : TextAlign.left),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _tableDataCell(String text, {int flex = 1, bool isRightAligned = false, bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: isRightAligned ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }
}