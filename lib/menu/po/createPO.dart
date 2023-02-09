import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/menu/po/wsaPoModel.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_template/utils/loading.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: camel_case_types
class createpo extends StatefulWidget {
  final List<Data> selectedline;

  const createpo({
    Key? key,
    required this.selectedline,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _createpoState createState() => _createpoState();
}

// ignore: camel_case_types
class _createpoState extends State<createpo> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    itemno.text = widget.selectedline[0].tLvcPart ?? '';
    itemname.text = widget.selectedline[0].tLvcPartDesc ?? '';
    supplier.text =
        '${widget.selectedline[0].tLvcVend} - ${widget.selectedline[0].tLvcVendDesc}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _activeStepIndex = 0;
  bool loading = false;
  bool overlayloading = false;

  // Step 1 --> Datanya pasti sama jadi pakai array 0
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
              _textInput(
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
              TextField(
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
          state: _activeStepIndex <= 5 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 5,
          title: const Text('Informasi Bahan Datang'),
          content: Column(
            children: [
              _textInputReadonly(
                hint: "Item No.",
                controller: itemno,
              ),
            ],
          ),
        ),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 6,
            title: const Text('Confirm'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Password: *****'),
                Text('Address : ${address.text}'),
                Text('PinCode : ${pincode.text}'),
              ],
            ))
      ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _activeStepIndex,
                    steps: stepList(),
                    onStepContinue: () {
                      if (_activeStepIndex < (stepList().length - 1)) {
                        setState(() {
                          _activeStepIndex += 1;
                        });
                      } else {
                        print('Submited');
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
                                  ? const Text('Submit')
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
