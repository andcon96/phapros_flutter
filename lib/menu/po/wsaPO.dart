import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/menu/po/wsaPoModel.dart';
import 'package:flutter_template/utils/styles.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_template/utils/loading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';

// ignore: camel_case_types
class wsaPO extends StatefulWidget {
  const wsaPO({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _wsaPOState createState() => _wsaPOState();
}

// ignore: camel_case_types
class _wsaPOState extends State<wsaPO> {
  final TextEditingController _textCont = TextEditingController();

  bool overlayLoading = false;
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    final exit = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exit?',
                    style: title,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Changes will not be saved', style: subTitle)
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'NO',
                  style: content,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  'YES',
                  style: content,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    return Future.value(exit);
  }

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool notSearch = true;
  List<Data> detailpo = [];
  List<Data> selectedDetailPO = [];

  Future<bool> getWsaPO(String? search) async {
    try {
      setState(() => overlayLoading = true);
      final Uri url =
          Uri.parse('http://192.168.18.186:8000/api/wsapo?ponbr=$search');

      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(const Duration(milliseconds: 5000), onTimeout: () {
        notSearch = true;
        detailpo = [];
        setState(() {
          overlayLoading = false;
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Error",
                  text: "Failed to load data"));
        });
        return http.Response('Error', 500);
      });

      setState(() => overlayLoading = false);
      if (response.statusCode == 200) {
        notSearch = false;
        // print(response.body);
        final result = WsaPOFromJson(response.body);
        detailpo = result.data!;

        return true;
      } else {
        notSearch = true;
        detailpo = [];
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "PO Number Not Found"));
        return false;
      }
    } on Exception catch (e) {
      setState(() => overlayLoading = false);
      detailpo = [];
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
    overlayLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: loading
            ? const Loading()
            : Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: null,
                body: SafeArea(
                  child: LoadingOverlay(
                      isLoading: overlayLoading,
                      opacity: 0.8,
                      progressIndicator: SpinKitFadingCube(
                          color: Colors.purple[300], size: 70.0),
                      color: Colors.grey[100],
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height:
                                height * 0.2, //height to 9% of screen height,
                            width: width, //width t 40% of screen width
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        "Search PO",
                                        style: titleForm,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Please find based on PO Number.",
                                        style: subTitleForm,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 2, 10, 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.indigo)),
                                        child: TextField(
                                          controller: _textCont,
                                          textInputAction:
                                              TextInputAction.search,
                                          onSubmitted: (value) {
                                            getWsaPO(_textCont.text);
                                          },
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black87,
                                              fontSize: 15),
                                          decoration: InputDecoration(
                                              hintText: 'Search',
                                              hintStyle: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                              contentPadding:
                                                  const EdgeInsets.all(17.0),
                                              prefixIcon: const Icon(
                                                  Iconsax.search_normal),
                                              suffixIcon: _textCont
                                                      .text.isNotEmpty
                                                  ? GestureDetector(
                                                      child: const Icon(
                                                          Iconsax.close_square),
                                                      onTap: () async {
                                                        _textCont.clear();
                                                        FocusScopeNode
                                                            currentFocus =
                                                            FocusScope.of(
                                                                context);
                                                        currentFocus.unfocus();
                                                      },
                                                    )
                                                  : null,
                                              border: InputBorder.none),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          detailpo.isEmpty && notSearch
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Card(
                                    elevation: 0,
                                    shadowColor: Colors.red,
                                    shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ListTile(
                                      title: Text(
                                        "No Data Available",
                                        style: content,
                                      ),
                                    ),
                                  ))
                              : SizedBox(
                                  height: height * 0.7,
                                  width: width,
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      final user = detailpo[index];

                                      return ListItemPO(
                                          user.tLviLine ?? '',
                                          user.tLvcPart ?? '',
                                          user.tLvcPartDesc ?? '',
                                          user.tLvdQtyord ?? '0',
                                          user.tLvdPrice ?? '0',
                                          user.tIsSelected ?? false,
                                          index);
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemCount: detailpo.length,
                                  ),
                                )
                        ],
                      )),
                ),
                floatingActionButton: detailpo.isEmpty && notSearch
                    ? Container()
                    : FloatingActionButton(
                        onPressed: () {
                          var currentvalue = '';
                          // Validasi Harus sama Itemnya
                          for (var valuepo in selectedDetailPO) {
                            if (currentvalue != valuepo.tLvcPart &&
                                currentvalue.isNotEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: 'Error',
                                text: 'Cannot choose different Part Code',
                                loopAnimation: false,
                              );
                              break;
                            }
                            currentvalue = valuepo.tLvcPart ?? '';
                          }

                          selectedDetailPO.isEmpty
                              ? CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: 'Error',
                                  text: 'Please Select Data',
                                  loopAnimation: false,
                                )
                              : print('ok');
                        },
                        backgroundColor: Colors.purple,
                        child: const Icon(
                          Icons.arrow_forward_sharp,
                          color: Colors.white,
                        ),
                      ),
              ));
  }

  // ignore: non_constant_identifier_names
  Widget ListItemPO(String line, String part, String partdesc, String qtyord,
      String price, bool isSelected, int index) {
    return ListTile(
      // ignore: prefer_const_constructors
      leading: CircleAvatar(
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.adjust,
          color: Colors.white,
        ),
      ),
      title: Text(
        'Line : $line, Part : $part - $partdesc',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text('Qty Order : $qtyord, Price: $price'),
      trailing: isSelected
          // ignore: prefer_const_constructors
          ? Icon(
              Icons.check_circle,
              color: Colors.purpleAccent[400],
            )
          : const Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
      onTap: () {
        setState(() {
          detailpo[index].tIsSelected = !detailpo[index].tIsSelected!;
          if (detailpo[index].tIsSelected == true) {
            selectedDetailPO.add(Data(
                tLviLine: line,
                tLvcPart: part,
                tLvdQtyord: qtyord,
                tLvdPrice: price));
          } else if (detailpo[index].tIsSelected == false) {
            selectedDetailPO.removeWhere(
                (element) => element.tLviLine == detailpo[index].tLviLine);
          }
        });
      },
    );
  }
}
