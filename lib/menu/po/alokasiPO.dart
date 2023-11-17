// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/menu/po/uploadFilePO.dart';
// import 'package:flutter_template/menu/po/uploadFilePOold.dart';
import 'package:flutter_template/menu/po/wsaPO.dart';
import 'package:flutter_template/menu/po/model/wsaPoModel.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;
import '../../utils/loading.dart';
import '../../utils/secure_user_login.dart';
import '../../utils/styles.dart';

// Drop Down
class DetailPO extends StatefulWidget {
  Data cartItem;
  List<Data> ListDetailPO;
  List<Data> listLine;
  bool isSaved;

  DetailPO(
      {required this.cartItem,
      required this.ListDetailPO,
      required this.listLine,
      required this.isSaved});
  @override
  _DetailPOState createState() => _DetailPOState();
}

class _DetailPOState extends State<DetailPO> {
  String _value = "";
  final _um = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = widget.cartItem.tLviLine!;
    _um.text = widget.listLine[0].tLvcUm.toString();
    widget.cartItem.tLvcUm = widget.listLine[0].tLvcUm.toString();
  }

  @override
  void didUpdateWidget(DetailPO oldWidget) {
    if (oldWidget.cartItem.tLviLine != widget.cartItem.tLviLine) {
      _value = widget.cartItem.tLviLine!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
              color: Color.fromARGB(255, 157, 154, 154),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: DropdownButtonHideUnderline(
              child: IgnorePointer(
            ignoring: widget.isSaved,
            child: DropdownButton(
                itemHeight: 60,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Select Line',
                        border: InputBorder.none,
                        labelText: 'Select Line'),
                  ),
                ),
                value: _value,
                // ignore: prefer_const_literals_to_create_immutables
                items: widget.listLine.map((value) {
                  return DropdownMenuItem(
                      value: value.tLviLine.toString(),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                              "${value.tLviLine}  - ${value.tLvcPart} - ${value.tLvcPartDesc}"),
                        ),
                      ));
                }).toList(),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (value) {
                  setState(() {
                    _value = value!;
                    widget.cartItem.tLviLine = value;

                    var selecteddata = widget.listLine
                        .where((line) => line.tLviLine == value)
                        .toList();

                    widget.cartItem.tLvcUm = selecteddata[0].tLvcUm.toString();

                    widget.cartItem.tLvdQtyord =
                        selecteddata[0].tLvdQtyord.toString();

                    widget.cartItem.tLvdQtyRcvd =
                        selecteddata[0].tLvdQtyRcvd.toString();

                    _um.text = selecteddata[0].tLvcUm.toString();
                  });
                }),
          )),
        ),
        // ignore: prefer_const_constructors
        SizedBox(
          height: 8,
        ),
        TextField(
          controller: _um,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'UM',
          ),
        )
      ],
    );
  }
}

// Dropdown Lokasi
class DropdownLocation extends StatefulWidget {
  Data cartItem;
  List<dynamic> listLocation;
  bool isSaved;
  DropdownLocation(
      {required this.cartItem,
      required this.listLocation,
      required this.isSaved});
  @override
  _DropdownLocationState createState() => _DropdownLocationState();
}

class _DropdownLocationState extends State<DropdownLocation> {
  String dropdownValue = '';
  List<dynamic> listLocation = [];
  bool _isInitial = false;

  @override
  void initState() {
    super.initState();
    if (!_isInitial) {
      // dropdownValue = widget.listLocation[0]['t_site_loc'] ?? '';
      dropdownValue = widget.cartItem.tLvcLoc ?? '';
      _isInitial = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromARGB(255, 157, 154, 154),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: IgnorePointer(
              ignoring: widget.isSaved,
              child: DropdownButton(
                  itemHeight: 60,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Select Location',
                          border: InputBorder.none,
                          labelText: 'Select Location'),
                    ),
                  ),
                  value: dropdownValue,
                  // ignore: prefer_const_literals_to_create_immutables
                  items: widget.listLocation.map((value) {
                    return DropdownMenuItem(
                        value: "${value['t_site_loc']}".toString(),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("${value['t_loc_desc']}"),
                          ),
                        ));
                  }).toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value ?? '';
                      widget.cartItem.tLvcLoc = value;
                    });
                  })),
        ));
  }
}

