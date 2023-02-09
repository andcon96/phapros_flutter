import 'dart:convert';

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

  Data(
      {this.tLvcNbr,
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
      this.tIsSelected});

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
    return data;
  }
}
