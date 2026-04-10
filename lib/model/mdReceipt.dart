class Receipt {
  String? docdate;
  List<Detail>? detail;

  Receipt({this.docdate, this.detail});

  Receipt.fromJson(Map<String, dynamic> json) {
    docdate = json['docdate'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docdate'] = docdate;
    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  static List<Receipt>? fromJsonList(List list) =>list.map((item) => Receipt.fromJson(item)).toList();
}

class Detail {
  String? docno;
  String? docdate;
  String? extcode;
  String? agentname;
  String? address;
  String? trdate;
  String? issue;
  String? recivetype;
  String? trrunno;
  String? accode;
  String? referno;
  String? amount;
  String? acReportName;
  String? bankAccount;

  Detail(
      {this.docno,
      this.docdate,
      this.extcode,
      this.agentname,
      this.address,
      this.trdate,
      this.issue,
      this.recivetype,
      this.trrunno,
      this.accode,
      this.referno,
      this.amount,
      this.acReportName,
      this.bankAccount});

  Detail.fromJson(Map<String, dynamic> json) {
    docno = json['docno'];
    docdate = json['docdate'];
    extcode = json['extcode'];
    agentname = json['agentname'];
    address = json['address'];
    trdate = json['trdate'];
    issue = json['issue'];
    recivetype = json['recivetype'];
    trrunno = json['trrunno'];
    accode = json['accode'];
    referno = json['referno'];
    amount = json['amount'];
    acReportName = json['AcReportName'];
    bankAccount = json['bank_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docno'] = docno;
    data['docdate'] = docdate;
    data['extcode'] = extcode;
    data['agentname'] = agentname;
    data['address'] = address;
    data['trdate'] = trdate;
    data['issue'] = issue;
    data['recivetype'] = recivetype;
    data['trrunno'] = trrunno;
    data['accode'] = accode;
    data['referno'] = referno;
    data['amount'] = amount;
    data['AcReportName'] = acReportName;
    data['bank_account'] = bankAccount;
    return data;
  }
}