// Card + Panggil Drop Down
class CartWidget extends StatefulWidget {
  List<Data> cart;
  List<dynamic> listLocation;
  int index;
  VoidCallback callback;
  List<Data> listLine;

  CartWidget(
      {required this.cart,
      required this.listLocation,
      required this.index,
      required this.listLine,
      required this.callback});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  TextEditingController batch = TextEditingController();
  TextEditingController lokasi = TextEditingController();
  TextEditingController lot = TextEditingController();
  TextEditingController qtydatang = TextEditingController();
  TextEditingController qtyterima = TextEditingController();
  TextEditingController qtyreject = TextEditingController();
  TextEditingController qtyper = TextEditingController();
  TextEditingController expdetdate = TextEditingController();
  TextEditingController manudetdate = TextEditingController();
  DateTime selectedExpDate = DateTime.now();
  DateTime selectedManuDate = DateTime.now();
  int _sum = 0;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    // Expiration Date
    final dataexpdet = widget.cart[widget.index].tLvcExpDetailDate;
    late String? newexpdet;

    if (dataexpdet != null && dataexpdet.isNotEmpty) {
      newexpdet = widget.cart[widget.index].tLvcExpDetailDate;
    } else {
      newexpdet = DateFormat('yyyy-MM-dd').format(now).toString();
    }
    expdetdate.text = newexpdet!;
    selectedExpDate = DateTime.parse(newexpdet);

    // Manufacturer Date
    final datamanudet = widget.cart[widget.index].tLvcManuDetailDate;
    late String? newmanudate;

    if (datamanudet != null && datamanudet.isNotEmpty) {
      newmanudate = widget.cart[widget.index].tLvcManuDetailDate;
    } else {
      newmanudate = DateFormat('yyyy-MM-dd').format(now).toString();
    }
    manudetdate.text = newmanudate!;
    selectedManuDate = DateTime.parse(newmanudate);

    // Assign Ulang Value kalo gagal / back + Tambah Lot 19 Jun 23
    var datalot = widget.cart[widget.index].tIMRNo.toString().substring(3, 13);
    if (widget.index > 0) {
      var newlot = String.fromCharCode(widget.index + 64);
      datalot = '$datalot$newlot';
    }

