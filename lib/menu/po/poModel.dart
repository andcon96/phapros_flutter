// To parse this JSON data, do
//
//     final kn = knFromJson(jsonString);

import 'dart:convert';

PurchaseOrder purchaseOrderFromJson(String str) =>
    PurchaseOrder.fromJson(json.decode(str));

String purchaseOrderToJson(PurchaseOrder data) => json.encode(data.toJson());

class PurchaseOrder {
  List<Data>? data;
  Links? links;
  Meta? meta;

  PurchaseOrder({this.data, this.links, this.meta});

  PurchaseOrder.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? poDomain;
  String? poNbr;
  String? poShip;
  String? poSite;
  String? poVend;
  String? poOrdDate;
  String? poDueDate;
  String? poCurr;
  String? poPpn;
  String? poStatus;
  String? poTotal;
  List<PoDetails>? poDetails;

  Data(
      {this.id,
      this.poDomain,
      this.poNbr,
      this.poShip,
      this.poSite,
      this.poVend,
      this.poOrdDate,
      this.poDueDate,
      this.poCurr,
      this.poPpn,
      this.poStatus,
      this.poTotal,
      this.poDetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poDomain = json['po_domain'];
    poNbr = json['po_nbr'];
    poShip = json['po_ship'];
    poSite = json['po_site'];
    poVend = json['po_vend'];
    poOrdDate = json['po_ord_date'];
    poDueDate = json['po_due_date'];
    // ignore: void_checks
    poCurr = json['po_curr'];
    // ignore: void_checks
    poPpn = json['po_ppn'];
    // ignore: void_checks
    poStatus = json['po_status'];
    poTotal = json['po_total'];
    if (json['po_details'] != null) {
      poDetails = <PoDetails>[];
      json['po_details'].forEach((v) {
        poDetails!.add(PoDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['po_domain'] = poDomain;
    data['po_nbr'] = poNbr;
    data['po_ship'] = poShip;
    data['po_site'] = poSite;
    data['po_vend'] = poVend;
    data['po_ord_date'] = poOrdDate;
    data['po_due_date'] = poDueDate;
    data['po_curr'] = poCurr;
    data['po_ppn'] = poPpn;
    data['po_status'] = poStatus;
    data['po_total'] = poTotal;
    if (poDetails != null) {
      data['po_details'] = poDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PoDetails {
  int? id;
  int? podPoId;
  String? podDomain;
  int? podLine;
  String? podPart;
  String? podPartDesc;
  String? podQtyOrd;
  String? podQtyRcvd;
  String? podPurCost;
  String? podLoc;
  String? podLot;
  String? createdAt;
  String? updatedAt;

  PoDetails(
      {this.id,
      this.podPoId,
      this.podDomain,
      this.podLine,
      this.podPart,
      this.podPartDesc,
      this.podQtyOrd,
      this.podQtyRcvd,
      this.podPurCost,
      this.podLoc,
      this.podLot,
      this.createdAt,
      this.updatedAt});

  PoDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    podPoId = json['pod_po_id'];
    podDomain = json['pod_domain'];
    podLine = json['pod_line'];
    podPart = json['pod_part'];
    podPartDesc = json['pod_desc'];
    podQtyOrd = json['pod_qty_ord'];
    podQtyRcvd = json['pod_qty_rcvd'];
    podPurCost = json['pod_pur_cost'];
    podLoc = json['pod_loc'];
    podLot = json['pod_lot'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['pod_po_id'] = podPoId;
    data['pod_domain'] = podDomain;
    data['pod_line'] = podLine;
    data['pod_part'] = podPart;
    data['pod_desc'] = podPartDesc;
    data['pod_qty_ord'] = podQtyOrd;
    data['pod_qty_rcvd'] = podQtyRcvd;
    data['pod_pur_cost'] = podPurCost;
    data['pod_loc'] = podLoc;
    data['pod_lot'] = podLot;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first'] = first;
    data['last'] = last;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<MetaLinks>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.links,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <MetaLinks>[];
      json['links'].forEach((v) {
        links!.add(MetaLinks.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['current_page'] = currentPage;
    data['from'] = from;
    data['last_page'] = lastPage;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['path'] = path;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class MetaLinks {
  String? url;
  String? label;
  bool? active;

  MetaLinks({this.url, this.label, this.active});

  MetaLinks.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
