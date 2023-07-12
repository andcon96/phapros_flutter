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
  String? poVendDesc;
  String? poOrdDate;
  String? poDueDate;
  String? poCurr;
  String? poPpn;
  String? poStatus;
  String? poTotal;
  List<PoDetails>? poDetails;
  List<PoListApproval>? poListApproval;
  List<PoListReceipt>? poListReceipt;

  Data(
      {this.id,
      this.poDomain,
      this.poNbr,
      this.poShip,
      this.poSite,
      this.poVend,
      this.poVendDesc,
      this.poOrdDate,
      this.poDueDate,
      this.poCurr,
      this.poPpn,
      this.poStatus,
      this.poTotal,
      this.poDetails,
      this.poListReceipt,
      this.poListApproval});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poDomain = json['po_domain'];
    poNbr = json['po_nbr'];
    poShip = json['po_ship'];
    poSite = json['po_site'];
    poVend = json['po_vend'];
    poVendDesc = json['po_vend_desc'];
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
    if (json['po_list_receipt'] != null) {
      poListReceipt = <PoListReceipt>[];
      json['po_list_receipt'].forEach((v) {
        poListReceipt!.add(PoListReceipt.fromJson(v));
      });
    }
    if (json['po_list_approval'] != null) {
      poListApproval = <PoListApproval>[];
      json['po_list_approval'].forEach((v) {
        poListApproval!.add(PoListApproval.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['po_domain'] = poDomain;
    data['po_nbr'] = poNbr;
    data['po_ship'] = poShip;
    data['po_site'] = poSite;
    data['po_vend'] = poVend;
    data['po_vend_desc'] = poVendDesc;
    data['po_ord_date'] = poOrdDate;
    data['po_due_date'] = poDueDate;
    data['po_curr'] = poCurr;
    data['po_ppn'] = poPpn;
    data['po_status'] = poStatus;
    data['po_total'] = poTotal;
    if (poDetails != null) {
      data['po_details'] = poDetails!.map((v) => v.toJson()).toList();
    }
    if (poListReceipt != null) {
      data['po_list_receipt'] = poListReceipt!.map((v) => v.toJson()).toList();
    }
    if (poListApproval != null) {
      data['po_list_approval'] =
          poListApproval!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
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

class PoListReceipt {
  int? id;
  int? rcptPoId;
  String? rcptDomain;
  String? rcptNbr;
  String? rcptStatus;
  String? rcptUserId;
  String? rcptDate;
  String? createdAt;
  String? updatedAt;
  List<GetDetail>? getDetail;
  GetChecklist? getChecklist;
  GetDocument? getDocument;
  GetKemasan? getKemasan;
  GetTransport? getTransport;
  List<GetHistoryApproval>? getHistoryApproval;
  List<GetIsOngoinApproval>? getIsOngoinApproval;

  PoListReceipt(
      {this.id,
      this.rcptPoId,
      this.rcptDomain,
      this.rcptNbr,
      this.rcptStatus,
      this.rcptUserId,
      this.rcptDate,
      this.createdAt,
      this.updatedAt,
      this.getDetail,
      this.getChecklist,
      this.getDocument,
      this.getKemasan,
      this.getTransport,
      this.getHistoryApproval,
      this.getIsOngoinApproval});

  PoListReceipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcptPoId = json['rcpt_po_id'];
    rcptDomain = json['rcpt_domain'];
    rcptNbr = json['rcpt_nbr'];
    rcptStatus = json['rcpt_status'];
    rcptUserId = json['rcpt_user_id'];
    rcptDate = json['rcpt_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['get_detail'] != null) {
      getDetail = <GetDetail>[];
      json['get_detail'].forEach((v) {
        getDetail!.add(GetDetail.fromJson(v));
      });
    }
    getChecklist = json['get_checklist'] != null
        ? new GetChecklist.fromJson(json['get_checklist'])
        : null;
    getDocument = json['get_document'] != null
        ? new GetDocument.fromJson(json['get_document'])
        : null;
    getKemasan = json['get_kemasan'] != null
        ? new GetKemasan.fromJson(json['get_kemasan'])
        : null;
    getTransport = json['get_transport'] != null
        ? new GetTransport.fromJson(json['get_transport'])
        : null;
    if (json['get_history_approval'] != null) {
      getHistoryApproval = <GetHistoryApproval>[];
      json['get_history_approval'].forEach((v) {
        getHistoryApproval!.add(GetHistoryApproval.fromJson(v));
      });
    }
    if (json['get_is_ongoin_approval'] != null) {
      getIsOngoinApproval = <GetIsOngoinApproval>[];
      json['get_is_ongoin_approval'].forEach((v) {
        getIsOngoinApproval!.add(GetIsOngoinApproval.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['rcpt_po_id'] = rcptPoId;
    data['rcpt_domain'] = rcptDomain;
    data['rcpt_nbr'] = rcptNbr;
    data['rcpt_status'] = rcptStatus;
    data['rcpt_user_id'] = rcptUserId;
    data['rcpt_date'] = rcptDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (getDetail != null) {
      data['get_detail'] = getDetail!.map((v) => v.toJson()).toList();
    }
    if (getChecklist != null) {
      data['get_checklist'] = getChecklist?.toJson();
    }
    if (getDocument != null) {
      data['get_document'] = getDocument?.toJson();
    }
    if (getKemasan != null) {
      data['get_kemasan'] = getKemasan?.toJson();
    }
    if (getTransport != null) {
      data['get_transport'] = getTransport?.toJson();
    }
    if (getHistoryApproval != null) {
      data['get_history_approval'] =
          getHistoryApproval!.map((v) => v.toJson()).toList();
    }
    if (getIsOngoinApproval != null) {
      data['get_is_ongoin_approval'] =
          getIsOngoinApproval!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetChecklist {
  int? id;
  int? rcptcRcptId;
  String? rcptcImrNbr;
  String? rcptcArticleNbr;
  String? rcptcImrDate;
  String? rcptcArrivalDate;
  String? rcptcProdDate;
  String? rcptcExpDate;
  String? rcptcManufacturer;
  String? rcptcCountry;
  String? createdAt;
  String? updatedAt;

  GetChecklist(
      {this.id,
      this.rcptcRcptId,
      this.rcptcImrNbr,
      this.rcptcArticleNbr,
      this.rcptcImrDate,
      this.rcptcArrivalDate,
      this.rcptcProdDate,
      this.rcptcExpDate,
      this.rcptcManufacturer,
      this.rcptcCountry,
      this.createdAt,
      this.updatedAt});

  GetChecklist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcptcRcptId = json['rcptc_rcpt_id'];
    rcptcImrNbr = json['rcptc_imr_nbr'];
    rcptcArticleNbr = json['rcptc_article_nbr'];
    rcptcImrDate = json['rcptc_imr_date'];
    rcptcArrivalDate = json['rcptc_arrival_date'];
    rcptcProdDate = json['rcptc_prod_date'];
    rcptcExpDate = json['rcptc_exp_date'];
    rcptcManufacturer = json['rcptc_manufacturer'];
    rcptcCountry = json['rcptc_country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['rcptc_rcpt_id'] = rcptcRcptId;
    data['rcptc_imr_nbr'] = rcptcImrNbr;
    data['rcptc_article_nbr'] = rcptcArticleNbr;
    data['rcptc_imr_date'] = rcptcImrDate;
    data['rcptc_arrival_date'] = rcptcArrivalDate;
    data['rcptc_prod_date'] = rcptcProdDate;
    data['rcptc_exp_date'] = rcptcExpDate;
    data['rcptc_manufacturer'] = rcptcManufacturer;
    data['rcptc_country'] = rcptcCountry;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetDocument {
  int? id;
  int? rcptdocRcptId;
  int? rcptdocIsCertofanalys;
  String? rcptdocCertofanalys;
  int? rcptdocIsMsds;
  String? rcptdocMsds;
  int? rcptdocIsForwarderdo;
  String? rcptdocForwarderdo;
  int? rcptdocIsPackinglist;
  String? rcptdocPackinglist;
  int? rcptdocIsOtherdocs;
  String? rcptdocOtherdocs;
  String? createdAt;
  String? updatedAt;

  GetDocument(
      {this.id,
      this.rcptdocRcptId,
      this.rcptdocIsCertofanalys,
      this.rcptdocCertofanalys,
      this.rcptdocIsMsds,
      this.rcptdocMsds,
      this.rcptdocIsForwarderdo,
      this.rcptdocForwarderdo,
      this.rcptdocIsPackinglist,
      this.rcptdocPackinglist,
      this.rcptdocIsOtherdocs,
      this.rcptdocOtherdocs,
      this.createdAt,
      this.updatedAt});

  GetDocument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcptdocRcptId = json['rcptdoc_rcpt_id'];
    rcptdocIsCertofanalys = json['rcptdoc_is_certofanalys'];
    rcptdocCertofanalys = json['rcptdoc_certofanalys'];
    rcptdocIsMsds = json['rcptdoc_is_msds'];
    rcptdocMsds = json['rcptdoc_msds'];
    rcptdocIsForwarderdo = json['rcptdoc_is_forwarderdo'];
    rcptdocForwarderdo = json['rcptdoc_forwarderdo'];
    rcptdocIsPackinglist = json['rcptdoc_is_packinglist'];
    rcptdocPackinglist = json['rcptdoc_packinglist'];
    rcptdocIsOtherdocs = json['rcptdoc_is_otherdocs'];
    rcptdocOtherdocs = json['rcptdoc_otherdocs'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['rcptdoc_rcpt_id'] = rcptdocRcptId;
    data['rcptdoc_is_certofanalys'] = rcptdocIsCertofanalys;
    data['rcptdoc_certofanalys'] = rcptdocCertofanalys;
    data['rcptdoc_is_msds'] = rcptdocIsMsds;
    data['rcptdoc_msds'] = rcptdocMsds;
    data['rcptdoc_is_forwarderdo'] = rcptdocIsForwarderdo;
    data['rcptdoc_forwarderdo'] = rcptdocForwarderdo;
    data['rcptdoc_is_packinglist'] = rcptdocIsPackinglist;
    data['rcptdoc_packinglist'] = rcptdocPackinglist;
    data['rcptdoc_is_otherdocs'] = rcptdocIsOtherdocs;
    data['rcptdoc_otherdocs'] = rcptdocOtherdocs;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetKemasan {
  int? id;
  int? rcptkRcptId;
  int? rcptkKemasanSacdos;
  String? rcptkKemasanSacdosDesc;
  int? rcptkKemasanDrumvat;
  String? rcptkKemasanDrumvatDesc;
  int? rcptkKemasanPalletpeti;
  String? rcptkKemasanPalletpetiDesc;
  int? rcptkIsClean;
  String? rcptkIsCleanDesc;
  int? rcptkIsDry;
  String? rcptkIsDryDesc;
  int? rcptkIsNotSpilled;
  String? rcptkIsNotSpilledDesc;
  int? rcptkIsSealed;
  int? rcptkIsManufacturerLabel;
  String? createdAt;
  String? updatedAt;

  GetKemasan(
      {this.id,
      this.rcptkRcptId,
      this.rcptkKemasanSacdos,
      this.rcptkKemasanSacdosDesc,
      this.rcptkKemasanDrumvat,
      this.rcptkKemasanDrumvatDesc,
      this.rcptkKemasanPalletpeti,
      this.rcptkKemasanPalletpetiDesc,
      this.rcptkIsClean,
      this.rcptkIsCleanDesc,
      this.rcptkIsDry,
      this.rcptkIsDryDesc,
      this.rcptkIsNotSpilled,
      this.rcptkIsNotSpilledDesc,
      this.rcptkIsSealed,
      this.rcptkIsManufacturerLabel,
      this.createdAt,
      this.updatedAt});

  GetKemasan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcptkRcptId = json['rcptk_rcpt_id'];
    rcptkKemasanSacdos = json['rcptk_kemasan_sacdos'];
    rcptkKemasanSacdosDesc = json['rcptk_kemasan_sacdos_desc'];
    rcptkKemasanDrumvat = json['rcptk_kemasan_drumvat'];
    rcptkKemasanDrumvatDesc = json['rcptk_kemasan_drumvat_desc'];
    rcptkKemasanPalletpeti = json['rcptk_kemasan_palletpeti'];
    rcptkKemasanPalletpetiDesc = json['rcptk_kemasan_palletpeti_desc'];
    rcptkIsClean = json['rcptk_is_clean'];
    rcptkIsCleanDesc = json['rcptk_is_clean_desc'];
    rcptkIsDry = json['rcptk_is_dry'];
    rcptkIsDryDesc = json['rcptk_is_dry_desc'];
    rcptkIsNotSpilled = json['rcptk_is_not_spilled'];
    rcptkIsNotSpilledDesc = json['rcptk_is_not_spilled_desc'];
    rcptkIsSealed = json['rcptk_is_sealed'];
    rcptkIsManufacturerLabel = json['rcptk_is_manufacturer_label'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['rcptk_rcpt_id'] = rcptkRcptId;
    data['rcptk_kemasan_sacdos'] = rcptkKemasanSacdos;
    data['rcptk_kemasan_sacdos_desc'] = rcptkKemasanSacdosDesc;
    data['rcptk_kemasan_drumvat'] = rcptkKemasanDrumvat;
    data['rcptk_kemasan_drumvat_desc'] = rcptkKemasanDrumvatDesc;
    data['rcptk_kemasan_palletpeti'] = rcptkKemasanPalletpeti;
    data['rcptk_kemasan_palletpeti_desc'] = rcptkKemasanPalletpetiDesc;
    data['rcptk_is_clean'] = rcptkIsClean;
    data['rcptk_is_clean_desc'] = rcptkIsCleanDesc;
    data['rcptk_is_dry'] = rcptkIsDry;
    data['rcptk_is_dry_desc'] = rcptkIsDryDesc;
    data['rcptk_is_not_spilled'] = rcptkIsNotSpilled;
    data['rcptk_is_not_spilled_desc'] = rcptkIsNotSpilledDesc;
    data['rcptk_is_sealed'] = rcptkIsSealed;
    data['rcptk_is_manufacturer_label'] = rcptkIsManufacturerLabel;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetTransport {
  int? id;
  int? rcpttRcptId;
  String? rcpttTransporterNo;
  String? rcpttPoliceNo;
  int? rcpttIsClean;
  String? rcpttIsCleanDesc;
  int? rcpttIsDry;
  String? rcpttIsDryDesc;
  int? rcpttIsNotSpilled;
  String? rcpttIsNotSpilledDesc;
  int? rcpttIsPositionSingle;
  String? rcpttIsPositionSingleDesc;
  int? rcpttIsSegregated;
  String? rcpttIsSegregatedDesc;
  String? rcpttAngkutanCatatan;
  String? rcpttKelembapan;
  String? rcpttSuhu;
  String? createdAt;
  String? updatedAt;

  GetTransport(
      {this.id,
      this.rcpttRcptId,
      this.rcpttTransporterNo,
      this.rcpttPoliceNo,
      this.rcpttIsClean,
      this.rcpttIsCleanDesc,
      this.rcpttIsDry,
      this.rcpttIsDryDesc,
      this.rcpttIsNotSpilled,
      this.rcpttIsNotSpilledDesc,
      this.rcpttIsPositionSingle,
      this.rcpttIsPositionSingleDesc,
      this.rcpttIsSegregated,
      this.rcpttIsSegregatedDesc,
      this.rcpttAngkutanCatatan,
      this.rcpttKelembapan,
      this.rcpttSuhu,
      this.createdAt,
      this.updatedAt});

  GetTransport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcpttRcptId = json['rcptt_rcpt_id'];
    rcpttTransporterNo = json['rcptt_transporter_no'];
    rcpttPoliceNo = json['rcptt_police_no'];
    rcpttIsClean = json['rcptt_is_clean'];
    rcpttIsCleanDesc = json['rcptt_is_clean_desc'];
    rcpttIsDry = json['rcptt_is_dry'];
    rcpttIsDryDesc = json['rcptt_is_dry_desc'];
    rcpttIsNotSpilled = json['rcptt_is_not_spilled'];
    rcpttIsNotSpilledDesc = json['rcptt_is_not_spilled_desc'];
    rcpttIsPositionSingle = json['rcptt_is_position_single'];
    rcpttIsPositionSingleDesc = json['rcptt_is_position_single_desc'];
    rcpttIsSegregated = json['rcptt_is_segregated'];
    rcpttIsSegregatedDesc = json['rcptt_is_segregated_desc'];
    rcpttAngkutanCatatan = json['rcptt_angkutan_catatan'];
    rcpttKelembapan = json['rcptt_kelembapan'];
    rcpttSuhu = json['rcptt_suhu'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['rcptt_rcpt_id'] = rcpttRcptId;
    data['rcptt_transporter_no'] = rcpttTransporterNo;
    data['rcptt_police_no'] = rcpttPoliceNo;
    data['rcptt_is_clean'] = rcpttIsClean;
    data['rcptt_is_clean_desc'] = rcpttIsCleanDesc;
    data['rcptt_is_dry'] = rcpttIsDry;
    data['rcptt_is_dry_desc'] = rcpttIsDryDesc;
    data['rcptt_is_not_spilled'] = rcpttIsNotSpilled;
    data['rcptt_is_not_spilled_desc'] = rcpttIsNotSpilledDesc;
    data['rcptt_is_position_single'] = rcpttIsPositionSingle;
    data['rcptt_is_position_single_desc'] = rcpttIsPositionSingleDesc;
    data['rcptt_is_segregated'] = rcpttIsSegregated;
    data['rcptt_is_segregated_desc'] = rcpttIsSegregatedDesc;
    data['rcptt_angkutan_catatan'] = rcpttAngkutanCatatan;
    data['rcptt_kelembapan'] = rcpttKelembapan;
    data['rcptt_suhu'] = rcpttSuhu;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetHistoryApproval {
  int? id;
  int? apphistUserId;
  String? apphistPoDomain;
  String? apphistPoNbr;
  String? apphistStatus;
  String? apphistApprovedDate;
  String? createdAt;
  String? updatedAt;
  int? apphistReceiptId;

  GetHistoryApproval(
      {this.id,
      this.apphistUserId,
      this.apphistPoDomain,
      this.apphistPoNbr,
      this.apphistStatus,
      this.apphistApprovedDate,
      this.createdAt,
      this.updatedAt,
      this.apphistReceiptId});

  GetHistoryApproval.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apphistUserId = json['apphist_user_id'];
    apphistPoDomain = json['apphist_po_domain'];
    apphistPoNbr = json['apphist_po_nbr'];
    apphistStatus = json['apphist_status'];
    apphistApprovedDate = json['apphist_approved_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apphistReceiptId = json['apphist_receipt_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['apphist_user_id'] = apphistUserId;
    data['apphist_po_domain'] = apphistPoDomain;
    data['apphist_po_nbr'] = apphistPoNbr;
    data['apphist_status'] = apphistStatus;
    data['apphist_approved_date'] = apphistApprovedDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['apphist_receipt_id'] = apphistReceiptId;
    return data;
  }
}

class GetIsOngoinApproval {
  int? id;
  int? apphistUserId;
  String? apphistPoDomain;
  String? apphistPoNbr;
  String? apphistStatus;
  String? apphistApprovedDate;
  String? createdAt;
  String? updatedAt;
  int? apphistReceiptId;

  GetIsOngoinApproval(
      {this.id,
      this.apphistUserId,
      this.apphistPoDomain,
      this.apphistPoNbr,
      this.apphistStatus,
      this.apphistApprovedDate,
      this.createdAt,
      this.updatedAt,
      this.apphistReceiptId});

  GetIsOngoinApproval.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apphistUserId = json['apphist_user_id'];
    apphistPoDomain = json['apphist_po_domain'];
    apphistPoNbr = json['apphist_po_nbr'];
    apphistStatus = json['apphist_status'];
    apphistApprovedDate = json['apphist_approved_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apphistReceiptId = json['apphist_receipt_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['apphist_user_id'] = apphistUserId;
    data['apphist_po_domain'] = apphistPoDomain;
    data['apphist_po_nbr'] = apphistPoNbr;
    data['apphist_status'] = apphistStatus;
    data['apphist_approved_date'] = apphistApprovedDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['apphist_receipt_id'] = apphistReceiptId;
    return data;
  }
}

class GetDetail {
  int? id;
  int? rcptdRcptId;
  int? rcptdLine;
  String? rcptdPart;
  String? rcptdQtyArr;
  String? rcptdQtyAppr;
  String? rcptdQtyRej;
  String? rcptdLoc;
  String? rcptdLot;
  String? rcptdBatch;
  String? rcptdPartDesc;
  String? rcptdPartUm;
  String? createdAt;
  String? updatedAt;

  GetDetail(
      {this.id,
      this.rcptdRcptId,
      this.rcptdLine,
      this.rcptdPart,
      this.rcptdQtyArr,
      this.rcptdQtyAppr,
      this.rcptdQtyRej,
      this.rcptdLoc,
      this.rcptdLot,
      this.rcptdBatch,
      this.rcptdPartDesc,
      this.rcptdPartUm,
      this.createdAt,
      this.updatedAt});

  GetDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcptdRcptId = json['rcptd_rcpt_id'];
    rcptdLine = json['rcptd_line'];
    rcptdPart = json['rcptd_part'];
    rcptdQtyArr = json['rcptd_qty_arr'];
    rcptdQtyAppr = json['rcptd_qty_appr'];
    rcptdQtyRej = json['rcptd_qty_rej'];
    rcptdLoc = json['rcptd_loc'];
    rcptdLot = json['rcptd_lot'];
    rcptdBatch = json['rcptd_batch'];
    rcptdPartDesc = json['rcptd_part_desc'];
    rcptdPartUm = json['rcptd_part_um'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['rcptd_rcpt_id'] = rcptdRcptId;
    data['rcptd_line'] = rcptdLine;
    data['rcptd_part'] = rcptdPart;
    data['rcptd_qty_arr'] = rcptdQtyArr;
    data['rcptd_qty_appr'] = rcptdQtyAppr;
    data['rcptd_qty_rej'] = rcptdQtyRej;
    data['rcptd_loc'] = rcptdLoc;
    data['rcptd_lot'] = rcptdLot;
    data['rcptd_batch'] = rcptdBatch;
    data['rcptd_part_desc'] = rcptdPartDesc;
    data['rcptd_part_um'] = rcptdPartUm;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PoListApproval {
  int? id;
  int? apphistUserId;
  String? apphistPoDomain;
  String? apphistPoNbr;
  String? apphistStatus;
  String? apphistApprovedDate;
  String? createdAt;
  String? updatedAt;

  PoListApproval(
      {this.id,
      this.apphistUserId,
      this.apphistPoDomain,
      this.apphistPoNbr,
      this.apphistStatus,
      this.apphistApprovedDate,
      this.createdAt,
      this.updatedAt});

  PoListApproval.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apphistUserId = json['apphist_user_id'];
    apphistPoDomain = json['apphist_po_domain'];
    apphistPoNbr = json['apphist_po_nbr'];
    apphistStatus = json['apphist_status'];
    apphistApprovedDate = json['apphist_approved_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['apphist_user_id'] = apphistUserId;
    data['apphist_po_domain'] = apphistPoDomain;
    data['apphist_po_nbr'] = apphistPoNbr;
    data['apphist_status'] = apphistStatus;
    data['apphist_approved_date'] = apphistApprovedDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
