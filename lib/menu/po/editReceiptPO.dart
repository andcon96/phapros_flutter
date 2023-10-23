// ignore_for_file: use_build_context_synchronously, camel_case_types, non_constant_identifier_names, unused_field

import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/menu/home.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_template/utils/loading.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;
import 'package:loading_overlay/loading_overlay.dart';

import '../../utils/styles.dart';
import 'model/wsaPoModel.dart';

class editReceiptPO extends StatefulWidget {
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
      shipto,
      domain,
      imrnbr,
      donbr,
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

  const editReceiptPO(
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
      required this.shipto,
      required this.domain,
      required this.imrnbr,
      required this.donbr,
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
  _editReceiptPO createState() => _editReceiptPO();
}

class AboutPage extends StatelessWidget {
  final String tag;
  final String photourl;

  AboutPage({required this.tag, required this.photourl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
              tag: tag,
              child: Image.network('${globals.globalurlphoto}$photourl')),
        ),
      ),
    );
  }
}

class _editReceiptPO extends State<editReceiptPO> {
  bool loading = false;
  var listPrefix = [];
  var valueprefix = '';
  int totalpengiriman = 1; // 1 karena perlu + 1 untuk nomor IMR Berikut.
  List<String>? imagefiles = [];

  List<Data> cart = [];

  final children = <Widget>[];
  final childrendetail = <Widget>[];

  List<String> listdeleted = [];
  List<XFile> new_imagefiles = [];
  List<File> new_imagesPath = [];