    batch.text = widget.cart[widget.index].tLvcBatch == null
        ? ''
        : widget.cart[widget.index].tLvcBatch.toString();
    lokasi.text = widget.cart[widget.index].tLvcLoc == null
        ? ''
        : widget.cart[widget.index].tLvcLoc.toString();
    lot.text = widget.cart[widget.index].tLvcLot == null
        ? datalot
        : widget.cart[widget.index].tLvcLot.toString();
    qtyper.text = widget.cart[widget.index].tlvdQtyPerPackage == null
        ? ''
        : widget.cart[widget.index].tlvdQtyPerPackage.toString();
    qtydatang.text = widget.cart[widget.index].tLvdQtyDatang == null
        ? ''
        : widget.cart[widget.index].tLvdQtyDatang.toString();
    qtyterima.text = widget.cart[widget.index].tLvdQtyTerima == null
        ? '0'
        : widget.cart[widget.index].tLvdQtyTerima.toString();
    qtyreject.text = widget.cart[widget.index].tLvdQtyReject == null
        ? ''
        : widget.cart[widget.index].tLvdQtyReject.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: 830,
          width: double.maxFinite,
          child: Card(
            elevation: 5,
            child: Column(children: [
              // Detailpo(cartItem: sel_detail),
              DetailPO(
                listLine: widget.listLine,
                cartItem: widget.cart[widget.index],
                ListDetailPO: widget.cart,
                isSaved: widget.cart[widget.index].tIsSaved!,
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                  readOnly: widget.cart[widget.index].tIsSaved!,
                  controller: batch,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Batch / Lot',
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(top: 14, left: 28),
                      child: Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 24.0),
                      ),
                    ),
                  )),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              // TextField(
              //   readOnly: widget.cart[widget.index].tIsSaved!,
              //   controller: lokasi,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Location',
              //   ),
              // ),
              DropdownLocation(
                cartItem: widget.cart[widget.index],
                listLocation: widget.listLocation,
                isSaved: widget.cart[widget.index].tIsSaved!,
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: widget.cart[widget.index].tIsSaved!,
                controller: lot,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lot',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                  controller: manudetdate,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_rounded),
                      onPressed: () async {
                        final DateTime? pickedManu = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                          initialDate: selectedManuDate,
                        );
                        if (pickedManu != null &&
                            pickedManu != selectedManuDate) {
                          setState(() {
                            selectedManuDate = pickedManu;
                          });
                          manudetdate.text =
                              DateFormat('yyyy-MM-dd').format(selectedManuDate);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Tanggal Production',
                  )),
              SizedBox(
                height: 8,
              ),
              TextField(
                  controller: expdetdate,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_rounded),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                          initialDate: selectedExpDate,
                        );
                        if (picked != null && picked != selectedExpDate) {
                          setState(() {
                            selectedExpDate = picked;
                          });
                          expdetdate.text =
                              DateFormat('yyyy-MM-dd').format(selectedExpDate);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Tanggal Kadarluasa',
                  )),

              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: widget.cart[widget.index].tIsSaved!,
                controller: qtyper,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Per Package',
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(top: 14, left: 28),
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 24.0),
                    ),
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: widget.cart[widget.index].tIsSaved!,
                controller: qtydatang,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Datang',
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(top: 14, left: 28),
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 24.0),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _sum = (int.tryParse(value) ?? 0) -
                        (int.tryParse(qtyreject.text) ?? 0);
                    qtyterima.text = _sum.toString();
                  });
                },
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: widget.cart[widget.index].tIsSaved!,
                controller: qtyreject,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Reject',
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(top: 14, left: 28),
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 24.0),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _sum = (int.tryParse(qtydatang.text) ?? 0) -
                        (int.tryParse(value) ?? 0);
                    qtyterima.text = _sum.toString();
                  });
                },
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: true,
                controller: qtyterima,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Terima',
                ),
              ),
              Row(
                children: [
                  if (!widget.cart[widget.index].tIsSaved!)
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              // print(widget.cart[widget.index].tLvcLoc);
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                text: 'Save Row ?',
                                confirmBtnText: 'Yes',
                                cancelBtnText: 'No',
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: () {
                                  if (expdetdate.text.isEmpty) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text:
                                            'Expiration Date tidak boleh kosong',
                                        title: 'Error');
                                    return;
                                  }
                                  if (manudetdate.text.isEmpty) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text:
                                            'Production Date tidak boleh kosong',
                                        title: 'Error');
                                    return;
                                  }
                                  if (batch.text.isEmpty) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'Batch tidak boleh kosong',
                                        title: 'Error');
                                    return;
                                  }
                                  if (qtydatang.text.isEmpty) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'Qty Datang tidak boleh kosong',
                                        title: 'Error');
                                    return;
                                  }
                                  if (qtyreject.text.isEmpty) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'Qty Reject tidak boleh kosong',
                                        title: 'Error');
                                    return;
                                  }
                                  if (qtyterima.text.isEmpty) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'Qty Terima tidak boleh kosong',
                                        title: 'Error');
                                    return;
                                  }
                                  var qtyrcvd =
                                      widget.cart[widget.index].tLvdQtyRcvd ??
                                          '0.00';
                                  var qtyord =
                                      widget.cart[widget.index].tLvdQtyord ??
                                          '0.00';

                                  var qtyopen = double.parse(qtyord) -
                                      double.parse(qtyrcvd);

                                  var line = widget.cart[widget.index].tLviLine;
                                  var totalterima = 0.00;

                                  widget.cart.forEach((element) {
                                    if (element.tLviLine == line) {
                                      var qtyterimaline =
                                          element.tLvdQtyTerima ??
                                              qtyterima.text;
                                      totalterima +=
                                          double.parse(qtyterimaline);
                                    }
                                  });
                                  // print(qtyopen);
                                  // print(totalterima);
                                  if (qtyopen < totalterima) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text:
                                            'Jumlah Qty Terima Line : ${widget.cart[widget.index].tLviLine!}, Melebihi Qty Open',
                                        title: 'Error');
                                    return;
                                  }

                                  widget.cart[widget.index].tLvcBatch =
                                      batch.text;
                                  // widget.cart[widget.index].tLvcLoc =
                                  //     lokasi.text;
                                  widget.cart[widget.index].tLvcLot = lot.text;
                                  widget.cart[widget.index].tLvdQtyDatang =
                                      qtydatang.text;
                                  widget.cart[widget.index].tLvdQtyReject =
                                      qtyreject.text;
                                  widget.cart[widget.index].tLvdQtyTerima =
                                      qtyterima.text;
                                  widget.cart[widget.index].tlvdQtyPerPackage =
                                      qtyper.text;
                                  widget.cart[widget.index].tLvcExpDetailDate =
                                      expdetdate.text;
                                  widget.cart[widget.index].tLvcManuDetailDate =
                                      manudetdate.text;
                                  widget.cart[widget.index].tIsSaved = true;
                                  widget.callback();

                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              );
                            });
                          },
                        )),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              text: 'Remove Row ?',
                              confirmBtnText: 'Yes',
                              cancelBtnText: 'No',
                              confirmBtnColor: Colors.green,
                              onConfirmBtnTap: () {
                                widget.cart.removeAt(widget.index);
                                widget.callback();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            );
                          });
                        },
                      )),
                ],
              )
            ]),
          )),
    );
  }
}

