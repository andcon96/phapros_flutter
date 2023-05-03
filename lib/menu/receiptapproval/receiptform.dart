import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_template/utils/loading.dart';
import 'package:flutter_template/utils/secure_user_login.dart';

class receiptform extends StatefulWidget {
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
      domain;
  const receiptform(
      {Key? key,
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
      required this.domain})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _receiptform createState() => _receiptform();
}

class _receiptform extends State<receiptform> {
  bool loading = false;
  Future<Object?> sendlaporan(String url) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    url += '&userid=' + id.toString();

    final response = await http.post(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      setState(() {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Failed to load data"));
      });
      return http.Response('Error', 500);
    });
    responseresult = response.body.toString();

    if (response.body == 'approve success') {
      Navigator.pop(context, 'refresh');
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              title: "Success",
              text: "Success to Approve receipt " + IdRcp.text));
    } else if (response.body == 'approve failed') {
      Navigator.pop(context, 'refresh');
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Approve receipt" + IdRcp.text));
    } else if (response.body == 'reject success') {
      Navigator.pop(context, 'refresh');
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              title: "Success",
              text: "Success to Reject receipt " + IdRcp.text));
    } else if (response.body == 'approve failed') {
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Reject receipt" + IdRcp.text));
    }
    ;

    return response;
  }

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

  String rcptnbr = '';
  late String responseresult = '';

  Future<Object?> approvereject(String url) async {
    final token = await UserSecureStorage.getToken();
    final response = await http.post(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      setState(() {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Failed to load data"));
      });
      return http.Response('Error', 500);
    });
    responseresult = response.body.toString();

    if (response.body == 'success') {
      Navigator.pop(context, 'refresh');
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              title: "Success",
              text: "Success to Submit report for receipt " + IdRcp.text));
    } else if (response.body == 'error') {
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Submit report for receipt" + IdRcp.text));
    }
    ;
    return response;
  }

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
  }

  @override
  Widget build(BuildContext context) => loading
      ? const Loading()
      : Scaffold(
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
                          border: TableBorder(
                              horizontalInside: BorderSide(
                                  width: 1,
                                  color: Colors.blue,
                                  style: BorderStyle.solid)),
                          children: [
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Rcpt Nbr',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    IdRcp.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                height: 50,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Po Nbr',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Shipto',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Supplier',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Part',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Lot',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Batch',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Location',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Qty Arrive',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Qty Approved',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Qty Reject',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    JumlahReject.text,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ]),
                          ]),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              child: Text('Deny'),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        color: Colors.red,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  'Are you sure you want to approve Receipt ' +
                                                      IdRcp.text +
                                                      '?',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black)),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white),
                                                child: const Text(
                                                    'Hold this button to continue',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black)),
                                                onPressed: () {},
                                                onLongPress: () {
                                                  String url =
                                                      'http://192.168.0.3:26077/api/rejectreceipt?';
                                                  url += 'idrcpt=' + IdRcp.text;

                                                  Navigator.pop(context);
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  final urlresponse =
                                                      sendlaporan(url);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              child: Text('Approve'),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        color: Colors.blue,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  'Are you sure you want to approve Receipt ' +
                                                      IdRcp.text +
                                                      '?',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white)),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.black),
                                                child: const Text(
                                                    'Hold this button to continue'),
                                                onPressed: () {},
                                                onLongPress: () {
                                                  String url =
                                                      'http://192.168.0.3:26077/api/approvereceipt?';
                                                  url += 'idrcpt=' + IdRcp.text;

                                                  Navigator.pop(context);
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  final urlresponse =
                                                      sendlaporan(url);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ]),
                      ),
                    ]),
              ),
            )
          ],
        ));
}
