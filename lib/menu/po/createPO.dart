import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/menu/po/alokasiPO.dart';
import 'package:flutter_template/menu/po/model/wsaPoModel.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_template/utils/loading.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class createpo extends StatefulWidget {
  final List<Data> selectedline;
  final List<dynamic> listLocation;

  const createpo(
      {Key? key, required this.selectedline, required this.listLocation})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _createpoState createState() => _createpoState();
}

// ignore: camel_case_types
class _createpoState extends State<createpo> {
  final _formKey = GlobalKey<FormState>();

  var listPrefix = [];
  var valueprefix = '';
  int totalpengiriman = 1; // 1 karena perlu + 1 untuk nomor IMR Berikut.

  // Step 3
  bool _certificateChecked = false;
  bool _msdsChecked = false;
  bool _forwarderdoChecked = false;
  bool _packinglistChecked = false;
  bool _otherdocsChecked = false;

  // Step 4
  bool _sackordosChecked = false;
  String? _sackordosDamage;
  bool _drumorvatChecked = false;
  String? _drumorvatDamage;
  bool _palletorpetiChecked = false;
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

  Future<bool> getPrefixIMR() async {
    try {
      final token = await UserSecureStorage.getToken();

      final Uri url = Uri.parse('${globals.globalurl}/getprefiximr');

      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      }).timeout(const Duration(milliseconds: 5000), onTimeout: () {
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

      if (response.statusCode == 200) {
        // Value & Isi Dropdown
        final result = jsonDecode(response.body);

        final body = result['data'];

        valueprefix = body[0]['pin_prefix'] + '|' + body[0]['pin_rn'];
        listPrefix = body;

        // Cek Tahun berjalan & tahun RN
        DateTime now = DateTime.now();
        int currentYear = now.year % 100;
        var oldyear = int.parse(body[0]['pin_rn'].substring(0, 2));

        // Hitung Total Pengiriman tahun berjalan
        for (var element in listPrefix) {
          if (int.parse(element['pin_rn'].substring(0, 2)) == currentYear) {
            String rn = element['pin_rn'].substring(2);
            int numericRn = int.parse(rn);
            totalpengiriman += numericRn;
          }
        }

        // Cek Nomor RN per Prefix per Tahun
        var newrn = '01';
        if (oldyear == currentYear) {
          var oldrn = int.parse(body[0]['pin_rn'].substring(2));
          newrn = (oldrn + 1).toString().padLeft(2, '0');
        }

        var prefix = body[0]['pin_prefix'];
        var totalrn = totalpengiriman.toString().padLeft(3, '0');

        var fullimr = prefix + '/' + newrn + '/' + totalrn;
        imrno.text = fullimr;
        return true;
      } else {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "PO Number Not Found"));
        return false;
      }
    } on Exception catch (e) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "No Internet"));
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    itemno.text = widget.selectedline[0].tLvcPart ?? '';
    itemname.text = widget.selectedline[0].tLvcPartDesc ?? '';
    supplier.text =
        '${widget.selectedline[0].tLvcVend} - ${widget.selectedline[0].tLvcVendDesc}';

    final now = DateTime.now();

    arrivaldate.text = DateFormat('yyyy-MM-dd').format(now);
    imrdate.text = DateFormat('yyyy-MM-dd').format(now);
    manufacturer.text = widget.selectedline[0].tLvcManufacturer ?? '';

    getPrefixIMR();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _activeStepIndex = 0;
  bool loading = false;
  bool overlayloading = false;

  // Step 1
  TextEditingController itemno = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController supplier = TextEditingController();
  // Step 2
  TextEditingController imrno = TextEditingController();
  TextEditingController arrivaldate = TextEditingController();
  TextEditingController imrdate = TextEditingController();
  TextEditingController dono = TextEditingController();
  TextEditingController articleno = TextEditingController();
  TextEditingController proddate = TextEditingController();
  TextEditingController expdate = TextEditingController();
  TextEditingController manufacturer = TextEditingController();
  TextEditingController origincountry = TextEditingController();
  // Step 3
  TextEditingController certificate = TextEditingController();
  TextEditingController msds = TextEditingController();
  TextEditingController forwaderdo = TextEditingController();
  TextEditingController packinglist = TextEditingController();
  TextEditingController otherdocs = TextEditingController();

  // Step 4
  TextEditingController keteranganisclean = TextEditingController();
  TextEditingController keteranganisdry = TextEditingController();
  TextEditingController keteranganisnotspilled = TextEditingController();

  // Step 5
  TextEditingController transporterno = TextEditingController();
  TextEditingController policeno = TextEditingController();
  TextEditingController angkutanketeranganisclean = TextEditingController();
  TextEditingController angkutanketeranganisdry = TextEditingController();
  TextEditingController angkutanketeranganisnotspilled =
      TextEditingController();
  TextEditingController angkutanketeranganissingle = TextEditingController();
  TextEditingController angkutanketeranganissegregated =
      TextEditingController();
  // Tambahan User
  TextEditingController angkutancatatan = TextEditingController();
  TextEditingController kelembapan = TextEditingController();
  TextEditingController suhu = TextEditingController();

  // Step 6
  String? _currline;
  // List<dynamic>? _currline;

  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  DateTime selectedArrivalDate = DateTime.now();
  DateTime selectedImrDate = DateTime.now();
  DateTime selectedManufDate = DateTime.now();
  DateTime selectedExpDate = DateTime.now();

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Detail PO'),
          content: Column(
            children: [
              _textInputReadonly(
                hint: "Item No.",
                controller: itemno,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInputReadonly(
                hint: "Item Name",
                controller: itemname,
              ),
              const SizedBox(
                height: 8,
              ),
              _textInputReadonly(
                hint: "Supplier",
                controller: supplier,
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Color.fromARGB(255, 157, 154, 154),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        itemHeight: 60,
                        hint: const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Select Prefix',
                                border: InputBorder.none,
                                labelText: 'Select Prefix'),
                          ),
                        ),
                        value: valueprefix,
                        // ignore: prefer_const_literals_to_create_immutables
                        items: listPrefix.map((value) {
                          return DropdownMenuItem(
                              value: '${value['pin_prefix']}|${value['pin_rn']}'
                                  .toString(),
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                      "Prefix : ${value['pin_prefix']}, Running Number : ${value['pin_rn']}"),
                                ),
                              ));
                        }).toList(),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (value) {
                          setState(() {
                            valueprefix = value!;
                            totalpengiriman = 1;
                            List<String> parts = value.split('|');

                            // Cek Tahun berjalan & tahun RN
                            DateTime now = DateTime.now();
                            int currentYear = now.year % 100;
                            var oldyear = int.parse(parts[1].substring(0, 2));

                            // Hitung Total Pengiriman tahun berjalan
                            for (var element in listPrefix) {
                              if (int.parse(
                                      element['pin_rn'].substring(0, 2)) ==
                                  currentYear) {
                                String rn = element['pin_rn'].substring(2);
                                int numericRn = int.parse(rn);
                                totalpengiriman += numericRn;
                              }
                            }

                            // Cek Nomor RN per Prefix per Tahun
                            var newrn = '01';
                            if (oldyear == currentYear) {
                              var oldrn = int.parse(parts[1].substring(2));
                              newrn = (oldrn + 1).toString().padLeft(2, '0');
                            }

                            var prefix = parts[0];
                            var totalrn =
                                totalpengiriman.toString().padLeft(3, '0');

                            var fullimr = prefix + '/' + newrn + '/' + totalrn;
                            imrno.text = fullimr;
                          });
                        })),
              ),
              const SizedBox(
                height: 8,
              ),
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
              TextFormField(
                  controller: arrivaldate,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_rounded),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                          initialDate: selectedArrivalDate,
                        );
                        if (picked != null && picked != selectedArrivalDate) {
                          setState(() {
                            selectedArrivalDate = picked;
                          });
                          arrivaldate.text = DateFormat('yyyy-MM-dd')
                              .format(selectedArrivalDate);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Arrival Date',
                  )),
              const SizedBox(
                height: 8,
              ),
              TextField(
                  controller: imrdate,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_rounded),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                          initialDate: selectedImrDate,
                        );
                        if (picked != null && picked != selectedImrDate) {
                          setState(() {
                            selectedImrDate = picked;
                          });
                          imrdate.text =
                              DateFormat('yyyy-MM-dd').format(selectedImrDate);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'IMR Date',
                  )),
              const SizedBox(
                height: 8,
              ),
              TextField(
                  controller: proddate,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_rounded),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                          initialDate: selectedManufDate,
                        );
                        if (picked != null && picked != selectedManufDate) {
                          setState(() {
                            selectedManufDate = picked;
                          });
                          proddate.text = DateFormat('yyyy-MM-dd')
                              .format(selectedManufDate);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Production Date',
                  )),
              const SizedBox(
                height: 8,
              ),
              TextField(
                  controller: expdate,
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
                          expdate.text =
                              DateFormat('yyyy-MM-dd').format(selectedExpDate);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Expiration Date',
                  )),
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
                    _sackordosDamage = '';
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
                      title: Text("Damage"),
                      value: "Damage",
                      groupValue: _sackordosDamage,
                      onChanged: (value) {
                        setState(() {
                          _sackordosDamage = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Undamage"),
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
                    _drumorvatDamage = '';
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
                      title: Text("Damage"),
                      value: "Damage",
                      groupValue: _drumorvatDamage,
                      onChanged: (value) {
                        setState(() {
                          _drumorvatDamage = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Undamage"),
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
                    _palletorpetiDamage = '';
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
                      title: Text("Damage"),
                      value: "Damage",
                      groupValue: _palletorpetiDamage,
                      onChanged: (value) {
                        setState(() {
                          _palletorpetiDamage = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Undamage"),
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
                      title: const Text('Clean'),
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
                      title: const Text('Dirty'),
                      leading: Radio(
                        value: '0',
                        groupValue: _isclean,
                        onChanged: (value) {
                          setState(() {
                            _isclean = value.toString();
                          });
                        },
                      ),
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
                      title: const Text('Dry'),
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
                      title: const Text('Wet'),
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
                      title: const Text('Not Spilled'),
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
                      title: const Text('Spilled'),
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
                      title: const Text('Intact'),
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
                      title: const Text('Broken'),
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
                      title: const Text('Intact'),
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
                      title: const Text('Broken'),
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
                      title: const Text('Clean'),
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
                      title: const Text('Dirty'),
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
                      title: const Text('Dry'),
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
                      title: const Text('Wet'),
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
                      title: const Text('Not Spilled'),
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
                      title: const Text('Spilled'),
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
                'Material Position',
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
                      title: const Text('Combination'),
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
                'Clear Segregation',
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
                      title: const Text('Yes'),
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
                      title: const Text('No'),
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
            state: _activeStepIndex <= 6 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 6,
            title: const Text('Detail Alokasi'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [],
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: null,
            body: SafeArea(
              child: LoadingOverlay(
                  isLoading: overlayloading,
                  opacity: 0.8,
                  progressIndicator:
                      SpinKitFadingCube(color: Colors.purple[300], size: 70.0),
                  color: Colors.grey[100],
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Form(
                            key: _formKey,
                            child: Stepper(
                              physics: const ClampingScrollPhysics(),
                              type: StepperType.vertical,
                              currentStep: _activeStepIndex,
                              steps: stepList(),
                              onStepContinue: () {
                                if (_activeStepIndex <
                                    (stepList().length - 1)) {
                                  setState(() {
                                    _activeStepIndex += 1;
                                  });
                                } else {
                                  if (transporterno.text == '') {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        text:
                                            'Transporter No. tidak boleh kosong');
                                    return;
                                  }
                                  if (policeno.text == '') {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        text: 'Police No. tidak boleh kosong');
                                    return;
                                  }
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: 'Lanjut ke Detail Alokasi Item?',
                                    confirmBtnText: 'Yes',
                                    cancelBtnText: 'No',
                                    confirmBtnColor: Colors.green,
                                    onConfirmBtnTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => alokasipo(
                                                selectedline:
                                                    widget.selectedline,
                                                listLocation:
                                                    widget.listLocation,
                                                imrno: imrno.text,
                                                arrivaldate: arrivaldate.text,
                                                imrdate: imrdate.text,
                                                dono: dono.text,
                                                articleno: articleno.text,
                                                proddate: proddate.text,
                                                expdate: expdate.text,
                                                manufacturer: manufacturer.text,
                                                origincountry:
                                                    origincountry.text,
                                                certificateChecked:
                                                    _certificateChecked,
                                                certificate: certificate.text,
                                                msdsChecked: _msdsChecked,
                                                msds: msds.text,
                                                forwarderdoChecked:
                                                    _forwarderdoChecked,
                                                forwaderdo: forwaderdo.text,
                                                packinglistChecked:
                                                    _packinglistChecked,
                                                packinglist: packinglist.text,
                                                otherdocsChecked:
                                                    _otherdocsChecked,
                                                otherdocs: otherdocs.text,
                                                keteranganisclean:
                                                    keteranganisclean.text,
                                                keteranganisdry:
                                                    keteranganisdry.text,
                                                keteranganisnotspilled:
                                                    keteranganisnotspilled.text,
                                                transporterno:
                                                    transporterno.text,
                                                policeno: policeno.text,
                                                angkutanketeranganisclean:
                                                    angkutanketeranganisclean
                                                        .text,
                                                angkutanketeranganisdry:
                                                    angkutanketeranganisdry
                                                        .text,
                                                angkutanketeranganisnotspilled:
                                                    angkutanketeranganisnotspilled
                                                        .text,
                                                angkutanketeranganissingle:
                                                    angkutanketeranganissingle
                                                        .text,
                                                angkutanketeranganissegregated:
                                                    angkutanketeranganissegregated
                                                        .text,
                                                sackordosChecked:
                                                    _sackordosChecked,
                                                sackordosDamage:
                                                    _sackordosDamage.toString(),
                                                drumorvatChecked:
                                                    _drumorvatChecked,
                                                drumorvatDamage:
                                                    _drumorvatDamage.toString(),
                                                palletorpetiChecked:
                                                    _palletorpetiChecked,
                                                palletorpetiDamage: _palletorpetiDamage.toString(),
                                                isclean: _isclean.toString(),
                                                isdry: _isdry.toString(),
                                                isnotspilled: _isnotspilled.toString(),
                                                issealed: _issealed.toString(),
                                                ismanufacturerlabel: _ismanufacturerlabel.toString(),
                                                angkutanisclean: _angkutanisclean.toString(),
                                                angkutanisdry: _angkutanisdry.toString(),
                                                angkutanisnotspilled: _angkutanisnotspilled.toString(),
                                                angkutanissingle: _angkutanissingle.toString(),
                                                angkutansegregate: _angkutansegregate.toString(),
                                                angkutancatatan: angkutancatatan.text,
                                                kelembapan: kelembapan.text,
                                                suhu: suhu.text)),
                                      );
                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           MyHomePage(title: 'halo')),
                                      // );
                                    },
                                  );
                                }
                              },
                              onStepCancel: () {
                                if (_activeStepIndex == 0) {
                                  return;
                                }

                                setState(() {
                                  _activeStepIndex -= 1;
                                });
                              },
                              onStepTapped: (int index) {
                                setState(() {
                                  _activeStepIndex = index;
                                });
                              },
                              controlsBuilder: (context, controls) {
                                final isLastStep =
                                    _activeStepIndex == stepList().length - 1;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: controls.onStepContinue,
                                        child: (isLastStep)
                                            ? const Text('Detail')
                                            : const Text('Next'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (_activeStepIndex > 0)
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: controls.onStepCancel,
                                          child: const Text('Back'),
                                        ),
                                      )
                                  ],
                                );
                              },
                            ))
                      ],
                    ),
                  )),
            ));
  }
}

Widget _textInput({controller, hint}) {
  return TextField(
    controller: controller,
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