// State Utama
class alokasipo extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  alokasipo(
      {Key? key,
      required this.selectedline,
      required this.listLocation,
      required this.imrno,
      required this.arrivaldate,
      required this.imrdate,
      required this.dono,
      required this.articleno,
      required this.proddate,
      required this.expdate,
      required this.manufacturer,
      required this.origincountry,
      required this.certificateChecked,
      required this.certificate,
      required this.msdsChecked,
      required this.msds,
      required this.forwarderdoChecked,
      required this.forwaderdo,
      required this.packinglistChecked,
      required this.packinglist,
      required this.otherdocsChecked,
      required this.otherdocs,
      required this.keteranganisclean,
      required this.keteranganisdry,
      required this.keteranganisnotspilled,
      required this.transporterno,
      required this.policeno,
      required this.angkutanketeranganisclean,
      required this.angkutanketeranganisdry,
      required this.angkutanketeranganisnotspilled,
      required this.angkutanketeranganissingle,
      required this.sackordosChecked,
      required this.sackordosDamage,
      required this.drumorvatChecked,
      required this.drumorvatDamage,
      required this.palletorpetiChecked,
      required this.palletorpetiDamage,
      required this.isclean,
      required this.isdry,
      required this.isnotspilled,
      required this.issealed,
      required this.ismanufacturerlabel,
      required this.angkutanisclean,
      required this.angkutanisdry,
      required this.angkutanisnotspilled,
      required this.angkutanissingle,
      required this.angkutansegregate,
      required this.angkutanketeranganissegregated,
      required this.angkutancatatan,
      required this.kelembapan,
      required this.suhu,
      required this.itemcode})
      : super(key: key);

  final List<Data> selectedline;
  final List<dynamic> listLocation;
  final String imrno;
  final String arrivaldate;
  final String imrdate;
  final String dono;
  final String articleno;
  final String proddate;
  final String expdate;
  final String manufacturer;
  final String origincountry;
  final bool certificateChecked;
  final String certificate;
  final bool msdsChecked;
  final String msds;
  final bool forwarderdoChecked;
  final String forwaderdo;
  final bool packinglistChecked;
  final String packinglist;
  final bool otherdocsChecked;
  final String otherdocs;

  final String isclean;
  final String keteranganisclean;

  final String isdry;
  final String keteranganisdry;

  final String isnotspilled;
  final String keteranganisnotspilled;

  final String issealed;
  final String ismanufacturerlabel;

  final String transporterno;
  final String policeno;

  final String angkutanisclean;
  final String angkutanketeranganisclean;

  final String angkutanisdry;
  final String angkutanketeranganisdry;

  final String angkutanisnotspilled;
  final String angkutanketeranganisnotspilled;

  final String angkutanissingle;
  final String angkutanketeranganissingle;

  final String angkutansegregate;
  final String angkutanketeranganissegregated;
  final String angkutancatatan;
  final String kelembapan;
  final String suhu;
  final String itemcode;

  final bool sackordosChecked;
  final bool drumorvatChecked;
  final bool palletorpetiChecked;
  final String sackordosDamage;
  final String drumorvatDamage;
  final String palletorpetiDamage;

  @override
  _alokasipoState createState() => _alokasipoState();
}

