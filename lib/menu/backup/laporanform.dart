// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_template/utils/loading.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;
import '../../utils/styles.dart';

import 'package:advance_image_picker/advance_image_picker.dart';

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
  // late List<XFile>? imagesname;
  // late List<XFile>? imagesdata;
  // late List<XFile>? images;
  // XFile? imagefromphoto;
  // List<XFile> imagefiles = [];
  List<File> imagesPath = [];

  List<ImageObject> imagefiles = [];
  List<ImageObject> imagefilesroot = [];
  DateTime now = DateTime.now();

  Future pickImage() async {
    imagefilesroot = await Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
      return const ImagePicker(maxCount: 5);
    }));
    if (imagefilesroot?.isEmpty ?? true) {
      setState(() {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Mohon pilih foto"));
      });
    } else {
      imagefiles = imagefilesroot;
      imagesPath = [];
      for (var image in imagefiles) {
        imagesPath.add(File(image.originalPath));
      }
      setState(() {});
    }

    // if (imagefiles!.isNotEmpty) {
    //   // Process selected images

    //   for (var image in imagefiles!) {
    //     imagesPath.add(File(image.path));
    //     imagefiles.add(image);
    //     // Do something with the selected image
    //   }
    //   setState(() {});
    // } else if (images!.isEmpty) {
    //   // Display error message

    //   setState(() {
    //     ArtSweetAlert.show(
    //         context: context,
    //         artDialogArgs: ArtDialogArgs(
    //             type: ArtSweetAlertType.danger,
    //             title: "Error",
    //             text: "Mohon pilih foto"));
    //   });
    // }
    // await ImagePicker().pickImage(maxImages:3);
  }

  // Future takeImage() async {
  //   imagefromphoto = await ImagePicker().pickImage(source: ImageSource.camera);

  //   if (imagefromphoto != null) {
  //     imagefiles.add(imagefromphoto!);
  //     imagesPath.add(File(imagefromphoto!.path));

  //     // Process selected images

  //     setState(() {});
  //   } else if (imagefromphoto == null) {
  //     // Display error message

  //     setState(() {
  //       ArtSweetAlert.show(
  //           context: context,
  //           artDialogArgs: ArtDialogArgs(
  //               type: ArtSweetAlertType.danger,
  //               title: "Error",
  //               text: "Mohon pilih foto"));
  //     });
  //   }
  // }

  Future<Object?> sendlaporan(String url) async {
    final token = await UserSecureStorage.getToken();
    final username = await UserSecureStorage.getIdAnggota();
    url += '&username=' + username.toString();

    final Uri uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['authorization'] = "Bearer $token";

    for (var image in imagesPath) {
      if (image.existsSync()) {
        // Check if the file exists
        // Check if the file is an image file
        if (image.path.endsWith('.jpg') ||
            image.path.endsWith('.jpeg') ||
            image.path.endsWith('.png')) {
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
    var response = await request.send();
    print(request.files);
    final responsedata = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      if (responsedata.body == 'error') {
        Navigator.pop(context, 'refresh');
        return ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Failed to Submit report for receipt" + IdRcp.text));
      } else {
        Navigator.pop(context, 'refresh');

        return ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "Success",
                text: "Success to Submit report for receipt " + IdRcp.text));
      }
    } else {
      return ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to Submit report for receipt" + IdRcp.text));
    }
    // return response;
    // final response = await http.post(Uri.parse(url), headers: {
    //   HttpHeaders.contentTypeHeader: "application/json",
    //   HttpHeaders.authorizationHeader: "Bearer $token"
    // }).timeout(const Duration(seconds: 20), onTimeout: () {
    //   setState(() {
    //     ArtSweetAlert.show(
    //         context: context,
    //         artDialogArgs: ArtDialogArgs(
    //             type: ArtSweetAlertType.danger,
    //             title: "Error",
    //             text: "Failed to load data"));
    //   });
    //   return http.Response('Error', 500);
    // });
    // responseresult = response.body.toString();

    // if (response.body == 'success') {
    //   Navigator.pop(context, 'refresh');

    //   return ArtSweetAlert.show(
    //       context: context,
    //       artDialogArgs: ArtDialogArgs(
    //           type: ArtSweetAlertType.success,
    //           title: "Success",
    //           text: "Success to Submit report for receipt " + IdRcp.text));
    // } else if (response.body == 'error') {
    //   Navigator.pop(context, 'refresh');
    //   return ArtSweetAlert.show(
    //       context: context,
    //       artDialogArgs: ArtDialogArgs(
    //           type: ArtSweetAlertType.danger,
    //           title: "Error",
    //           text: "Failed to Submit report for receipt" + IdRcp.text));
    // }
    // ;
    // return response;
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
    Tanggal = TextEditingController(text: DateFormat('yyyy-MM-dd').format(now));
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
  Widget build(BuildContext context) {
    // Setup image picker configs
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.black;
    // Disable select images from album
    configs.albumPickerModeEnabled = true;
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

    // configs.externalImageEditors['external_image_editor_2'] = EditorParams(
    //     title: 'external_image_editor_2',
    //     icon: Icons.edit_attributes,
    //     onEditorEvent: (
    //             {required BuildContext context,
    //             required File file,
    //             required String title,
    //             int maxWidth = 1080,
    //             int maxHeight = 1920,
    //             int compressQuality = 90,
    //             ImagePickerConfigs? configs}) async =>
    //         Navigator.of(context).push(MaterialPageRoute(
    //             fullscreenDialog: true,
    //             builder: (context) => ImageSticker(
    //                 file: file,
    //                 title: title,
    //                 maxWidth: maxWidth,
    //                 maxHeight: maxHeight,
    //                 configs: configs))));

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
                                    'Anda yakin ingin submit Receipt ' +
                                        IdRcp.text +
                                        '?',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: const Text(
                                      'Tekan tahan tombol untuk melanjutkan',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black)),
                                  onPressed: () {},
                                  onLongPress: () {
                                    String url =
                                        '${globals.globalurl}/submitlaporan?';
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
                                    url += '&komplaindetail=' +
                                        KomplainDetail.text;
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
                  margin: const EdgeInsets.only(top: 50, right: 40),
                  child: Row(children: [
                    if (currentStep != 0)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 40)),
                          child: const Text('BACK'),
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
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Data RCP'),
          content: Column(
            children: <Widget>[
              TextFormField(
                // controller: null,
                controller: IdRcp,
                decoration: const InputDecoration(labelText: 'ID RCP'),
                // initialValue: widget.rcpt_nbr,
                readOnly: true,
              ),
              TextFormField(
                controller: No,
                decoration: const InputDecoration(labelText: 'No'),
              ),
              TextFormField(
                controller: Tanggal,
                decoration: const InputDecoration(labelText: 'Tanggal'),
                readOnly: true,
                // onTap: () {
                //   showDatePicker(
                //       context: context,
                //       initialDate: Tanggal != ''
                //           ? DateTime.parse(widget.rcpt_date)
                //           : DateTime.now(),
                //       firstDate: DateTime(2000, 1),
                //       lastDate: DateTime(2100, 12),
                //       builder: (context, picker) {
                //         return Theme(
                //           data: ThemeData.light().copyWith(
                //             colorScheme: ColorScheme.light(
                //               backgroundColor: Colors.blue.shade400,
                //             ),
                //             // textButtonTheme: TextButtonThemeData(
                //             //   style: TextButton.styleFrom(
                //             //     textStyle: TextStyle(color: Colors.white)
                //             //   )
                //             // ),
                //             // dialogBackgroundColor: Colors.white
                //           ),
                //           child: picker!,
                //         );
                //       }).then((selectedDate) {
                //     if (selectedDate != null) {
                //       Tanggal.text = DateFormat('yyyy-MM-dd')
                //           .format(selectedDate)
                //           .toString();
                //     }
                //   });
                // },
              ),
              TextFormField(
                controller: Supplier,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Supplier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: Komplain,
                decoration: const InputDecoration(labelText: 'Komplain'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: Keterangan,
                decoration: const InputDecoration(labelText: 'Keterangan'),
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
          title: const Text('Detail'),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: NamaBarang,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TglMasuk,
                decoration: const InputDecoration(labelText: 'Tgl Masuk'),
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
                decoration: const InputDecoration(labelText: 'Jumlah Masuk'),
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
                decoration: const InputDecoration(labelText: 'Komplain'),
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
                decoration: const InputDecoration(labelText: 'PO'),
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
                decoration: const InputDecoration(labelText: 'No Lot'),
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
                decoration: const InputDecoration(labelText: 'Angkutan'),
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
                decoration: const InputDecoration(labelText: 'No Pol'),
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
          title: const Text('Complete'),
          content: Column(children: <Widget>[
            Table(
                border: TableBorder.all(color: Colors.transparent),
                children: [
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'ID RCP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        IdRcp.text,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                        height: 50,
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        )),
                    Container(
                      height: 50,
                      child: Text(
                        No.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Tanggal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Tanggal.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Supplier',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Supplier.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Komplain',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Komplain.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Keterangan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Keterangan.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Nama Barang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        NamaBarang.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Tanggal Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        TglMasuk.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Jumlah Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        JumlahMasuk.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Komplain',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        KomplainDetail.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'PO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        PO.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Nomor Lot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        NomorLot.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Angkutan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        Angkutan.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      child: const Text(
                        'Nomor Polisi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        NoPol.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      height: 50,
                      alignment: Alignment.topRight,
                      child: const Text(
                        'Foto',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: const Text(''),
                    ),
                  ]),
                  // TableRow(children: [
                  // Container(
                  //   height: 50,
                  //   alignment: Alignment.centerLeft,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.orange[400],
                  //         minimumSize: Size(100, 50)),
                  //     child: const Text('Pick Images',
                  //         style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 15,
                  //             color: Colors.black)),
                  //     onPressed: () => pickImage(),
                  //   ),
                  // ),
                  // Container(
                  //   height: 50,
                  //   alignment: Alignment.centerLeft,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.yellow[300],
                  //         minimumSize: Size(100, 50)),
                  //     child: const Text('Take Photo',
                  //         style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 15,
                  //             color: Colors.black)),
                  //     onPressed: () => takeImage(),
                  //   ),
                  // ),
                  // ]),
                  // ],
                ]),
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[400],
                    minimumSize: const Size(270, 50)),
                child: const Text('Pick Images',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black)),
                onPressed: () => pickImage(),
              ),
            ),
            (imagefiles?.isNotEmpty == true && imagefiles != [])
                ? Container(
                    margin: const EdgeInsets.only(top: 50, right: 40),
                    child: Wrap(
                      children: imagefiles.map((imageone) {
                        return InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      color: Colors.yellow,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text(
                                                'Yakin ingin menghilangkan foto ini?',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black)),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.white),
                                              child: const Text(
                                                  'tekan tombol ini untuk menghilangkan foto',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black)),
                                              onPressed: () {
                                                imagefiles.remove(imageone);
                                                Navigator.pop(context);
                                                ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                        type: ArtSweetAlertType
                                                            .success,
                                                        title: "Success",
                                                        text:
                                                            "Foto berhasil dihilangkan"));
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
                                child: Image.file(File(imageone.originalPath)),
                              ),
                            ));
                      }).toList(),
                    ))
                : Padding(
                    padding: const EdgeInsets.only(top: 10, right: 30),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.purpleAccent,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        title: Text(
                          "No Picture(s) Selected",
                          style: content,
                        ),
                      ),
                    )),
          ]),
        ),
      ];
}
