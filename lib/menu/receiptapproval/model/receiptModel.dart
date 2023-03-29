import 'package:flutter/material.dart';
import 'dart:convert';

receiptrcpt purchaseOrderFromJson(String str) =>
    receiptrcpt.fromJson(json.decode(str));

String purchaseOrderToJson(receiptrcpt data) => json.encode(data.toJson());

class receiptrcpt {
  List<receiptModel>? data;
  Links? links;
  Meta? meta;

  receiptrcpt({this.data, this.links, this.meta});

  receiptrcpt.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <receiptModel>[];
      json['data'].forEach((v) {
        data!.add(receiptModel.fromJson(v));
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

class receiptModel {
  String? ponbr,
      rcpt_nbr,
      rcpt_date,
      rcptd_part,
      rcptd_qty_arr,
      rcptd_lot,
      rcptd_loc,
      batch,
      supplier,
      shipto,
      rcptd_qty_appr,
      rcptd_qty_rej,
      lastapproval,
      nextapproval,
      laststatus;
  int? userid;
  receiptModel({
    required this.ponbr,
    required this.rcpt_nbr,
    required this.rcpt_date,
    required this.rcptd_part,
    required this.rcptd_qty_arr,
    required this.rcptd_loc,
    required this.rcptd_lot,
    required this.batch,
    required this.supplier,
    required this.shipto,
    required this.rcptd_qty_appr,
    required this.rcptd_qty_rej,
    required this.lastapproval,
    required this.nextapproval,
    required this.userid,
    required this.laststatus,
  });

  factory receiptModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonmaster = json['get_master'];

    Map<String, dynamic> jsonpo = jsonmaster == null ? {} : jsonmaster['getpo'];
    Map<String, dynamic> jsonlastappr = jsonmaster == null
        ? {}
        : jsonmaster['get_appr_histlast'] == null
            ? {}
            : jsonmaster['get_appr_histlast'];

    Map<String, dynamic> jsonlastappruser = jsonlastappr == null
        ? {}
        : jsonlastappr.isEmpty
            ? {}
            : jsonlastappr['get_user'] == null
                ? {}
                : jsonlastappr['get_user'];
    Map<String, dynamic> jsonfirstappr = jsonmaster == null
        ? {}
        : jsonmaster['get_appr_histfirst'] == null
            ? {}
            : jsonmaster['get_appr_histfirst'];
    Map<String, dynamic> jsonfirstappruser = jsonfirstappr == null
        ? {}
        : jsonfirstappr['get_user'] == null
            ? {}
            : jsonfirstappr['get_user'];

    return receiptModel(
        ponbr: jsonpo['po_nbr'],
        rcpt_nbr: jsonmaster['rcpt_nbr'],
        rcpt_date: jsonmaster['rcpt_date'],
        rcptd_part: json['rcptd_part'],
        rcptd_loc: json['rcptd_loc'],
        rcptd_qty_arr: json['sum_qty_arr'],
        rcptd_lot: json['rcptd_lot'],
        rcptd_qty_appr: json['sum_qty_appr'],
        rcptd_qty_rej: json['sum_qty_rej'],
        batch: json['rcptd_batch'],
        shipto: jsonpo['po_ship'],
        supplier: jsonpo['po_vend'],
        lastapproval: jsonlastappruser == {} ? '-' : jsonlastappruser['nama'],
        nextapproval: jsonfirstappruser == {} ? '-' : jsonfirstappruser['nama'],
        userid: jsonfirstappruser['id_anggota'] == {} ? null : jsonfirstappruser['id_anggota'],
        laststatus: jsonlastappr == null ? null : jsonlastappruser['nama']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ponbr'] = ponbr;
    data['rcpt_nbr'] = rcpt_nbr;
    data['rcpt_date'] = rcpt_date;
    data['rcptd_part'] = rcptd_part;
    data['rcptd_loc'] = rcptd_loc;
    data['rcptd_qty_arr'] = rcptd_qty_arr;
    data['rcptd_lot'] = rcptd_lot;
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