class _alokasipoState extends State<alokasipo> {
  List<Data> cart = [];
  List<dynamic> listLocation = [];
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    listLocation = widget.listLocation;
  }

  Future saveData() async {
    try {
      final nik = await UserSecureStorage.getUsername();
      final token = await UserSecureStorage.getToken();
      final idanggota = await UserSecureStorage.getIdAnggota();

      final Uri url = Uri.parse('${globals.globalurl}/savepo');

      final body = {
        "data": cart,
        "nik": nik,
        "id_anggota": idanggota,

        // Checklist
        "imrno": widget.imrno,
        "dono": widget.dono,
        "articleno": widget.articleno,
        "arrivaldate": widget.arrivaldate,
        "imrdate": widget.imrdate,
        "productiondate": widget.proddate,
        "expiredate": widget.expdate,
        "manufacturer": widget.manufacturer,
        "country": widget.origincountry,

        // Kelengkapan Dokumen
        "is_certofanalys": widget.certificateChecked,
        "certofanalys": widget.certificate,
        "is_msds": widget.msdsChecked,
        "msds": widget.msds,
        "is_forwarderdo": widget.forwarderdoChecked,
        "forwarderdo": widget.forwaderdo,
        "is_packinglist": widget.packinglistChecked,
        "packinglist": widget.packinglist,
        "is_otherdocs": widget.otherdocsChecked,
        "otherdocs": widget.otherdocs,

        // Kemasan
        "kemasan_sacdos": widget.sackordosChecked,
        "is_damage_kemasan_sacdos": widget.sackordosDamage,
        "kemasan_drumvat": widget.drumorvatChecked,
        "is_damage_kemasan_drumvat": widget.drumorvatDamage,
        "kemasan_palletpeti": widget.palletorpetiChecked,
        "is_damage_kemasan_palletpeti": widget.palletorpetiDamage,

        "is_clean": widget.isclean,
        "keterangan_is_clean": widget.keteranganisclean,
        "is_dry": widget.isdry,
        "keterangan_is_dry": widget.keteranganisdry,
        "is_not_spilled": widget.isnotspilled,
        "keterangan_is_not_spilled": widget.keteranganisnotspilled,

        "is_sealed": widget.issealed,
        "is_manufacturer_label": widget.ismanufacturerlabel,
        // Kondisi
        "transporter_no": widget.transporterno,
        "police_no": widget.policeno,

        "is_clean_angkutan": widget.angkutanisclean,
        "keterangan_is_clean_angkutan": widget.angkutanketeranganisclean,
        "is_dry_angkutan": widget.angkutanisdry,
        "keterangan_is_dry_angkutan": widget.angkutanketeranganisdry,
        "is_not_spilled_angkutan": widget.angkutanisnotspilled,
        "keterangan_is_not_spilled_angkutan":
            widget.angkutanketeranganisnotspilled,

        "material_position": widget.angkutanissingle,
        "keterangan_material_position": widget.angkutanketeranganissingle,

        "is_segregated": widget.angkutansegregate,
        "keterangan_is_segregated": widget.angkutanketeranganissegregated,
      };

      final response = await http
          .post(url,
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: "Bearer $token"
              },
              body: jsonEncode(body))
          .timeout(const Duration(milliseconds: 5000), onTimeout: () {
        setState(() {
          loading = false;
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: 'Error',
            text: 'Connection Timeout',
            loopAnimation: false,
          );
        });
        return http.Response('Error', 500);
      });

      if (response.statusCode == 200) {
        // final result = response.body;
        setState(() {
          loading = false;
        });

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => wsaPO(),
            ),
            (route) => route.isFirst);

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: 'Sukses',
          text: 'Data berhasil dikrim',
          loopAnimation: false,
        );
        return true;
      } else {
        setState(() {
          loading = false;
          // print(cart);
          // print(cart[0].tLvcBatch);
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Error',
          text: 'Terdapat Error pada API',
          loopAnimation: false,
        );
        return false;
      }
    } on Exception catch (e) {
      setState(() {
        loading = false;
      });
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Error',
        text: 'Tidak Ada Internet',
        loopAnimation: false,
      );
      return false;
    }
  }

  Widget addbtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: FloatingActionButton(
        onPressed: () {
          cart.add(Data(
              tLvcNbr: widget.selectedline[0].tLvcNbr,
              tLvcDomain: widget.selectedline[0].tLvcDomain,
              tLvcShip: widget.selectedline[0].tLvcShip,
              tLvcSite: widget.selectedline[0].tLvcSite,
              tLvcVend: widget.selectedline[0].tLvcVend,
              tLvtOrd: widget.selectedline[0].tLvtOrd,
              tLvtDue: widget.selectedline[0].tLvtDue,
              tLvcCurr: widget.selectedline[0].tLvcCurr,
              tLviLine: widget.selectedline[0].tLviLine,
              tLvcPart: widget.selectedline[0].tLvcPart,
              tLvdQtyord: widget.selectedline[0].tLvdQtyord,
              tLvdQtyRcvd: widget.selectedline[0].tLvdQtyRcvd,
              tLvcPartDesc: widget.selectedline[0].tLvcPartDesc,
              tLvcLoc: widget.listLocation[0]['t_site_loc'],
              tLvcExpDetailDate: widget.expdate,
              tLvcManuDetailDate: widget.proddate,
              tIMRNo: widget.imrno,
              tIsSaved: false));
          setState(() {});
        },
        heroTag: "addbtn",
        tooltip: 'Tambah Data',
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget confirmbtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: FloatingActionButton(
        onPressed: () {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.confirm,
            text: 'Pastikan Data Sesuai, Akan Lanjut ke Menu Upload File ?',
            confirmBtnText: 'Yes',
            cancelBtnText: 'No',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: () {
              var flg = 0;
              Navigator.of(context, rootNavigator: true).pop();
              if (cart.isEmpty) {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: 'Data tidak boleh kosong',
                    title: 'Error');
                return;
              }

              for (var element in cart) {
                if (element.tLvdQtyTerima == null) {
                  flg = 1;
                }
              }

              if (flg == 1) {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: 'Data ada yang belum disave',
                    title: 'Error');
                return;
              }

              setState(() {
                // loading = true;
              });

              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => uploadfilepo(
                        cart: cart,
                        selectedline: widget.selectedline,
                        imrno: widget.imrno,
                        arrivaldate: widget.arrivaldate,
                        imrdate: widget.imrdate,
                        dono: widget.dono,
                        articleno: widget.articleno,
                        proddate: widget.proddate,
                        expdate: widget.expdate,
                        manufacturer: widget.manufacturer,
                        origincountry: widget.origincountry,
                        certificateChecked: widget.certificateChecked,
                        certificate: widget.certificate,
                        msdsChecked: widget.msdsChecked,
                        msds: widget.msds,
                        forwarderdoChecked: widget.forwarderdoChecked,
                        forwaderdo: widget.forwaderdo,
                        packinglistChecked: widget.packinglistChecked,
                        packinglist: widget.packinglist,
                        otherdocsChecked: widget.otherdocsChecked,
                        otherdocs: widget.otherdocs,
                        keteranganisclean: widget.keteranganisclean,
                        keteranganisdry: widget.keteranganisdry,
                        keteranganisnotspilled: widget.keteranganisnotspilled,
                        transporterno: widget.transporterno,
                        policeno: widget.policeno,
                        angkutanketeranganisclean:
                            widget.angkutanketeranganisclean,
                        angkutanketeranganisdry: widget.angkutanketeranganisdry,
                        angkutanketeranganisnotspilled:
                            widget.angkutanketeranganisnotspilled,
                        angkutanketeranganissingle:
                            widget.angkutanketeranganissingle,
                        angkutanketeranganissegregated:
                            widget.angkutanketeranganissegregated,
                        sackordosChecked: widget.sackordosChecked,
                        sackordosDamage: widget.sackordosDamage.toString(),
                        drumorvatChecked: widget.drumorvatChecked,
                        drumorvatDamage: widget.drumorvatDamage.toString(),
                        palletorpetiChecked: widget.palletorpetiChecked,
                        palletorpetiDamage:
                            widget.palletorpetiDamage.toString(),
                        isclean: widget.isclean.toString(),
                        isdry: widget.isdry.toString(),
                        isnotspilled: widget.isnotspilled.toString(),
                        issealed: widget.issealed.toString(),
                        ismanufacturerlabel:
                            widget.ismanufacturerlabel.toString(),
                        angkutanisclean: widget.angkutanisclean.toString(),
                        angkutanisdry: widget.angkutanisdry.toString(),
                        angkutanisnotspilled:
                            widget.angkutanisnotspilled.toString(),
                        angkutanissingle: widget.angkutanissingle.toString(),
                        angkutansegregate: widget.angkutansegregate.toString(),
                        angkutancatatan: widget.angkutancatatan,
                        kelembapan: widget.kelembapan,
                        suhu: widget.suhu,
                        itemcode: widget.itemcode)),
              );

              // saveData();
            },
          );
        },
        heroTag: "confirmbtn",
        tooltip: 'Konfirmasi',
        backgroundColor: Colors.purple,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: LoadingOverlay(
                  isLoading: loading,
                  opacity: 0.8,
                  progressIndicator:
                      SpinKitFadingCube(color: Colors.purple[300], size: 70.0),
                  color: Colors.grey[100],
                  child: Center(
                      child: cart.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Card(
                                elevation: 5,
                                shadowColor: Colors.purpleAccent,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: ListTile(
                                  title: Text(
                                    "Klik Tombol Add untuk Menambah Data",
                                    style: content,
                                  ),
                                ),
                              ))
                          : Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                        // key: UniqueKey(), Bkin keyboard otomatis ketutup.
                                        itemCount: cart.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return CartWidget(
                                              listLine: widget.selectedline,
                                              listLocation: widget.listLocation,
                                              cart: cart,
                                              index: index,
                                              callback: refresh);
                                        }),
                                  ),
                                ],
                              ),
                            ))),
            ),
            floatingActionButton: AnimatedFloatingActionButton(
                fabButtons: [confirmbtn(), addbtn()],
                key: key,
                colorStartAnimation: Colors.purple,
                colorEndAnimation: Colors.purpleAccent,
                animatedIconData: AnimatedIcons.menu_close));
  }
}
