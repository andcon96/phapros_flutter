import 'dart:convert';
import 'dart:ffi';

// ignore: non_constant_identifier_names
WsaPO WsaPOFromJson(String str) => WsaPO.fromJson(json.decode(str));

// ignore: non_constant_identifier_names
String WsaPOToJson(WsaPO data) => json.encode(data.toJson());

class WsaPO {
  List<Data>? data;

  WsaPO({this.data});

  WsaPO.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? tLvcNbr;
  String? tLvcDomain;
  String? tLvcShip;
  String? tLvcSite;
  String? tLvcVend;
  String? tLvcVendDesc;
  String? tLvtOrd;
  String? tLvtDue;
  String? tLvcCurr;
  String? tLvdTotalline;
  String? tLvcStatus;
  String? tLviLine;
  String? tLvcPart;
  String? tLvcPartDesc;
  String? tLvdQtyord;
  String? tLvdQtyRcvd;
  String? tLvdPrice;
  String? tLvcLoc;
  String? tLvcLotNext;
  bool? tIsSelected;
  String? tLvcUm;
  String? tLvcBatch;
  String? tLvcLot;
  String? tLvdQtyDatang;
  String? tLvdQtyReject;
  String? tLvdQtyTerima;
  String? tLvdQtyPerPackage;
  bool? tIsSaved;
  String? tLvcManufacturer;
  String? tLvcCountry;
  String? tIMRNo;
  String? tLvdOngoingQtyrcvd;
  String? tLvdOngoingQtyarr;
  String? tLvcExpDetailDate;
  String? tLvcManuDetailDate;
  String? tLvcPtUm;
  String? tLvdUmKonv;

  Data({
    this.tLvcNbr,
    this.tLvcDomain,
    this.tLvcShip,
    this.tLvcSite,
    this.tLvcVend,
    this.tLvcVendDesc,
    this.tLvtOrd,
    this.tLvtDue,
    this.tLvcCurr,
    this.tLvdTotalline,
    this.tLvcStatus,
    this.tLviLine,
    this.tLvcPart,
    this.tLvcPartDesc,
    this.tLvdQtyord,
    this.tLvdQtyRcvd,
    this.tLvdPrice,
    this.tLvcLoc,
    this.tLvcLotNext,
    this.tIsSelected,
    this.tLvcUm,
    this.tLvcBatch,
    this.tLvcLot,
    this.tLvdQtyDatang,
    this.tLvdQtyReject,
    this.tLvdQtyTerima,
    this.tLvdQtyPerPackage,
    this.tIsSaved,
    this.tLvcManufacturer,
    this.tLvcCountry,
    this.tIMRNo,
    this.tLvdOngoingQtyrcvd,
    this.tLvdOngoingQtyarr,
    this.tLvcExpDetailDate,
    this.tLvcManuDetailDate,
    this.tLvcPtUm,
    this.tLvdUmKonv,
  });

  Data.fromJson(Map<String, dynamic> json) {
    tLvcNbr = json['t_lvc_nbr'];
    tLvcDomain = json['t_lvc_domain'];
    tLvcShip = json['t_lvc_ship'];
    tLvcSite = json['t_lvc_site'];
    tLvcVend = json['t_lvc_vend'];
    tLvcVendDesc = json['t_lvc_vend_desc'];
    tLvtOrd = json['t_lvt_ord'];
    tLvtDue = json['t_lvt_due'];
    tLvcCurr = json['t_lvc_curr'];
    tLvdTotalline = json['t_lvd_totalline'];
    tLvcStatus = json['t_lvc_status'];
    tLviLine = json['t_lvi_line'];
    tLvcPart = json['t_lvc_part'];
    tLvcPartDesc = json['t_lvc_part_desc'];
    tLvdQtyord = json['t_lvd_qtyord'];
    tLvdQtyRcvd = json['t_lvd_qty_rcvd'];
    tLvdPrice = json['t_lvd_price'];
    tLvcLoc = json['t_lvc_loc'];
    tLvcLotNext = json['t_lvc_lot_next'];
    tIsSelected = json['t_isSelected'];
    tLvcUm = json['t_lvc_um'];
    tLvcBatch = json['t_lvc_batch'];
    tLvcLot = json['t_lvc_lot'];
    tLvdQtyDatang = json['t_lvd_qty_datang'];
    tLvdQtyReject = json['t_lvd_qty_reject'];
    tLvdQtyTerima = json['t_lvd_qty_terima'];
    tLvdQtyPerPackage = json['t_lvd_qty_per_package'];
    tIsSaved = json['t_is_saved'];
    tLvcManufacturer = json['t_lvc_manufacturer'];
    tLvcCountry = json['t_lvc_country'];
    tIMRNo = json['t_lvc_imrno'];
    tLvdOngoingQtyrcvd = json['t_lvd_ongoing_qtyrcvd'];
    tLvdOngoingQtyarr = json['t_lvd_ongoing_qtyarr'];
    tLvcExpDetailDate = json['t_lvc_exp_detail_date'];
    tLvcManuDetailDate = json['t_lvc_manu_detail_date'];
    tLvcPtUm = json['t_lvc_pt_um'];
    tLvdUmKonv = json['t_lvd_um_konv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['t_lvc_nbr'] = tLvcNbr;
    data['t_lvc_domain'] = tLvcDomain;
    data['t_lvc_ship'] = tLvcShip;
    data['t_lvc_site'] = tLvcSite;
    data['t_lvc_vend'] = tLvcVend;
    data['t_lvc_vend_desc'] = tLvcVendDesc;
    data['t_lvt_ord'] = tLvtOrd;
    data['t_lvt_due'] = tLvtDue;
    data['t_lvc_curr'] = tLvcCurr;
    data['t_lvd_totalline'] = tLvdTotalline;
    data['t_lvc_status'] = tLvcStatus;
    data['t_lvi_line'] = tLviLine;
    data['t_lvc_part'] = tLvcPart;
    data['t_lvc_part_desc'] = tLvcPartDesc;
    data['t_lvd_qtyord'] = tLvdQtyord;
    data['t_lvd_qty_rcvd'] = tLvdQtyRcvd;
    data['t_lvd_price'] = tLvdPrice;
    data['t_lvc_loc'] = tLvcLoc;
    data['t_lvc_lot_next'] = tLvcLotNext;
    data['t_isSelected'] = tIsSelected;
    data['t_lvc_um'] = tLvcUm;
    data['t_lvc_batch'] = tLvcBatch;
    data['t_lvc_lot'] = tLvcLot;
    data['t_lvd_qty_datang'] = tLvdQtyDatang;
    data['t_lvd_qty_reject'] = tLvdQtyReject;
    data['t_lvd_qty_terima'] = tLvdQtyTerima;
    data['t_lvd_qty_per_package'] = tLvdQtyPerPackage;
    data['t_is_saved'] = tIsSaved;
    data['t_lvc_manufacturer'] = tLvcManufacturer;
    data['t_lvc_country'] = tLvcCountry;
    data['t_lvc_imrno'] = tIMRNo;
    data['t_lvd_ongoing_qtyrcvd'] = tLvdOngoingQtyrcvd;
    data['t_lvd_ongoing_qtyarr'] = tLvdOngoingQtyarr;
    data['t_lvc_exp_detail_date'] = tLvcExpDetailDate;
    data['t_lvc_manu_detail_date'] = tLvcManuDetailDate;
    data['t_lvc_pt_um'] = tLvcPtUm;
    data['t_lvd_um_konv'] = tLvdUmKonv;
    return data;
  }
}
