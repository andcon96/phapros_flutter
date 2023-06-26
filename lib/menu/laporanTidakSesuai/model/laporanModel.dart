import 'package:flutter/material.dart';
import 'dart:convert';

laporanrcpt purchaseOrderFromJson(String str) =>
    laporanrcpt.fromJson(json.decode(str));

String purchaseOrderToJson(laporanrcpt data) => json.encode(data.toJson());

class laporanrcpt {
  List<laporanModel>? data;
  Links? links;
  Meta? meta;

  laporanrcpt({this.data, this.links, this.meta});

  laporanrcpt.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <laporanModel>[];
      json['data'].forEach((v) {
        data!.add(laporanModel.fromJson(v));
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
class laporanModel{
  String? 
  ponbr, 
  rcpt_nbr, 
  rcpt_date, 
  rcptd_part, 
  rcptd_qty_arr, 
  rcptd_lot, 
  rcptd_loc, 
  rcptd_qty_appr, 
  rcptd_qty_rej, 
  nopol, 
  angkutan,
  supplier,
  komplain,
  keterangan,
  tanggal,
  komplaindetail,
  no,
  createdby,
  rcptd_batch,
  rcptd_imr;

  laporanModel({
    required this.ponbr, 
    required this.rcpt_nbr, 
    required this.rcpt_date, 
    required this.rcptd_part, 
    required this.rcptd_qty_arr,
    required this.rcptd_loc,
    required this.rcptd_lot, 
    required this.rcptd_qty_appr,
    required this.rcptd_qty_rej,
    required this.rcptd_batch,
    required this.rcptd_imr,
    required this.nopol, 
    required this.angkutan, 
    required this.supplier,
    required this.komplain,
    required this.keterangan,
    required this.tanggal,
    required this.komplaindetail,
    required this.no,
    required this.createdby
  });

  factory laporanModel.fromJson(Map<String, dynamic> json){
    Map<String, dynamic> jsonmaster = json['get_master'];
    Map<String, dynamic> jsonitem = json['get_item'];
    Map<String, dynamic> jsonpo = jsonmaster['getpo'];
    Map<String, dynamic> jsonlaporan = jsonmaster['get_laporan'] == null ? {} : jsonmaster['get_laporan'];
    Map<String, dynamic> jsonuser = jsonlaporan['get_user_laporan'] == null ? {} : jsonlaporan['get_user_laporan'];
    Map<String, dynamic> jsontransport = jsonmaster['get_transport'];
    Map<String, dynamic> jsonchecklist = jsonmaster['get_checklist'];
  

    return laporanModel(
      ponbr: jsonpo['po_nbr'],
      rcpt_nbr: jsonmaster['rcpt_nbr'],
      rcpt_date: jsonmaster['rcpt_date'],
      rcptd_part: json['rcptd_part'] + ' -- ' + jsonitem['item_desc'],
      rcptd_loc: json['rcptd_loc'],
      rcptd_qty_arr: json['sum_qty_arr'],
      rcptd_lot: json['rcptd_lot'],
      rcptd_batch: json['rcptd_batch'],
      rcptd_qty_appr: json['sum_qty_appr'],
      rcptd_qty_rej: json['sum_qty_rej'],
      nopol: jsontransport['rcptt_police_no'],
      angkutan: jsontransport['rcptt_transporter_no'],
      supplier: jsonpo['po_vend'],
      komplain: jsonlaporan == {} ? '-' : jsonlaporan['laporan_komplain'],
      keterangan: jsonlaporan['laporan_keterangan'] ?? '-',
      tanggal: jsonlaporan['laporan_tgl'] ?? '-',
      komplaindetail: jsonlaporan['laporan_komplaindetail'] ?? '-',
      no: jsonlaporan['laporan_no'] ?? '-',
      createdby: jsonuser['nama'] ?? '-',
      rcptd_imr: jsonchecklist['rcptc_imr_nbr'] ?? '-',
    );
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
    data['rcptd_qty_appr'] = rcptd_qty_appr;
    data['rcptd_qty_rej'] = rcptd_qty_rej;
    data['nopol'] = nopol;
    data['angkutan'] = angkutan;
    data['supplier'] = supplier;
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


