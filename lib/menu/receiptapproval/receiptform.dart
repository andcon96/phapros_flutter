import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_template/utils/loading.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;

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
      domain,
      imrnbr,
      articlenbr,
      imrdate,
      arrivaldate,
      proddate,
      expdate,
      manufacturer,
      country,
      iscertofanalys,
      certofanalys,
      ismsds,
      msds,
      isforwarderdo,
      forwarderdo,
      ispackinglist,
      packinglist,
      isotherdocs,
      otherdocs,
      kemasansacdos,
      kemasansacdosdesc,
      kemasandrumvat,
      kemasandrumvatdesc,
      kemasanpalletpeti,
      kemasanpalletpetidesc,
      isclean,
      iscleandesc,
      isdry,
      isdrydesc,
      isnotspilled,
      isnotspilleddesc,
      issealed,
      ismanufacturerlabel,
      transporttransporterno,
      transportpoliceno,
      transportisclean,
      transportiscleandesc,
      transportisdry,
      transportisdrydesc,
      transportisnotspilled,
      transportisnotspilleddesc,
      transportispositionsingle,
      transportispositionsingledesc,
      transportissegregated,
      transportissegregateddesc,
      transportangkutancatatan,
      transportkelembapan,
      transportsuhu;

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
      required this.domain,
      required this.imrnbr,
      required this.articlenbr,
      required this.imrdate,
      required this.arrivaldate,
      required this.proddate,
      required this.expdate,
      required this.manufacturer,
      required this.country,
      required this.iscertofanalys,
      required this.certofanalys,
      required this.ismsds,
      required this.msds,
      required this.isforwarderdo,
      required this.forwarderdo,
      required this.ispackinglist,
      required this.packinglist,
      required this.isotherdocs,
      required this.otherdocs,
      required this.kemasansacdos,
      required this.kemasansacdosdesc,
      required this.kemasandrumvat,
      required this.kemasandrumvatdesc,
      required this.kemasanpalletpeti,
      required this.kemasanpalletpetidesc,
      required this.isclean,
      required this.iscleandesc,
      required this.isdry,
      required this.isdrydesc,
      required this.isnotspilled,
      required this.isnotspilleddesc,
      required this.issealed,
      required this.ismanufacturerlabel,
      required this.transporttransporterno,
      required this.transportpoliceno,
      required this.transportisclean,
      required this.transportiscleandesc,
      required this.transportisdry,
      required this.transportisdrydesc,
      required this.transportisnotspilled,
      required this.transportisnotspilleddesc,
      required this.transportispositionsingle,
      required this.transportispositionsingledesc,
      required this.transportissegregated,
      required this.transportissegregateddesc,
      required this.transportangkutancatatan,
      required this.transportkelembapan,
      required this.transportsuhu})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _receiptform createState() => _receiptform();
}

class AboutPage extends StatelessWidget {
  final String tag;
  final String photourl;

  AboutPage({required this.tag, required this.photourl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
              tag: tag,
              child: Image.network('${globals.globalurlphoto}' + photourl)),
        ),
      ),
    );
  }
}

class _receiptform extends State<receiptform> {
  bool loading = false;
  var listPrefix = [];
  var valueprefix = '';
  int totalpengiriman = 1; // 1 karena perlu + 1 untuk nomor IMR Berikut.
  List<String>? imagefiles = [];

  final children = <Widget>[];
  final childrendetail = <Widget>[];
  final childketidaksesuaian = <Widget>[];

  Future<void> getFoto({String? search}) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    final Uri url = Uri.parse(
        '${globals.globalurl}/getreceiptfoto?rcptnbr=' + search.toString());

