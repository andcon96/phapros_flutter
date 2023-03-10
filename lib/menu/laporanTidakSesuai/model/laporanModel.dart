import 'package:flutter/material.dart';


class laporanModel{
  String? ponbr, rcpt_nbr, rcpt_date, rcptd_part, rcptd_qty_arr, rcptd_lot, rcptd_loc;

  laporanModel({
    required this.ponbr, 
    required this.rcpt_nbr, 
    required this.rcpt_date, 
    required this.rcptd_part, 
    required this.rcptd_qty_arr,
    required this.rcptd_loc,
    required this.rcptd_lot 
  });

  factory laporanModel.fromJson(Map<String, dynamic> json){
    
    return laporanModel(
      ponbr: json['rcpt_po_id'],
      rcpt_nbr: json['rcpt_nbr'],
      rcpt_date: json['rcpt_date'],
      rcptd_part: json['rcptd_part'],
      rcptd_loc: json['rcptd_loc'],
      rcptd_qty_arr: json['rcptd_qty_arr'],
      rcptd_lot: json['rcptd_lot'],
    );
  }
}