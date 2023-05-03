import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class receiptview extends StatefulWidget {
  final String ponbr,
      rcpt_nbr,
      rcpt_date,
      rcptd_part,
      rcptd_qty_arr,
      rcptd_lot,
      rcptd_loc,
      rcptd_qty_rej,
      rcptd_qty_appr,
      supplier,
      batch,
      shipto,
      domain,
      status,
      approver;
  const receiptview({
    Key? key,
    required this.ponbr,
    required this.rcpt_nbr,
    required this.rcpt_date,
    required this.rcptd_part,
    required this.rcptd_qty_arr,
    required this.rcptd_lot,
    required this.rcptd_loc,
    required this.rcptd_qty_appr,
    required this.rcptd_qty_rej,
    required this.supplier,
    required this.batch,
    required this.shipto,    
    required this.domain,
    required this.status,
    required this.approver,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _receiptview createState() => _receiptview();
}

class _receiptview extends State<receiptview> {
  int currentStep = 0;
  late TextEditingController IdRcp;
  late TextEditingController Batch;
  late TextEditingController Shipto;
  late TextEditingController Supplier;
  late TextEditingController Loc;
  late TextEditingController JumlahApprove;
  late TextEditingController JumlahReject;
  late TextEditingController lastapproval;
  late TextEditingController NamaBarang;
  late TextEditingController TglMasuk;
  late TextEditingController JumlahMasuk;
  late TextEditingController nextapproval;
  late TextEditingController PO;
  late TextEditingController NomorLot;
  late TextEditingController domain;
  late TextEditingController approver;
  late TextEditingController status;

  String rcptnbr = '';
  late String responseresult = '';



  void initState() {
    super.initState();
    
    IdRcp = TextEditingController(text: widget.rcpt_nbr);
    NamaBarang = TextEditingController(
        text: widget.rcptd_part != 'null' ? widget.rcptd_part : '');
    TglMasuk = TextEditingController(text: widget.rcpt_date);
    JumlahMasuk = TextEditingController(
        text: widget.rcptd_qty_arr != 'null' ? widget.rcptd_qty_arr : '');
    PO = TextEditingController(text: widget.ponbr);
    NomorLot = TextEditingController(text: widget.rcptd_lot);
    Shipto = TextEditingController(text: widget.shipto);
    Batch = TextEditingController(text: widget.batch);
    Supplier = TextEditingController(text: widget.supplier);
    Loc = TextEditingController(text: widget.rcptd_loc);
    JumlahApprove = TextEditingController(text: widget.rcptd_qty_appr);
    JumlahReject = TextEditingController(text: widget.rcptd_qty_rej);
    domain = TextEditingController(text: widget.domain);
    status = TextEditingController(text: widget.status);
    approver = TextEditingController(text: widget.approver);
   
  }
  @override
  Widget build(BuildContext context) => Scaffold(
          body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Table(
                    border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                    children: [
                      TableRow(children: [
                        TableCell(
                          
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                            'Rcpt Nbr',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                                
                          ),
                        ),
                        ),
                        TableCell(
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            IdRcp.text,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                            
                            child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Po Nbr',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            )),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            PO.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Shipto',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Shipto.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Supplier',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Supplier.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Part',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            NamaBarang.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Lot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            NomorLot.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Batch',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Batch.text,
                            style: TextStyle(fontSize: 16),
                          ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Loc.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Qty Arrive',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            JumlahMasuk.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Qty Approved',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            JumlahApprove.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Qty Reject',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            JumlahReject.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            status.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Approved By',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            approver.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                    ])
              ]),
            ),
          )
        ],
      ));
}

