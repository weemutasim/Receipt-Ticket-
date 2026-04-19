class TkReceiptModel {
  String? rsvn;
  String? id;
  String? voucher;
  String? showdate;
  String? mintax;
  String? maxtax;
  String? pax;
  String? accode;
  String? agentcode;
  String? customerName;
  String? custaxidno;
  String? ppcName;
  String? addressPp1;
  String? addressPp2;
  String? pppostCode;
  String? branchtax;
  String? docno;
  String? tk;
  String? tr;
  String? total;

  TkReceiptModel(
      {this.rsvn,
      this.id,
      this.voucher,
      this.showdate,
      this.mintax,
      this.maxtax,
      this.pax,
      this.accode,
      this.agentcode,
      this.customerName,
      this.custaxidno,
      this.ppcName,
      this.addressPp1,
      this.addressPp2,
      this.pppostCode,
      this.branchtax,
      this.docno,
      this.tk,
      this.tr,
      this.total});

  TkReceiptModel.fromJson(Map<String, dynamic> json) {
    rsvn = json['rsvn'];
    id = json['id'];
    voucher = json['voucher'];
    showdate = json['showdate'];
    mintax = json['Mintax'];
    maxtax = json['Maxtax'];
    pax = json['pax'];
    accode = json['accode'];
    agentcode = json['agentcode'];
    customerName = json['customer_name'];
    custaxidno = json['custaxidno'];
    ppcName = json['ppc_name'];
    addressPp1 = json['address_pp1'];
    addressPp2 = json['address_pp2'];
    pppostCode = json['pppost_code'];
    branchtax = json['branchtax'];
    docno = json['docno'];
    tk = json['tk'];
    tr = json['tr'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rsvn'] = rsvn;
    data['id'] = id;
    data['voucher'] = voucher;
    data['showdate'] = showdate;
    data['Mintax'] = mintax;
    data['Maxtax'] = maxtax;
    data['pax'] = pax;
    data['accode'] = accode;
    data['agentcode'] = agentcode;
    data['customer_name'] = customerName;
    data['custaxidno'] = custaxidno;
    data['ppc_name'] = ppcName;
    data['address_pp1'] = addressPp1;
    data['address_pp2'] = addressPp2;
    data['pppost_code'] = pppostCode;
    data['branchtax'] = branchtax;
    data['docno'] = docno;
    data['tk'] = tk;
    data['tr'] = tr;
    data['total'] = total;
    return data;
  }
  static List<TkReceiptModel>? fromJsonList(List list) =>list.map((item) => TkReceiptModel.fromJson(item)).toList();
}
