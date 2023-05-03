import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_template/utils/loading.dart';

class laporanform extends StatefulWidget {
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
      supplier;
  const laporanform({
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
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _laporanform createState() => _laporanform();
}

class _laporanform extends State<laporanform> {
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
  String rcptnbr = '';
  late String responseresult = '';
  bool loading = false;
  Future<Object?> sendlaporan(String url) async {
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
    No = TextEditingController();
    Tanggal = TextEditingController();
    Supplier = TextEditingController(
        text: widget.supplier != 'null' ? widget.supplier : '');
    Komplain = TextEditingController();
    Keterangan = TextEditingController();
    KomplainDetail = TextEditingController(
        text: widget.rcptd_qty_rej != 'null' ? widget.rcptd_qty_rej : '');
    Angkutan = TextEditingController(
        text: widget.angkutan != 'null' ? widget.angkutan : '');
    NoPol =
        TextEditingController(text: widget.nopol != 'null' ? widget.nopol : '');
  }

  @override
  Widget build(BuildContext context) => loading
      ? const Loading()
      : Scaffold(
          body: Stepper(
            type: StepperType.vertical,
            steps: getSteps(),
            currentStep: currentStep,
            onStepTapped: (step) => setState(() => currentStep = step),
            onStepCancel: currentStep == 0
                ? null
                : () => setState(() => currentStep -= 1),
            onStepContinue: () {
              bool isLastStep = (currentStep == getSteps().length - 1);
              if (isLastStep) {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Colors.amber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                  'Are you sure you want to submit Receipt ' +
                                      IdRcp.text +
                                      '?',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue),
                                child: const Text(
                                    'Hold this button to continue',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                onPressed: () {},
                                onLongPress: () {
                                  String url =
                                      'http://192.168.18.195:8000/api/submitlaporan?';
                                  url += 'idrcpt=' + IdRcp.text;
                                  url += '&ponbr=' + PO.text;
                                  url += '&part=' + NamaBarang.text;
                                  url += '&tglmasuk=' + TglMasuk.text;
                                  url += '&jmlmasuk=' + JumlahMasuk.text;
                                  url += '&no=' + No.text;
                                  url += '&lot=' + NomorLot.text;
                                  url += '&tgl=' + Tanggal.text;
                                  url += '&supplier=' + Supplier.text;
                                  url += '&komplain=' + Komplain.text;
                                  url += '&keterangan=' + Keterangan.text;
                                  url +=
                                      '&komplaindetail=' + KomplainDetail.text;
                                  url += '&angkutan=' + Angkutan.text;
                                  url += '&nopol=' + NoPol.text;
                                  Navigator.pop(context);
                                  setState(() {
                                    loading = true;
                                  });

                                  final urlresponse = sendlaporan(url);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                setState(() => currentStep += 1);
              }
            },
            controlsBuilder: (context, ControlsDetails controls) {
              final isLastStep = currentStep == getSteps().length - 1;

              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(children: [
                  if (currentStep != 0)
                    Expanded(
                      child: ElevatedButton(
                        child: Text('BACK'),
                        onPressed: controls.onStepCancel,
                      ),
                    ),
                  if (currentStep != 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                      onPressed: controls.onStepContinue,
                    ),
                  ),
                ]),
              );
            },
          ),
        );
  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Data RCP'),
          content: Column(
            children: <Widget>[
              TextFormField(
                // controller: null,
                controller: IdRcp,
                decoration: InputDecoration(labelText: 'ID RCP'),
                // initialValue: widget.rcpt_nbr,
                readOnly: true,
              ),
              TextFormField(
                controller: No,
                decoration: InputDecoration(labelText: 'No'),
              ),
              TextFormField(
                controller: Tanggal,
                decoration: InputDecoration(labelText: 'Tanggal'),
                // initialValue: DateTime.parse(widget.rcpt_date).toString(),
                readOnly: true,
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: Tanggal != ''
                          ? DateTime.parse(widget.rcpt_date)
                          : DateTime.now(),
                      firstDate: DateTime(2000, 1),
                      lastDate: DateTime(2100, 12),
                      builder: (context, picker) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue.shade400,
                            ),
                            // textButtonTheme: TextButtonThemeData(
                            //   style: TextButton.styleFrom(
                            //     textStyle: TextStyle(color: Colors.white)
                            //   )
                            // ),
                            // dialogBackgroundColor: Colors.white
                          ),
                          child: picker!,
                        );
                      }).then((selectedDate) {
                    if (selectedDate != null) {
                      Tanggal.text = DateFormat('yyyy-MM-dd')
                          .format(selectedDate)
                          .toString();
                    }
                  });
                },
              ),
              TextFormField(
                controller: Supplier,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Supplier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: Komplain,
                decoration: InputDecoration(labelText: 'Komplain'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: Keterangan,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Detail'),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: NamaBarang,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Nama Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TglMasuk,
                decoration: InputDecoration(labelText: 'Tgl Masuk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
                readOnly: true,
              ),
              TextFormField(
                controller: JumlahMasuk,
                decoration: InputDecoration(labelText: 'Jumlah Masuk'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some quantity';
                  }
                  return null;
                },
                readOnly: true,
              ),
              TextFormField(
                controller: KomplainDetail,
                decoration: InputDecoration(labelText: 'Komplain'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                readOnly: true,
              ),
              TextFormField(
                controller: PO,
                decoration: InputDecoration(labelText: 'PO'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                readOnly: true,
              ),
              TextFormField(
                controller: NomorLot,
                decoration: InputDecoration(labelText: 'No Lot'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                readOnly: true,
              ),
              TextFormField(
                controller: Angkutan,
                decoration: InputDecoration(labelText: 'Angkutan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                readOnly: true,
              ),
              TextFormField(
                controller: NoPol,
                decoration: InputDecoration(labelText: 'No Pol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                readOnly: true,
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('Complete'),
          content: Column(children: <Widget>[
            Table(
                border: TableBorder.all(color: Colors.transparent),
                children: [
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'ID RCP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        IdRcp.text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                        height: 50,
                        child: Text(
                          'No',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        )),
                    Container(
                      height: 50,
                      child: Text(
                        No.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Tanggal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Tanggal.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Supplier',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Supplier.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Komplain',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Komplain.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Keterangan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Keterangan.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Nama Barang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        NamaBarang.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Tanggal Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        TglMasuk.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Jumlah Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        JumlahMasuk.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Komplain',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        KomplainDetail.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'PO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        PO.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Nomor Lot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        NomorLot.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Angkutan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Angkutan.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: Text(
                        'Nomor Polisi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        NoPol.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                ])
          ]),
        ),
      ];
}
