// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, must_be_immutable, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/laporanform.dart';
import 'package:flutter_template/menu/po/signaturePage.dart';
import 'package:flutter_template/menu/po/wsaPO.dart';
// import 'package:image_picker/image_picker.dart';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/menu/po/model/wsaPoModel.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;
import '../../utils/loading.dart';
import '../../utils/secure_user_login.dart';
import '../../utils/styles.dart';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:intl/intl.dart';

// State Utama
class uploadfilepo extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  uploadfilepo(
      {Key? key,
      required this.cart,
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
      required this.angkutancatatan,
      required this.kelembapan,
      required this.suhu,
      required this.itemcode})
      : super(key: key);

  final List<Data> cart;
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
  _uploadfilepoState createState() => _uploadfilepoState();
}

class _uploadfilepoState extends State<uploadfilepo> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  Uint8List? signature;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  final ImagePicker imgpicker = ImagePicker();
  // List<XFile>? imagefiles;
  List<ImageObject> imagefiles = [];
  List<ImageObject>? imagefilesroot = [];
  List<File> imagesPath = [];
  openImages() async {
    imagefilesroot = await Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
      return const ImagePicker(maxCount: 5);
    }));
    if (imagefilesroot?.isEmpty ?? true) {
      setState(() {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'Mohon pilih foto',
            title: 'Error');
      });
    } else {
      imagefiles = imagefilesroot!;
      imagesPath = [];
      for (var image in imagefiles) {
        imagesPath.add(File(image.originalPath));
      }
      setState(() {});
    }
  }
  // openImages() async {
  //   try {
  //     var pickedfiles = await imgpicker.pickMultiImage();
  //     //you can use ImageCourse.camera for Camera capture
  //     if (pickedfiles != null) {
  //       imagefiles = pickedfiles;
  //       for (var image in pickedfiles) {
  //         imagesPath.add(File(image.path));
  //       }
  //       // print(imagesPath);
  //       setState(() {});
  //     } else {
  //       CoolAlert.show(
  //           context: context,
  //           type: CoolAlertType.error,
  //           text: 'No Image Selected',
  //           title: 'Error');
  //     }
  //   } catch (e) {
  //     CoolAlert.show(
  //         context: context,
  //         type: CoolAlertType.error,
  //         text: 'Terdapat Error ketika upload foto',
  //         title: 'Error');
  //   }
  // }

  Widget ttdbtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: FloatingActionButton(
        onPressed: () async {
          final signatureImage = await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => CreateSignature(),
            ),
          );
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(builder: (context) => CreateSignature()),
          // );
          setState(() {
            signature = signatureImage;
          });
        },
        heroTag: "ttdbtn",
        tooltip: 'Tambah Data',
        backgroundColor: Colors.purple,
        child: Icon(Icons.approval_sharp),
      ),
    );
  }

  Widget imagebtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: FloatingActionButton(
        onPressed: () {
          imagesPath.clear();
          openImages();
          setState(() {});
        },
        heroTag: "addbtn",
        tooltip: 'Tambah Data',
        backgroundColor: Colors.purple,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget confirmbtn() {
    return loading
        ? Loading()
        : Container(
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
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {
                      loading = true;
                    });
                    saveData();
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

  Future saveData() async {
    try {
      final nik = await UserSecureStorage.getUsername();
      final token = await UserSecureStorage.getToken();
      final idanggota = await UserSecureStorage.getIdAnggota();

      final Uri url = Uri.parse('${globals.globalurl}/savepo');
      final request = http.MultipartRequest('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['authorization'] = "Bearer $token";

      for (var image in imagesPath) {
        if (image.existsSync()) {
          // Check if the file exists
          // Check if the file is an image file
          if (image.path.endsWith('.jpg') ||
              image.path.endsWith('.jpeg') ||
              image.path.endsWith('.png')) {
            // Check if the file size is less than 10MB
            if (image.lengthSync() <= 10 * 1024 * 1024) {
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
        "data": jsonEncode(widget.cart),
        "nik": nik,
        "id_anggota": idanggota,

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
        "angkutan_catatan": widget.angkutancatatan,
        "kelembapan": widget.kelembapan,
        "suhu": widget.suhu,
        "itemcode": widget.itemcode,

        if (signature != null)
          'signature': base64Encode(signature!)
        else
          'signature': '',
      };

      final stringBody =
          body.map((key, value) => MapEntry(key, value.toString()));

      request.fields.addAll(stringBody);

      var response = await request.send();
      final responsedata = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });

        var cart = widget.cart;
        var flg = 0; // 1 => Ada Qty Reject, kasi opsi ke Form Reject.
        for (var data in cart) {
          var qtyReject = int.parse(data.tLvdQtyReject ?? '0');

          if (qtyReject > 0) {
            flg = 1;
          }
        }

        if (flg == 0) {
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
                var totalArrival =
                    jsonDecode(responsedata.body)['totalArrival'];
                var totalApprove =
                    jsonDecode(responsedata.body)['totalApprove'];
                var totalReject = jsonDecode(responsedata.body)['totalReject'];
                // print(datareceipt['get_transport'][0]['rcptt_transporter_no']);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => laporanform(
                        ponbr: datareceipt['getpo']['po_nbr'].toString(),
                        rcpt_nbr: datareceipt['rcpt_nbr'].toString(),
                        rcpt_date: datareceipt['rcpt_date'].toString(),
                        rcptd_part: datareceipt['get_detail_reject'][0]
                                ['rcptd_part']
                            .toString(),
                        rcptd_qty_arr: totalArrival.toString(),
                        rcptd_lot: datareceipt['get_detail_reject'][0]
                                ['rcptd_lot']
                            .toString(),
                        rcptd_loc: datareceipt['get_detail_reject'][0]
                                ['rcptd_loc']
                            .toString(),
                        rcptd_qty_appr: totalApprove.toString(),
                        rcptd_qty_rej: totalReject.toString(),
                        nopol: datareceipt['get_transport']['rcptt_police_no']
                            .toString(),
                        angkutan: datareceipt['get_transport']
                                ['rcptt_transporter_no']
                            .toString(),
                        supplier: datareceipt['getpo']['po_vend'].toString(),
                      ),
                    ),
                    (route) => route.isFirst);
              },
              onCancelBtnTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => wsaPO(),
                    ),
                    (route) => route.isFirst);
              });
        }

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
        text: 'Tidak ada Internet',
        loopAnimation: false,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Setup image picker configs
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.black;
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };

    // Example about custom stickers
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png'
    ];
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
                child: Column(
                  children: [
                    Divider(),
                    Text(
                      "Upload Image & Tanda Tangan Driver",
                      style: titleForm,
                    ),
                    Divider(),
                    Text("Daftar Foto:"),
                    Divider(),
                    imagefiles != null
                        ? Wrap(
                            children: imagefiles!.map((imageone) {
                              return Container(
                                  child: Card(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child:
                                      Image.file(File(imageone.originalPath)),
                                ),
                              ));
                            }).toList(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Card(
                              elevation: 5,
                              shadowColor: Colors.purpleAccent,
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Text(
                                  "Belum Ada Foto yang Dipilih",
                                  style: content,
                                ),
                              ),
                            )),
                    SizedBox(
                      height: 40,
                    ),
                    Divider(),
                    Text("Tanda Tangan Driver"),
                    Divider(),
                    if (signature != null)
                      Image.memory(signature!)
                    else
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.purpleAccent,
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: ListTile(
                              title: Text(
                                "Belum ada Tanda Tangan",
                                style: content,
                              ),
                            ),
                          )),
                  ],
                ),
              ),
            ),
            floatingActionButton: AnimatedFloatingActionButton(
                fabButtons: [
                  confirmbtn(),
                  ttdbtn(),
                  imagebtn(),
                ],
                key: key,
                colorStartAnimation: Colors.purple,
                colorEndAnimation: Colors.purpleAccent,
                animatedIconData: AnimatedIcons.menu_close));
  }
}
