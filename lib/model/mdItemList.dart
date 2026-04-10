class ItemListModel {
  String? description;
  int? qty;
  int? unit;
  double? beforevat;
  double? vat;
  int? total;

  ItemListModel(
      {this.description,
      this.qty,
      this.unit,
      this.beforevat,
      this.vat,
      this.total});

  ItemListModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    qty = json['qty'];
    unit = json['unit'];
    beforevat = json['beforevat'];
    vat = json['vat'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['qty'] = qty;
    data['unit'] = unit;
    data['beforevat'] = beforevat;
    data['vat'] = vat;
    data['total'] = total;
    return data;
  }
  static List<ItemListModel>? fromJsonList(List list) =>list.map((item) => ItemListModel.fromJson(item)).toList();
}