    final response = await http.get(url, headers: {
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
    List<dynamic>? responseresult = json.decode(response.body);

    if (responseresult != []) {
      responseresult?.asMap().forEach((index, element) {
        var responsecheck = http.head(Uri.parse('${globals.globalurlphoto}'+element['rcptfu_path']))
         .then((responsecode) {
          // Check the response status code
          var statusCode = responsecode.statusCode;
          if(statusCode == 200){
            
            setState(() { 
              children.add(
                new InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => new AboutPage(
                            tag: index.toString(),
                            photourl: element['rcptfu_path']))),
                    child: Card(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: Hero(
                              tag: index.toString(),
                              child: Image.network('${globals.globalurlphoto}' +
                                  element['rcptfu_path']))),
                    )),
              );
            });
          }
          else{
            print(statusCode);
          }
          });
         
      });
    }
  }

  Future<void> getDetail({String? search}) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    final Uri url = Uri.parse(
        '${globals.globalurl}/getreceiptdetail?rcptnbr=' + search.toString());

    final response = await http.get(url, headers: {
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
    List<dynamic>? responseresult = json.decode(response.body);

    if (responseresult != []) {
      responseresult?.asMap().forEach((index, element) {
        childrendetail.addAll([
          _textInput(
            hint: "Line",
            controller:
                TextEditingController(text: element['rcptd_line'].toString()),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Part",
            controller: TextEditingController(
                text: element['rcptd_part'] + ' -- ' + element['item_desc']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "UM",
            controller: TextEditingController(
                text: element['rcptd_part_um']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Qty Datang",
            controller: TextEditingController(text: element['rcptd_qty_arr']),
          ),
          const SizedBox(
            height: 8,
          ),
          
          _textInputreject(
            hint: "Qty Reject",
            controller: TextEditingController(text: element['rcptd_qty_rej'])
            
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Qty Approve",
            controller: TextEditingController(text: element['rcptd_qty_appr']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Location",
            controller: TextEditingController(text: element['rcptd_loc']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Lot",
            controller: TextEditingController(text: element['rcptd_lot']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Batch",
            controller: TextEditingController(text: element['rcptd_batch']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Expired Date",
            controller: TextEditingController(text: element['rcptd_exp_date']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Manufacture Date",
            controller: TextEditingController(text: element['rcptd_manu_date']),
          ),
          const SizedBox(
            height: 8,
          ),
          // _textInput(
          //   hint: "Site",
          //   controller: TextEditingController(text: element['rcptd_site']),
          // ),
          const SizedBox(
            height: 50,
          ),
        ]);
      });
    }
  }

  Future<void> getketidaksesuaian({String? search}) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    final Uri url = Uri.parse(
        '${globals.globalurl}/getreceiptketidaksesuaian?rcptnbr=' + search.toString());

    final response = await http.get(url, headers: {
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
    List<dynamic>? responseresult = json.decode(response.body);

    if (responseresult != []) {
      responseresult?.asMap().forEach((index, element) {
        childketidaksesuaian.addAll([
          _textInput(
            hint: "Imr Number",
            controller:
                TextEditingController(text: element['laporan_imr']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Lot",
            controller: TextEditingController(
                text: element['laporan_lot']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Batch",
            controller: TextEditingController(
                text: element['laporan_batch']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Jumlah Masuk",
            controller: TextEditingController(text: element['laporan_jmlmasuk']),
          ),
          const SizedBox(
            height: 8,
          ),
          
          _textInput(
            hint: "Jumlah Reject",
            controller: TextEditingController(text: element['laporan_komplaindetail'])
            
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Komplain",
            controller: TextEditingController(text: element['laporan_komplain']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInput(
            hint: "Keterangan",
            controller: TextEditingController(text: element['laporan_keterangan']),
          ),
         
          const SizedBox(
            height: 50,
          ),
        ]);
      });
    }
  }

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
              text: "Success to Unapprove receipt " + IdRcp.text));
    } else if (response.body == 'approve failed') {
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Unapprove receipt" + IdRcp.text));
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

  // Step 1
  late TextEditingController receiptno;
  late TextEditingController pono;
  late TextEditingController supplier;
  // Step 2
  late TextEditingController perfix;
  late TextEditingController imrno;
  late TextEditingController arrivaldate;
  late TextEditingController imrdate;
  late TextEditingController dono;
  late TextEditingController articleno;
  late TextEditingController proddate;
  late TextEditingController expdate;
  late TextEditingController manufacturer;
  late TextEditingController origincountry;
  // Step 3
  late TextEditingController certificate;
  late TextEditingController msds;
  late TextEditingController forwaderdo;
  late TextEditingController packinglist;
  late TextEditingController otherdocs;

  // Step 4
  late TextEditingController keteranganisclean;
  late TextEditingController keteranganisdry;
  late TextEditingController keteranganisnotspilled;

  // Step 5
  late TextEditingController transporterno;
  late TextEditingController policeno;
  late TextEditingController angkutanketeranganisclean;
  late TextEditingController angkutanketeranganisdry;
  late TextEditingController angkutanketeranganisnotspilled;
  late TextEditingController angkutanketeranganissingle;
  late TextEditingController angkutanketeranganissegregated;
  // Tambahan User
  late TextEditingController angkutancatatan;
  late TextEditingController kelembapan;
  late TextEditingController suhu;

  //check button & radio button
  // Step 3
  late bool _certificateChecked;
  late bool _msdsChecked;
  late bool _forwarderdoChecked;
  late bool _packinglistChecked;
  late bool _otherdocsChecked;

  // Step 4
  late bool _sackordosChecked;
  String? _sackordosDamage;
  late bool _drumorvatChecked;
  String? _drumorvatDamage;
  late bool _palletorpetiChecked;
  String? _palletorpetiDamage;

  String? _isclean;
  String? _isdry;
  String? _isnotspilled;
  String? _issealed;
  String? _ismanufacturerlabel;

  // Step 5
  String? _angkutanisclean;
  String? _angkutanisdry;
  String? _angkutanisnotspilled;

  String? _angkutanissingle;
  String? _angkutansegregate;
  //end

  int _activeStepIndex = 0;

  bool overlayloading = false;

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
    String rcptnumber = widget.rcpt_nbr;
    getFoto(search: rcptnumber);
    getDetail(search: rcptnumber);
    getketidaksesuaian(search:rcptnumber);
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

    // Step 1
    receiptno = TextEditingController(text: widget.rcpt_nbr);
    pono = TextEditingController(text: widget.ponbr);
    supplier = TextEditingController();
    // Step 2
    perfix = TextEditingController(text: widget.imrnbr);
    imrno = TextEditingController(text: widget.imrnbr);
    arrivaldate = TextEditingController(
        text: widget.arrivaldate == 'null' ? '' : widget.arrivaldate);
    imrdate = TextEditingController(
        text: widget.imrdate == 'null' ? '' : widget.imrdate);
    dono = TextEditingController();
    articleno = TextEditingController(
        text: widget.articlenbr == 'null' ? '' : widget.articlenbr);
    proddate = TextEditingController(
        text: widget.proddate == 'null' ? '' : widget.proddate);
    expdate = TextEditingController(
        text: widget.expdate == 'null' ? '' : widget.expdate);
    manufacturer = TextEditingController(
        text: widget.manufacturer == 'null' ? '' : widget.manufacturer);
    origincountry = TextEditingController(
        text: widget.country == 'null' ? '' : widget.country);
    // Step 3
    certificate = TextEditingController(
        text: widget.certofanalys == 'null' ? '' : widget.certofanalys);
    msds =
        TextEditingController(text: widget.msds == 'null' ? '' : widget.msds);
    forwaderdo = TextEditingController(
        text: widget.forwarderdo == 'null' ? '' : widget.forwarderdo);
    packinglist = TextEditingController(
        text: widget.packinglist == 'null' ? '' : widget.packinglist);
    otherdocs = TextEditingController(
        text: widget.otherdocs == 'null' ? '' : widget.otherdocs);

    // Step 4
    keteranganisclean = TextEditingController(
        text: widget.iscleandesc == 'null' ? '' : widget.iscleandesc);
    keteranganisdry = TextEditingController(
        text: widget.isdrydesc == 'null' ? '' : widget.isdrydesc);
    keteranganisnotspilled = TextEditingController(
        text: widget.isnotspilleddesc == 'null' ? '' : widget.isnotspilleddesc);

    // Step 5
    transporterno = TextEditingController(text: widget.transporttransporterno);
    policeno = TextEditingController(text: widget.transportpoliceno);
    angkutanketeranganisclean = TextEditingController(
        text: widget.transportiscleandesc == 'null'
            ? ''
            : widget.transportiscleandesc);
    angkutanketeranganisdry = TextEditingController(
        text: widget.transportisdrydesc == 'null'
            ? ''
            : widget.transportisdrydesc);
    angkutanketeranganisnotspilled = TextEditingController(
        text: widget.transportisnotspilleddesc == 'null'
            ? ''
            : widget.transportisnotspilleddesc);
    angkutanketeranganissingle = TextEditingController(
        text: widget.transportispositionsingledesc == 'null'
            ? ''
            : widget.transportispositionsingledesc);
    angkutanketeranganissegregated = TextEditingController(
        text: widget.transportissegregateddesc == 'null'
            ? ''
            : widget.transportissegregateddesc);
    // Tambahan User
    angkutancatatan = TextEditingController(
        text: widget.transportangkutancatatan == 'null'
            ? ''
            : widget.transportangkutancatatan);
    kelembapan = TextEditingController(
        text: widget.transportkelembapan == 'null'
            ? ''
            : widget.transportkelembapan);
    suhu = TextEditingController(
        text: widget.transportsuhu == 'null' ? '' : widget.transportsuhu);

    _certificateChecked = int.parse(widget.iscertofanalys) == 1 ? true : false;
    _msdsChecked = int.parse(widget.ismsds) == 1 ? true : false;
    _forwarderdoChecked = int.parse(widget.isforwarderdo) == 1 ? true : false;
    _packinglistChecked = int.parse(widget.ispackinglist) == 1 ? true : false;
    _otherdocsChecked = int.parse(widget.isotherdocs) == 1 ? true : false;
    _sackordosChecked = int.parse(widget.kemasansacdos) == 1 ? true : false;
    _drumorvatChecked = int.parse(widget.kemasandrumvat) == 1 ? true : false;
    _palletorpetiChecked =
        int.parse(widget.kemasanpalletpeti) == 1 ? true : false;

    _drumorvatDamage = widget.kemasandrumvatdesc;
    _sackordosDamage = widget.kemasansacdosdesc;
    _palletorpetiDamage = widget.kemasanpalletpetidesc;

    _isclean = widget.isclean;
    _isdry = widget.isdry;
    _isnotspilled = widget.isnotspilled;
    _issealed = widget.issealed;
    _ismanufacturerlabel = widget.ismanufacturerlabel;

    // // Step 5
    _angkutanisclean = widget.transportisclean;
    _angkutanisdry = widget.transportisdry;
    _angkutanisnotspilled = widget.transportisnotspilled;
    _angkutanissingle = widget.transportispositionsingle;
    _angkutansegregate = widget.transportissegregated;
  }

  // Step 6
  String? _currline;
  // List<dynamic>? _currline;

  Widget _textInput({controller, hint}) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  Widget _textInputreject({controller, hint}) {
    var controllervalue = controller.text.toString();
    
    return TextField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: double.parse(controllervalue) > 0 ? Colors.red : Colors.black),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  Widget _textInputReadonly({controller, hint}) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Detail Receipt'),
          content: Column(
            children: [
              _textInputReadonly(
                hint: "Receipt No.",
                controller: receiptno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInputReadonly(
                hint: "Po No",
                controller: pono,
              ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Checklist'),
          content: Column(
            children: [
              //   Row(
              //   // mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(
              //       child: Text('IMR No', textAlign: TextAlign.left, 
              //         style: TextStyle(
              //           fontSize: 17,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Text(':', textAlign: TextAlign.left,
              //         style: TextStyle(
              //             fontSize: 17,
              //             fontWeight: FontWeight.bold,
              //           )
              //       ),
              //     ),
              //     Expanded(
              //       child: Text(imrno.text, textAlign: TextAlign.left, 
              //       style: TextStyle(
              //           fontSize: 17,
              //           fontWeight: FontWeight.bold,
              //         )
              //         ),
              //     ),

              //   ],
              // ),
              //                 Row(
              //   // mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(
              //       child: Text('IMR No', textAlign: TextAlign.left, 
              //         style: TextStyle(
              //           fontSize: 17,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Text(':', textAlign: TextAlign.left,
              //         style: TextStyle(
              //             fontSize: 17,
              //             fontWeight: FontWeight.bold,
              //           )
              //       ),
              //     ),
              //     Expanded(
              //       child: Text(imrno.text, textAlign: TextAlign.left, 
              //       style: TextStyle(
              //           fontSize: 17,
              //           fontWeight: FontWeight.bold,
              //         )
              //         ),
              //     ),

              //   ],
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              _textInputReadonly(
                hint: "IMR No.",
                controller: imrno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "Article No.",
                controller: articleno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInputReadonly(
                hint: "Arrival Date",
                controller: arrivaldate,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInputReadonly(
                hint: "IMR Date",
                controller: imrdate,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "Production Date",
                controller: proddate,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "Expiration Date",
                controller: expdate,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "Manufacturer",
                controller: manufacturer,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "Country",
                controller: origincountry,
              ),
            ],
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text('Kelengkapan Dokumen'),
            content: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Certificate of Analysis'),
                  value: _certificateChecked,
                  onChanged: null,
                ),
                const SizedBox(
                  height: 8,
                ),
                if (_certificateChecked)
                  _textInput(
                    hint: "Keterangan",
                    controller: certificate,
                  ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  title: const Text('MSDS'),
                  value: _msdsChecked,
                  onChanged: null,
                ),
                if (_msdsChecked)
                  _textInput(
                    hint: "Keterangan",
                    controller: msds,
                  ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  title: const Text('Forwarder DO'),
                  value: _forwarderdoChecked,
                  onChanged: null,
                ),
                if (_forwarderdoChecked)
                  _textInput(
                    hint: "Keterangan",
                    controller: forwaderdo,
                  ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  title: const Text('Packing List'),
                  value: _packinglistChecked,
                  onChanged: null,
                ),
                if (_packinglistChecked)
                  _textInput(
                    hint: "Keterangan",
                    controller: packinglist,
                  ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  title: const Text('Other Docs'),
                  value: _otherdocsChecked,
                  onChanged: null,
                ),
                if (_otherdocsChecked)
                  _textInput(
                    hint: "Keterangan",
                    controller: otherdocs,
                  ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
        Step(
          state: _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 3,
          title: const Text('Kemasan'),
          content: Column(
            children: [
              CheckboxListTile(
                title: const Text('Kemasan Sack / Dos'),
                value: _sackordosChecked,
                onChanged: null,
              ),
              const SizedBox(
                height: 8,
              ),
              if (_sackordosChecked)
                Column(
                  children: [
                    RadioListTile(
                      title: Text("Damage"),
                      value: "Damage",
                      groupValue: _sackordosDamage,
                      onChanged: null,
                    ),
                    RadioListTile(
                      title: Text("Undamage"),
                      value: "Undamage",
                      groupValue: _sackordosDamage,
                      onChanged: null,
                    ),
                  ],
                ),
              CheckboxListTile(
                title: const Text('Kemasan Drum / Vat'),
                value: _drumorvatChecked,
                onChanged: null,
              ),
              const SizedBox(
                height: 8,
              ),
              if (_drumorvatChecked)
                Column(
                  children: [
                    RadioListTile(
                      title: Text("Damage"),
                      value: "Damage",
                      groupValue: _drumorvatDamage,
                      onChanged: null,
                    ),
                    RadioListTile(
                      title: Text("Undamage"),
                      value: "Undamage",
                      groupValue: _drumorvatDamage,
                      onChanged: null,
                    ),
                  ],
                ),
              CheckboxListTile(
                title: const Text('Kemasan Pallet / Peti'),
                value: _palletorpetiChecked,
                onChanged: null,
              ),
              const SizedBox(
                height: 8,
              ),
              if (_palletorpetiChecked)
                Column(
                  children: [
                    RadioListTile(
                      title: Text("Damage"),
                      value: "Damage",
                      groupValue: _palletorpetiDamage,
                      onChanged: null,
                    ),
                    RadioListTile(
                      title: Text("Undamage"),
                      value: "Undamage",
                      groupValue: _palletorpetiDamage,
                      onChanged: null,
                    ),
                  ],
                ),
              const Text(
                'Condition',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Bersih'),
                      leading: Radio(
                        value: '1',
                        groupValue: _isclean,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Kotor'),
                      leading: Radio(
                          value: '0', groupValue: _isclean, onChanged: null),
                    ),
                  ),
                ],
              ),
              if (_isclean == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: keteranganisclean,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Kering'),
                      leading: Radio(
                        value: '1',
                        groupValue: _isdry,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Basah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _isdry,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isdry == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: keteranganisdry,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Tidak Tumpah'),
                      leading: Radio(
                        value: '1',
                        groupValue: _isnotspilled,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Tumpah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _isnotspilled,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isnotspilled == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: keteranganisnotspilled,
                ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Seal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Utuh'),
                      leading: Radio(
                        value: '1',
                        groupValue: _issealed,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Rusak'),
                      leading: Radio(
                        value: '0',
                        groupValue: _issealed,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Manufacturer Label',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Utuh'),
                      leading: Radio(
                        value: '1',
                        groupValue: _ismanufacturerlabel,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Rusak'),
                      leading: Radio(
                        value: '0',
                        groupValue: _ismanufacturerlabel,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 4 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 4,
          title: const Text('Angkutan'),
          content: Column(
            children: [
              _textInput(
                hint: "Transporter No.",
                controller: transporterno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "Police No.",
                controller: policeno,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Condition',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Bersih'),
                      leading: Radio(
                        value: '1',
                        groupValue: _angkutanisclean,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Kotor'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanisclean,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_angkutanisclean == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: angkutanketeranganisclean,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Kering'),
                      leading: Radio(
                        value: '1',
                        groupValue: _angkutanisdry,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Basah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanisdry,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_angkutanisdry == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: angkutanketeranganisdry,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Tidak Tumpah'),
                      leading: Radio(
                        value: '1',
                        groupValue: _angkutanisnotspilled,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Tumpah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanisnotspilled,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_angkutanisnotspilled == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: angkutanketeranganisnotspilled,
                ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Posisi Material',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Single'),
                      leading: Radio(
                        value: '1',
                        groupValue: _angkutanissingle,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Gabungan'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanissingle,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_angkutanissingle == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: angkutanketeranganissingle,
                ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Segresi Jelas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Ya'),
                      leading: Radio(
                        value: '1',
                        groupValue: _angkutansegregate,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Tidak'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutansegregate,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              if (_angkutansegregate == '0')
                _textInput(
                  hint: "Keterangan",
                  controller: angkutanketeranganissegregated,
                ),
            ],
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 5 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 5,
            title: const Text('Catatan'),
            content: Column(
              children: [
                _textInput(
                  hint: "Kelembapan",
                  controller: kelembapan,
                ),
                const SizedBox(
                  height: 8,
                ),
                _textInput(
                  hint: "Suhu",
                  controller: suhu,
                ),
                const SizedBox(
                  height: 8,
                ),
                _textInput(
                  hint: "Catatan",
                  controller: angkutancatatan,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
        Step(
            state:
                _activeStepIndex <= 6 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 6,
            title: const Text('Kesimpulan Alokasi'),
            content: Column(
              children: [
                _textInput(
                  hint: "Part",
                  controller: NamaBarang,
                ),
                const SizedBox(
                  height: 8,
                ),
                _textInput(
                  hint: "Qty Datang",
                  controller: JumlahMasuk,
                ),
                const SizedBox(
                  height: 8,
                ),
                _textInput(
                  hint: "Qty Reject",
                  controller: JumlahReject,
                ),
                const SizedBox(
                  height: 8,
                ),
                _textInput(
                  hint: "Qty Approve",
                  controller: JumlahApprove,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
        Step(
            state:
                _activeStepIndex <= 7 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 7,
            title: const Text('Detail Alokasi'),
            content: Column(children: childrendetail)
            ),
        Step(
            state:
                _activeStepIndex <= 8 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 8,
            title: const Text('Laporan Ketidaksesuaian'),
            content: Column(children: childketidaksesuaian)
            ),
        Step(
            state:
                _activeStepIndex <= 9 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 9,
            title: const Text('Foto'),
            content: Wrap(children: children))
      ];
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
                      Stepper(
                        controlsBuilder: (context, details) {
                          return Row(
                            children: <Widget>[
                              TextButton(onPressed: null, child: Text('')),
                              TextButton(onPressed: null, child: Text('')),
                            ],
                          );
                        },
                        physics: const ClampingScrollPhysics(),
                        type: StepperType.vertical,
                        currentStep: _activeStepIndex,
                        steps: stepList(),
                        // onStepContinue: () {
                        //   if (_activeStepIndex <
                        //       (stepList().length - 1)) {
                        //     setState(() {
                        //       _activeStepIndex += 1;
                        //     });
                        //   } else {

                        //   }
                        // },
                        // onStepCancel: () {
                        //   if (_activeStepIndex == 0) {
                        //     return;
                        //   }

                        //   setState(() {
                        //     _activeStepIndex -= 1;
                        //   });
                        // },
                        onStepTapped: (int index) {
                          setState(() {
                            _activeStepIndex = index;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              child: Text('Unapprove'),
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
                                                  'Anda yakin ingin Unapprove Receipt ' +
                                                      IdRcp.text +
                                                      '?',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white)),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white),
                                                child: const Text(
                                                    'Tekan tahan tombol untuk melanjutkan',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black)),
                                                onPressed: () {},
                                                onLongPress: () {
                                                  String url =
                                                      '${globals.globalurl}/rejectreceipt?';
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
                                                  'Anda yakin ingin Approve Receipt ' +
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
                                                    'Tekan tahan tombol untuk melanjutkan'),
                                                onPressed: () {},
                                                onLongPress: () {
                                                  String url =
                                                      '${globals.globalurl}/approvereceipt?';
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