  Future<void> getFoto({String? search}) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    final Uri url =
        Uri.parse('${globals.globalurl}/getreceiptfoto?rcptnbr=$search');

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
        var responsecheck = http
            .head(Uri.parse(globals.globalurlphoto + element['rcptfu_path']))
            .then((responsecode) {
          // Check the response status code
          var statusCode = responsecode.statusCode;
          if (statusCode == 200) {
            setState(() {
              children.add(
                InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              color: Colors.purple,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: <Widget>[
                                    const Text(
                                        'Yakin ingin menghilangkan foto ini?',
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            fontSize: 15,
                                            color: Colors
                                                .white)),
                                    ElevatedButton(
                                      style: ElevatedButton
                                          .styleFrom(
                                              primary: Colors
                                                  .white),
                                      child: const Text(
                                          'tekan tombol ini untuk menghilangkan foto',
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              fontSize: 15,
                                              color: Colors
                                                  .black)),
                                      onPressed: () {
                                        children.removeAt(index+1);
                                        
                                        listdeleted.add(element['rcptfu_path']);
                                        Navigator.pop(
                                            context);
                                        CoolAlert.show(
                                            context:
                                                context,
                                            type:
                                                CoolAlertType
                                                    .success,
                                            text:
                                                'Foto berhasil dihilangkan',
                                            title:
                                                'Success');
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                      setState(() {});
                    },
                    child: Card(
                      child: SizedBox(
                          height: 100,
                          width: 100,
                              child: Image.network(globals.globalurlphoto +
                                  element['rcptfu_path'])),
                    )),
              );
            });
          } else {
            print(statusCode);
          }
        });
      });
    }

    children.add(Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ChooseImage();
                },
                child: const Text('Add New Photo'),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    ));
  }

  ChooseImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                takeImages();
              },
              child: Text("Camera"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                openImages();
              },
              child: Text("Gallery"),
            ),
          ],
        ),
      ),
    );
  }

  Future takeImages() async {
    var imagefromphoto =
        await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 20);

    if (imagefromphoto != null) {
      var imgsize = (await imagefromphoto.readAsBytes()).lengthInBytes;
      if (imgsize <= 5000000) {
          new_imagefiles!.add(imagefromphoto!);
          new_imagesPath.add(File(imagefromphoto!.path));
        }      
        else {
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Image exceeds 5MB"));
        // Do something with the selected image
        }


      // Process selected images

      setState(() {});
    } else if (imagefromphoto == null) {
      // Display error message

      setState(() {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'Mohon pilih foto',
            title: 'Error');
      });
    }
  }

  Future openImages() async {
    var images = await ImagePicker().pickMultiImage(imageQuality: 20);

    if (images!.isNotEmpty) {
      // Process selected images

      for (var image in images!) {
        var imgsize = (await image.readAsBytes()).lengthInBytes;
        if (imgsize <= 5000000) {
                new_imagesPath.add(File(image.path));
                new_imagefiles!.add(image);
                print(imgsize);
        }      
        else {
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Image exceeds 5MB"));
        // Do something with the selected image
        }
      }
      setState(() {});
    } else if (images!.isEmpty) {
      // Display error message

      setState(() {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'Mohon pilih foto',
            title: 'Error');
      });
    }
    // await ImagePicker().pickImage(maxImages:3);
  }

  Future<void> getDetail({String? search}) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    final Uri url =
        Uri.parse('${globals.globalurl}/getreceiptdetail?rcptnbr=$search');

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
        double _sum = 0;
        TextEditingController qtyRejectController =
            TextEditingController(text: element['rcptd_qty_rej']);
        TextEditingController qtyArrivalController =
            TextEditingController(text: element['rcptd_qty_arr']);
        TextEditingController sumController =
            TextEditingController(text: element['rcptd_qty_appr']);
        TextEditingController expDateController =
            TextEditingController(text: element['rcptd_exp_date']);
        TextEditingController manuDateController =
            TextEditingController(text: element['rcptd_manu_date']);

        cart.add(Data(
          tLvcNbr: element['iddetail'].toString(), // Masukin ID Detail buat API
          tLviLine: element['rcptd_line'].toString(),
          tLvdQtyDatang: element['rcptd_qty_arr'].toString(),
          tLvdQtyReject: element['rcptd_qty_rej'].toString(),
          tLvdQtyRcvd: element['rcptd_qty_appr'].toString(),
          tLvcLoc: element['rcptd_loc'].toString(),
          tLvcLot: element['rcptd_lot'].toString(),
          tLvcBatch: element['rcptd_batch'].toString(),
          tLvcExpDetailDate: element['rcptd_exp_date'].toString(),
          tLvcManuDetailDate: element['rcptd_manu_date'].toString(),
        ));

        childrendetail.addAll([
          _textInputReadonly(
            hint: "Line",
            controller:
                TextEditingController(text: element['rcptd_line'].toString()),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInputReadonly(
            hint: "Part",
            controller: TextEditingController(
                text: element['rcptd_part'] + ' -- ' + element['item_desc']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInputReadonly(
            hint: "UM PO",
            controller: TextEditingController(text: element['rcptd_part_um']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInputReadonly(
            hint: "UM PR",
            controller: TextEditingController(text: element['rcptd_um_pr']),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInputReadonly(
            hint: "UM Konversi",
            controller: TextEditingController(text: element['rcptd_um_konv']),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: qtyArrivalController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _sum = (double.tryParse(value) ?? 0) -
                    (double.tryParse(qtyRejectController.text) ?? 0);

                sumController.text = _sum.toStringAsFixed(2);
                cart[index].tLvdQtyDatang = value;
                cart[index].tLvdQtyRcvd = _sum.toString();
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red, // Desired border color
                ),
              ),
              labelText: "Qty Datang",
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: qtyRejectController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _sum = (double.tryParse(qtyArrivalController.text) ?? 0) -
                  (double.tryParse(value) ?? 0);
              sumController.text = _sum.toStringAsFixed(2);
              cart[index].tLvdQtyReject = value;
              cart[index].tLvdQtyRcvd = _sum.toString();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red, // Desired border color
                ),
              ),
              labelText: "Qty Reject",
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          _textInputReadonly(
            hint: "Qty Approve",
            controller: sumController,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: TextEditingController(text: element['rcptd_loc']),
            onChanged: (value) {
              cart[index].tLvcLoc = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red, // Desired border color
                ),
              ),
              labelText: 'Location',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: TextEditingController(text: element['rcptd_lot']),
            onChanged: (value) {
              cart[index].tLvcLot = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red, // Desired border color
                ),
              ),
              labelText: 'Lot',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: TextEditingController(text: element['rcptd_batch']),
            onChanged: (value) {
              cart[index].tLvcBatch = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red, // Desired border color
                ),
              ),
              labelText: 'Batch',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
              controller: expDateController,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month_rounded),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                      initialDate: DateTime.parse(element['rcptd_exp_date']),
                    );
                    if (picked != null &&
                        picked != DateTime.parse(element['rcptd_exp_date'])) {
                      setState(() {
                        element['rcptd_exp_date'] = picked;
                      });
                      expDateController.text =
                          DateFormat('yyyy-MM-dd').format(picked);

                      cart[index].tLvcExpDetailDate =
                          DateFormat('yyyy-MM-dd').format(picked).toString();
                    }
                  },
                ),
                border: const OutlineInputBorder(),
                labelText: 'Expiration Date',
              )),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
              controller: manuDateController,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month_rounded),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                      initialDate: DateTime.parse(element['rcptd_manu_date']),
                    );
                    if (picked != null &&
                        picked != DateTime.parse(element['rcptd_manu_date'])) {
                      setState(() {
                        element['rcptd_manu_date'] = picked;
                      });
                      manuDateController.text =
                          DateFormat('yyyy-MM-dd').format(picked);

                      cart[index].tLvcManuDetailDate =
                          DateFormat('yyyy-MM-dd').format(picked).toString();
                    }
                  },
                ),
                border: const OutlineInputBorder(),
                labelText: 'Manufacture Date',
              )),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 25,
          ),
        ]);
      });
    }
  }

  Future<Object?> sendlaporan(String url) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    url += '&userid=$id';

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
              text: "Success to Approve receipt ${IdRcp.text}"));
    } else if (response.body == 'approve failed') {
      Navigator.pop(context, 'refresh');
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Approve receipt${IdRcp.text}"));
    } else if (response.body == 'reject success') {
      Navigator.pop(context, 'refresh');
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              title: "Success",
              text: "Success to Unapprove receipt ${IdRcp.text}"));
    } else if (response.body == 'approve failed') {
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Unapprove receipt${IdRcp.text}"));
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
  late TextEditingController lastapproval;
  late TextEditingController TglMasuk;
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
  late DateTime selected_arrivaldate;
  late TextEditingController imrdate;
  late DateTime selected_imrdate;
  late TextEditingController dono;
  late TextEditingController articleno;
  late TextEditingController proddate;
  late DateTime selected_proddate;
  late TextEditingController expdate;
  late DateTime selected_expdate;
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

  Future saveData() async {
    try {
      setState(() {
        overlayloading = true;
      });
      final nik = await UserSecureStorage.getUsername();
      final token = await UserSecureStorage.getToken();
      final idanggota = await UserSecureStorage.getIdAnggota();

      final Uri url = Uri.parse('${globals.globalurl}/saveeditpo');
      final request = http.MultipartRequest('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['authorization'] = "Bearer $token";

      for (var imagenew in new_imagefiles) {
        File image = File(imagenew.path);
        if (image.existsSync()) {
          // Check if the file exists
          // Check if the file is an image file
          if (image.path.endsWith('.jpg') ||
              image.path.endsWith('.jpeg') ||
              image.path.endsWith('.png')) {
            // Check if the file size is less than 10MB
            var imgsize = (await image.readAsBytes()).lengthInBytes;
            if (imgsize <= 5000000) {
              request.files.add(
                await http.MultipartFile.fromPath('images[]', image.path),
              );
            } else {
              print('Image size exceeds 10MB: ${image.path}');
            }
          } else {
            print('File is not an image: ${image.path}');
          }
        } else {
          print('File does not exist: ${image.path}');
        }
      }

      final body = {
        "nik": nik,
        "id_anggota": idanggota,
        "data": jsonEncode(cart),

        // Checklist
        "imrno": imrno.text,
        "dono": dono.text,
        "articleno": articleno.text,
        "arrivaldate": arrivaldate.text,
        "imrdate": imrdate.text,
        "productiondate": proddate.text,
        "expiredate": expdate.text,
        "manufacturer": manufacturer.text,
        "country": origincountry.text,

        // Kelengkapan Dokumen
        "is_certofanalys": _certificateChecked,
        "certofanalys": certificate.text,
        "is_msds": _msdsChecked,
        "msds": msds.text,
        "is_forwarderdo": _forwarderdoChecked,
        "forwarderdo": forwaderdo.text,
        "is_packinglist": _packinglistChecked,
        "packinglist": packinglist.text,
        "is_otherdocs": _otherdocsChecked,
        "otherdocs": otherdocs.text,

        // Kemasan
        "kemasan_sacdos": _sackordosChecked,
        "is_damage_kemasan_sacdos": _sackordosDamage.toString(),
        "kemasan_drumvat": _drumorvatChecked,
        "is_damage_kemasan_drumvat": _drumorvatDamage.toString(),
        "kemasan_palletpeti": _palletorpetiChecked,
        "is_damage_kemasan_palletpeti": _palletorpetiDamage.toString(),

        "is_clean": _isclean.toString(),
        "keterangan_is_clean": keteranganisclean.text,
        "is_dry": _isdry.toString(),
        "keterangan_is_dry": keteranganisdry.text,
        "is_not_spilled": _isnotspilled.toString(),
        "keterangan_is_not_spilled": keteranganisnotspilled.text,

        "is_sealed": _issealed.toString(),
        "is_manufacturer_label": _ismanufacturerlabel.toString(),
        // Kondisi
        "transporter_no": transporterno.text,
        "police_no": policeno.text,

        "is_clean_angkutan": _angkutanisclean.toString(),
        "keterangan_is_clean_angkutan": angkutanketeranganisclean.text,
        "is_dry_angkutan": _angkutanisdry.toString(),
        "keterangan_is_dry_angkutan": angkutanketeranganisdry.text,
        "is_not_spilled_angkutan": _angkutanisnotspilled.toString(),
        "keterangan_is_not_spilled_angkutan":
            angkutanketeranganisnotspilled.text,

        "material_position": _angkutanissingle.toString(),
        "keterangan_material_position": angkutanketeranganissingle.text,

        "is_segregated": _angkutansegregate.toString(),
        "keterangan_is_segregated": angkutanketeranganissegregated.text,
        "angkutan_catatan": angkutancatatan.text,
        "kelembapan": kelembapan.text,
        "suhu": suhu.text,
        "listdeleted": jsonEncode(listdeleted)
      };

      // print(body);
      final stringBody =
          body.map((key, value) => MapEntry(key, value.toString()));

      request.fields.addAll(stringBody);

      var response = await request.send();
      final responsedata = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var flg = 0; // 1 => Ada Qty Reject, kasi opsi ke Form Reject.
        for (var data in cart) {
          var qtyReject = double.parse(data.tLvdQtyReject ?? '0');

          if (qtyReject > 0) {
            flg = 1;
          }
        }

        setState(() {
          overlayloading = false;
        });

        var ponbr = jsonDecode(responsedata.body)['ponbr'].toString();
        if (flg == 0) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => NavHome(selPage: 0, searchvalue: ponbr),
              ),
              (route) => route.isFirst);

          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Sukses',
            text: 'Data berhasil dikrim',
            loopAnimation: false,
          );
        } else {
          // Konfirmasi user untuk ke Form tidak sesuai.
          CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              text: 'Data Berhasil Disimpan, Lanjut ke Form Ketidaksesuaian ?',
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              confirmBtnColor: Colors.green,
              onConfirmBtnTap: () {
                Navigator.of(context, rootNavigator: true).pop();

                var datareceipt = jsonDecode(responsedata.body)['datareceipt'];
                String receiptnbr = datareceipt['rcpt_nbr'].toString();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => NavHome(
                        selPage: 1,
                        searchvalue: receiptnbr,
                      ),
                    ),
                    (route) => route.isFirst);
              },
              onCancelBtnTap: () {
                Navigator.of(context, rootNavigator: true).pop();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          NavHome(selPage: 0, searchvalue: ponbr),
                    ),
                    (route) => route.isFirst);
              });
        }

        return true;
      } else {
        setState(() {
          overlayloading = false;
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
        overlayloading = false;
      });
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Error',
        text: 'Tidak ada Internet',
        loopAnimation: false,
      );
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    String rcptnumber = widget.rcpt_nbr;
    getFoto(search: rcptnumber);
    getDetail(search: rcptnumber);
    IdRcp = TextEditingController(text: widget.rcpt_nbr);
    TglMasuk = TextEditingController(text: widget.rcpt_date);
    PO = TextEditingController(text: widget.ponbr);
    NomorLot = TextEditingController(text: widget.rcptd_lot);
    Shipto = TextEditingController(text: widget.shipto);
    // Batch = TextEditingController(text: widget.batch);
    Supplier = TextEditingController(text: widget.supplier);
    Loc = TextEditingController(text: widget.rcptd_loc);

    // Step 1
    receiptno = TextEditingController(text: widget.rcpt_nbr);
    pono = TextEditingController(text: widget.ponbr);
    supplier = TextEditingController();
    // Step 2
    perfix = TextEditingController(text: widget.imrnbr);
    imrno = TextEditingController(text: widget.imrnbr);
    arrivaldate = TextEditingController(
        text: widget.arrivaldate == 'null' ? '' : widget.arrivaldate);
    selected_arrivaldate = DateTime.parse(widget.arrivaldate);
    imrdate = TextEditingController(
        text: widget.imrdate == 'null' ? '' : widget.imrdate);
    selected_imrdate = DateTime.parse(widget.imrdate);
    dono =
        TextEditingController(text: widget.donbr == 'null' ? '' : widget.donbr);
    articleno = TextEditingController(
        text: widget.articlenbr == 'null' ? '' : widget.articlenbr);
    proddate = TextEditingController(
        text: widget.proddate == 'null' ? '' : widget.proddate);
    // ignore: unnecessary_null_comparison
    widget.proddate != 'null'
        ? selected_proddate = DateTime.parse(widget.proddate)
        : selected_proddate = DateTime.now();
    expdate = TextEditingController(
        text: widget.expdate == 'null' ? '' : widget.expdate);
    // ignore: unnecessary_null_comparison
    widget.expdate != 'null'
        ? selected_expdate = DateTime.parse(widget.expdate)
        : selected_expdate = DateTime.now();
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

  Widget _textDate({controller, hint, defaultdate}) {
    return TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
                initialDate: defaultdate,
              );
              if (picked != null && picked != defaultdate) {
                setState(() {
                  defaultdate = picked;
                });
                controller.text = DateFormat('yyyy-MM-dd').format(defaultdate);
              }
            },
          ),
          border: const OutlineInputBorder(),
          labelText: hint,
        ));
  }

  Widget _textInput({controller, hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Desired border color
          ),
        ),
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
              _textInputReadonly(
                hint: "IMR No.",
                controller: imrno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "DO No.",
                controller: dono,
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
              _textDate(
                hint: "Arrival Date",
                controller: arrivaldate,
                defaultdate: selected_arrivaldate,
              ),
              const SizedBox(
                height: 8,
              ),
              _textDate(
                  hint: "IMR Date",
                  controller: imrdate,
                  defaultdate: selected_imrdate),
              const SizedBox(
                height: 8,
              ),
              _textDate(
                hint: "Production Date",
                controller: proddate,
                defaultdate: selected_proddate,
              ),
              const SizedBox(
                height: 8,
              ),
              _textDate(
                  hint: "Expiration Date",
                  controller: expdate,
                  defaultdate: selected_expdate),
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
                  onChanged: (value) {
                    setState(() {
                      _certificateChecked = value!;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      _msdsChecked = value!;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      _forwarderdoChecked = value!;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      _packinglistChecked = value!;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      _otherdocsChecked = value!;
                    });
                  },
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
                onChanged: (value) {
                  setState(() {
                    _sackordosChecked = value!;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              if (_sackordosChecked)
                Column(
                  children: [
                    RadioListTile(
                      title: const Text("Damage"),
                      value: "Damage",
                      groupValue: _sackordosDamage,
                      onChanged: (value) {
                        setState(() {
                          _sackordosDamage = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("Undamage"),
                      value: "Undamage",
                      groupValue: _sackordosDamage,
                      onChanged: (value) {
                        setState(() {
                          _sackordosDamage = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              CheckboxListTile(
                title: const Text('Kemasan Drum / Vat'),
                value: _drumorvatChecked,
                onChanged: (value) {
                  setState(() {
                    _drumorvatChecked = value!;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              if (_drumorvatChecked)
                Column(
                  children: [
                    RadioListTile(
                      title: const Text("Damage"),
                      value: "Damage",
                      groupValue: _drumorvatDamage,
                      onChanged: (value) {
                        setState(() {
                          _drumorvatDamage = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("Undamage"),
                      value: "Undamage",
                      groupValue: _drumorvatDamage,
                      onChanged: (value) {
                        setState(() {
                          _drumorvatDamage = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              CheckboxListTile(
                title: const Text('Kemasan Pallet / Peti'),
                value: _palletorpetiChecked,
                onChanged: (value) {
                  setState(() {
                    _palletorpetiChecked = value!;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              if (_palletorpetiChecked)
                Column(
                  children: [
                    RadioListTile(
                      title: const Text("Damage"),
                      value: "Damage",
                      groupValue: _palletorpetiDamage,
                      onChanged: (value) {
                        setState(() {
                          _palletorpetiDamage = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("Undamage"),
                      value: "Undamage",
                      groupValue: _palletorpetiDamage,
                      onChanged: (value) {
                        setState(() {
                          _palletorpetiDamage = value.toString();
                        });
                      },
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
                        onChanged: (value) {
                          setState(() {
                            _isclean = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Kotor'),
                      leading: Radio(
                          value: '0',
                          groupValue: _isclean,
                          onChanged: (value) {
                            setState(() {
                              _isclean = value.toString();
                            });
                          }),
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
                        onChanged: (value) {
                          setState(() {
                            _isdry = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Basah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _isdry,
                        onChanged: (value) {
                          setState(() {
                            _isdry = value.toString();
                          });
                        },
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
                        onChanged: (value) {
                          setState(() {
                            _isnotspilled = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Tumpah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _isnotspilled,
                        onChanged: (value) {
                          setState(() {
                            _isnotspilled = value.toString();
                          });
                        },
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
                        onChanged: (value) {
                          setState(() {
                            _issealed = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Rusak'),
                      leading: Radio(
                        value: '0',
                        groupValue: _issealed,
                        onChanged: (value) {
                          setState(() {
                            _issealed = value.toString();
                          });
                        },
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
                        onChanged: (value) {
                          setState(() {
                            _ismanufacturerlabel = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Rusak'),
                      leading: Radio(
                        value: '0',
                        groupValue: _ismanufacturerlabel,
                        onChanged: (value) {
                          setState(() {
                            _ismanufacturerlabel = value.toString();
                          });
                        },
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
                hint: "Nama Angkutan.",
                controller: transporterno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInput(
                hint: "No Polisi.",
                controller: policeno,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Keadaan Angkutan',
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
                        onChanged: (value) {
                          setState(() {
                            _angkutanisclean = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Kotor'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanisclean,
                        onChanged: (value) {
                          setState(() {
                            _angkutanisclean = value.toString();
                          });
                        },
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
                        onChanged: (value) {
                          setState(() {
                            _angkutanisdry = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Basah'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanisdry,
                        onChanged: (value) {
                          setState(() {
                            _angkutanisdry = value.toString();
                          });
                        },
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
                      title: const Text('Tidak Bocor'),
                      leading: Radio(
                        value: '1',
                        groupValue: _angkutanisnotspilled,
                        onChanged: (value) {
                          setState(() {
                            _angkutanisnotspilled = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Bocor'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanisnotspilled,
                        onChanged: (value) {
                          setState(() {
                            _angkutanisnotspilled = value.toString();
                          });
                        },
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
                'Penempatan Bahan/Barang Dalam Angkutan',
                style: TextStyle(
                  fontSize: 15,
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
                        onChanged: (value) {
                          setState(() {
                            _angkutanissingle = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Gabungan'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutanissingle,
                        onChanged: (value) {
                          setState(() {
                            _angkutanissingle = value.toString();
                          });
                        },
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
                'Ada Pemisah Antar Bahan/Barang',
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
                        onChanged: (value) {
                          setState(() {
                            _angkutansegregate = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Tidak'),
                      leading: Radio(
                        value: '0',
                        groupValue: _angkutansegregate,
                        onChanged: (value) {
                          setState(() {
                            _angkutansegregate = value.toString();
                          });
                        },
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
            title: const Text('Detail Alokasi'),
            content: Column(children: childrendetail)),
        Step(
            state:
                _activeStepIndex <= 7 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 7,
            title: const Text('Foto'),
            content: Column(
              children: [
                Wrap(children: children),
                // ignore: unnecessary_null_comparison
                Row(
                  children: [
                    Expanded(
                        child: new_imagefiles.isNotEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 50, right: 40),
                                child: Wrap(
                                  children: new_imagefiles.map((imageone) {
                                    return InkWell(
                                        onTap: () {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: 200,
                                                  color: Colors.purple,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        const Text(
                                                            'Yakin ingin menghilangkan foto ini?',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white)),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .white),
                                                          child: const Text(
                                                              'tekan tombol ini untuk menghilangkan foto',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black)),
                                                          onPressed: () {
                                                            new_imagefiles
                                                                .remove(
                                                                    imageone);
                                                            Navigator.pop(
                                                                context);
                                                            CoolAlert.show(
                                                                context:
                                                                    context,
                                                                type:
                                                                    CoolAlertType
                                                                        .success,
                                                                text:
                                                                    'Foto berhasil dihilangkan',
                                                                title:
                                                                    'Success');
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });

                                          setState(() {});
                                        },
                                        child: Card(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child:
                                                Image.file(File(imageone.path)),
                                          ),
                                        ));
                                  }).toList(),
                                ))
                            : const Text(''))
                  ],
                )
              ],
            ))
      ];
  @override
  Widget build(BuildContext context) => loading
      ? const Loading()
      : Scaffold(
          body: SafeArea(
              child: LoadingOverlay(
                  isLoading: overlayloading,
                  opacity: 0.8,
                  progressIndicator:
                      SpinKitFadingCube(color: Colors.purple[300], size: 70.0),
                  color: Colors.grey[100],
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 10, right: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Stepper(
                                controlsBuilder: (context, details) {
                                  return Row(
                                    children: const <Widget>[
                                      TextButton(
                                          onPressed: null, child: Text('')),
                                      TextButton(
                                          onPressed: null, child: Text('')),
                                    ],
                                  );
                                },
                                physics: const ClampingScrollPhysics(),
                                type: StepperType.vertical,
                                currentStep: _activeStepIndex,
                                steps: stepList(),
                                onStepTapped: (int index) {
                                  setState(() {
                                    _activeStepIndex = index;
                                  });
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: Row(children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: const Text('Confirm'),
                                      onPressed: () {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            text: 'Pastikan data sudah sesuai',
                                            confirmBtnText: 'Yes',
                                            cancelBtnText: 'No',
                                            confirmBtnColor: Colors.green,
                                            onConfirmBtnTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              // print(cart[0].tLvdQtyRcvd);
                                              saveData();
                                            },
                                            onCancelBtnTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              print('cancel');
                                            });
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                            ]),
                      )
                    ],
                  ))));
}
