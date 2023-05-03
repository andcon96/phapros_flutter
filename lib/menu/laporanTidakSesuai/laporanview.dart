import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class laporanview extends StatefulWidget {
  final String ponbr,
      rcpt_nbr,
      rcpt_date,
      rcptd_part,
      rcptd_qty_arr,
      rcptd_lot,
      rcptd_loc,
      rcptd_qty_rej,
      rcptd_qty_appr,
      angkutan,
      nopol,
      supplier,
      no,
      komplain,
      keterangan,
      komplaindetail,
      tanggal,
      createdby;
  const laporanview({
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
    required this.angkutan,
    required this.nopol,
    required this.supplier,
    required this.no,
    required this.keterangan,
    required this.tanggal,
    required this.komplaindetail,
    required this.komplain ,
    required this.createdby,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _laporanview createState() => _laporanview();
}

class _laporanview extends State<laporanview> {
  int currentStep = 0;
  late TextEditingController IdRcp;
  late TextEditingController No;
  late TextEditingController Tanggal;
  late TextEditingController Supplier;
  late TextEditingController Komplain;
  late TextEditingController Keterangan;
  late TextEditingController NamaBarang;
  late TextEditingController TglMasuk;
  late TextEditingController JumlahMasuk;
  late TextEditingController KomplainDetail;
  late TextEditingController PO;
  late TextEditingController NomorLot;
  late TextEditingController Angkutan;
  late TextEditingController NoPol;
  late TextEditingController createdby;
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
    No = TextEditingController(text:widget.no);
    Tanggal = TextEditingController(text:widget.tanggal);
    Supplier = TextEditingController(
        text: widget.supplier != 'null' ? widget.supplier : '');
    Komplain = TextEditingController( text: widget.komplain);
    Keterangan = TextEditingController(text:widget.keterangan);
    KomplainDetail = TextEditingController(
        text: widget.rcptd_qty_rej != 'null' ? widget.rcptd_qty_rej : '');
    Angkutan = TextEditingController(
        text: widget.angkutan != 'null' ? widget.angkutan : '');
    NoPol =
        TextEditingController(text: widget.nopol != 'null' ? widget.nopol : '');
    createdby =
        TextEditingController(text: widget.createdby != 'null' ? widget.createdby : '');
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
                            'ID RCP',
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
                              'No',
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
                            No.text,
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
                            'Tanggal',
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
                            Tanggal.text,
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
                            'Komplain',
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
                            Komplain.text,
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
                            'Keterangan',
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
                            Keterangan.text,
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
                            'Nama Barang',
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
                            'Tanggal Masuk',
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
                            TglMasuk.text,
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
                            'Jumlah Masuk',
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
                            'Komplain',
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
                            KomplainDetail.text,
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
                            'PO',
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
                            'Nomor Lot',
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
                            'Angkutan',
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
                            Angkutan.text,
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
                            'Nomor Polisi',
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
                            NoPol.text,
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
                            'Created By',
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
                            createdby.text,
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
