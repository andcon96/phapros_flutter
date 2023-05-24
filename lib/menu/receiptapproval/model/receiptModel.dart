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
      approvedby,
      domain,
      status,
      imrnbr,
      articlenbr,
      imrdate,
      arrivaldate,
      proddate,
      expdate,
      manufacturer,
      country,
      iscertofanalys,
      certofanalys,
      ismsds,
      msds,
      isforwarderdo,
      forwarderdo,
      ispackinglist,
      packinglist,
      isotherdocs,
      otherdocs,
      kemasansacdos,
      kemasansacdosdesc,
      kemasandrumvat,
      kemasandrumvatdesc,
      kemasanpalletpeti,
      kemasanpalletpetidesc,
      isclean,
      iscleandesc,
      isdry,
      isdrydesc,
      isnotspilled,
      isnotspilleddesc,
      issealed,
      ismanufacturerlabel,
      transporttransporterno,
      transportpoliceno,
      transportisclean,
      transportiscleandesc,
      transportisdry,
      transportisdrydesc,
      transportisnotspilled,
      transportisnotspilleddesc,
      transportispositionsingle,
      transportispositionsingledesc,
      transportissegregated,
      transportissegregateddesc,
      transportangkutancatatan,
      transportkelembapan,
      transportsuhu

      ;

    

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
    required this.approvedby,
    required this.domain,
    required this.status,
    required this.imrnbr,
    required this.articlenbr,
    required this.imrdate,
    required this.arrivaldate,
    required this.proddate,
    required this.expdate,
    required this.manufacturer,
    required this.country,
    required this.iscertofanalys,
    required this.certofanalys,
    required this.ismsds,
    required this.msds,
    required this.isforwarderdo,
    required this.forwarderdo,
    required this.ispackinglist,
    required this.packinglist,
    required this.isotherdocs,
    required this.otherdocs,
    required this.kemasansacdos,
    required this.kemasansacdosdesc,
    required this.kemasandrumvat,
    required this.kemasandrumvatdesc,
    required this.kemasanpalletpeti,
    required this.kemasanpalletpetidesc,
    required this.isclean,
    required this.iscleandesc,
    required this.isdry,
    required this.isdrydesc,
    required this.isnotspilled,
    required this.isnotspilleddesc,
    required this.issealed,
    required this.ismanufacturerlabel,
    required this.transporttransporterno,
    required this.transportpoliceno,
    required this.transportisclean,
    required this.transportiscleandesc,
    required this.transportisdry,
    required this.transportisdrydesc,
    required this.transportisnotspilled,
    required this.transportisnotspilleddesc,
    required this.transportispositionsingle,
    required this.transportispositionsingledesc,
    required this.transportissegregated,
    required this.transportissegregateddesc,
    required this.transportangkutancatatan,
    required this.transportkelembapan,
    required this.transportsuhu
    
    
  });

  factory receiptModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonmaster = json['get_master'];

    Map<String, dynamic> jsonpo = jsonmaster == null ? {} : jsonmaster['getpo'];
    Map<String, dynamic> jsontransport = jsonmaster == null ? {} : jsonmaster['get_transport'];
    Map<String, dynamic> jsonchecklist = jsonmaster == null ? {} : jsonmaster['get_checklist'];
    Map<String, dynamic> jsondocument = jsonmaster == null ? {} : jsonmaster['get_document'];
    Map<String, dynamic> jsonkemasan = jsonmaster == null ? {} : jsonmaster['get_kemasan'];
    Map<String, dynamic> jsongetappr = jsonmaster == null
        ? {}
        : jsonmaster['get_appr'] == null
            ? {}
            : jsonmaster['get_appr'];

    Map<String, dynamic> jsongetappruser = jsongetappr == null
        ? {}
        : jsongetappr.isEmpty
            ? {}
            : jsongetappr['get_user'] == null
                ? {}
                : jsongetappr['get_user'];
 
  
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
        approvedby: jsongetappruser == {} ? '-' : jsongetappruser['nama'],
        domain:  jsonmaster['rcpt_domain'],
        status: jsonmaster['rcpt_status'],
        imrnbr: jsonchecklist['rcptc_imr_nbr'],
        articlenbr:jsonchecklist['rcptc_article_nbr'],
        imrdate:jsonchecklist['rcptc_imr_date'].toString(),
        arrivaldate:jsonchecklist['rcptc_arrival_date'].toString(),
        proddate:jsonchecklist['rcptc_prod_date'].toString(),
        expdate:jsonchecklist['rcptc_exp_date'].toString(),
        manufacturer:jsonchecklist['rcptc_manufacturer'],
        country:jsonchecklist['rcptc_country'],
        iscertofanalys:jsondocument['rcptdoc_is_certofanalys'].toString(),
        certofanalys:jsondocument['rcptdoc_certofanalys'],
        ismsds:jsondocument['rcptdoc_is_msds'].toString(),
        msds:jsondocument['rcptdoc_msds'],
        isforwarderdo:jsondocument['rcptdoc_is_forwarderdo'].toString(),
        forwarderdo:jsondocument['rcptdoc_forwarderdo'],
        ispackinglist:jsondocument['rcptdoc_is_packinglist'].toString(),
        packinglist:jsondocument['rcptdoc_packinglist'],
        isotherdocs:jsondocument['rcptdoc_is_otherdocs'].toString(),
        otherdocs:jsondocument['rcptdoc_otherdocs'],
        kemasansacdos:jsonkemasan['rcptk_kemasan_sacdos'].toString(),
        kemasansacdosdesc:jsonkemasan['rcptk_kemasan_sacdos_desc'],
        kemasandrumvat:jsonkemasan['rcptk_kemasan_drumvat'].toString(),
        kemasandrumvatdesc:jsonkemasan['rcptk_kemasan_drumvat_desc'],
        kemasanpalletpeti:jsonkemasan['rcptk_kemasan_palletpeti'].toString(),
        kemasanpalletpetidesc:jsonkemasan['rcptk_kemasan_palletpeti_desc'],
        isclean:jsonkemasan['rcptk_is_clean'].toString(),
        iscleandesc:jsonkemasan['rcptk_is_clean_desc'],
        isdry:jsonkemasan['rcptk_is_dry'].toString(),
        isdrydesc:jsonkemasan['rcptk_is_dry_desc'],
        isnotspilled:jsonkemasan['rcptk_is_not_spilled'].toString(),
        isnotspilleddesc:jsonkemasan['rcptk_is_not_spilled_desc'],
        issealed:jsonkemasan['rcptk_is_sealed'].toString(),
        ismanufacturerlabel:jsonkemasan['rcptk_is_manufacturer_label'].toString(),
        transporttransporterno:jsontransport['rcptt_transporter_no'],
        transportpoliceno:jsontransport['rcptt_police_no'],
        transportisclean:jsontransport['rcptt_is_clean'].toString(),
        transportiscleandesc:jsontransport['rcptt_is_clean_desc'],
        transportisdry:jsontransport['rcptt_is_dry'].toString(),
        transportisdrydesc:jsontransport['rcptt_is_dry_desc'],
        transportisnotspilled:jsontransport['rcptt_is_not_spilled'].toString(),
        transportisnotspilleddesc:jsontransport['rcptt_is_not_spilled_desc'],
        transportispositionsingle:jsontransport['rcptt_is_position_single'].toString(),
        transportispositionsingledesc:jsontransport['rcptt_is_position_single_desc'],
        transportissegregated:jsontransport['rcptt_is_segregated'].toString(),
        transportissegregateddesc:jsontransport['rcptt_is_segregated_desc'],
        transportangkutancatatan:jsontransport['rcptt_angkutan_catatan'],
        transportkelembapan:jsontransport['rcptt_kelembapan'],
        transportsuhu:jsontransport['rcptt_suhu']
        
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
