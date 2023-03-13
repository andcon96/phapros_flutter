// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/menu/po/wsaPO.dart';
import 'package:flutter_template/menu/po/model/wsaPoModel.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

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

                    // print(selecteddata[0].tLvcUm);
                    // print(widget.cartItem.tLviLine);

                    widget.cartItem.tLvcUm = selecteddata[0].tLvcUm.toString();

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
            labelText: 'Batch / Lot',
          ),
        )
      ],
    );
  }
}

// Card + Panggil Drop Down
class CartWidget extends StatefulWidget {
  List<Data> cart;
  int index;
  VoidCallback callback;
  List<Data> listLine;

  CartWidget(
      {required this.cart,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: 600,
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
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: widget.cart[widget.index].tIsSaved!,
                controller: lokasi,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
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
                ),
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
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                readOnly: widget.cart[widget.index].tIsSaved!,
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
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                text: 'Save Row ?',
                                confirmBtnText: 'Yes',
                                cancelBtnText: 'No',
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: () {
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
                                  widget.cart[widget.index].tLvcBatch =
                                      batch.text;
                                  widget.cart[widget.index].tLvcLoc =
                                      lokasi.text;
                                  widget.cart[widget.index].tLvcLot = lot.text;
                                  widget.cart[widget.index].tLvdQtyDatang =
                                      qtydatang.text;
                                  widget.cart[widget.index].tLvdQtyReject =
                                      qtyreject.text;
                                  widget.cart[widget.index].tLvdQtyTerima =
                                      qtyterima.text;
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
  alokasipo({
    Key? key,
    required this.selectedline,
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
  }) : super(key: key);

  final List<Data> selectedline;
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
  }

  Future saveData() async {
    try {
      final id = await UserSecureStorage.getUsername();
      final token = await UserSecureStorage.getToken();

      final Uri url = Uri.parse('http://192.168.18.186:8000/api/savepo');

      final body = {
        "data": cart,
        "user_id": id,

        // Checklist
        "imrno": widget.imrno,
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
          text: 'Data berhasil dikirim ke QAD',
          loopAnimation: false,
        );
        return true;
      } else {
        setState(() {
          loading = false;
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
        text: 'No Internet',
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
              tLvcPartDesc: widget.selectedline[0].tLvcPartDesc,
              tIsSaved: false));
          setState(() {});
        },
        heroTag: "addbtn",
        tooltip: 'Add Data',
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
            text: 'Submit Data ?',
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
                loading = true;
              });
              saveData();
            },
          );
        },
        heroTag: "confirmbtn",
        tooltip: 'Confrim',
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
                                    "Click the button to add new data",
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
