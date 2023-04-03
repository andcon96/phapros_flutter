import 'dart:async';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/menu/receiptapproval/model/receiptModel.dart';
import 'package:flutter_template/menu/po/wsaPO.dart';
import 'package:flutter_template/menu/receiptapproval/receiptview.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_template/utils/styles.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:flutter_template/menu/receiptapproval/services/receiptServices.dart';
import 'package:flutter_template/menu/receiptapproval/receiptform.dart';
import 'package:flutter_template/utils/secure_user_login.dart';

import 'package:http/http.dart' as http;

// import 'poModel.dart';
String userid = '';

class receiptbrowse extends StatefulWidget {
  const receiptbrowse({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _receiptbrowse createState() => _receiptbrowse();
}

class _receiptbrowse extends State<receiptbrowse> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  final _textCont = TextEditingController();
  String _custId = "";

  // int currentPage = 1;
  // late int totalPage;
  bool loadfailed = false;
  bool overlayloading = false;
  bool onStart = false;
  List<receiptModel> datapo = [];

  void Changedata() async {
    loadfailed = true;
    loadfailed = false;
    final result = await getPassData(isRefresh: true, search: _textCont.text);
    if (result) {
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
  }

  Future<bool> getPassData({bool isRefresh = false, String? search}) async {
    try {
      // if (isRefresh) {
      //   currentPage = 1;
      // } else {
      //   if (currentPage > totalPage) {
      //     refreshController.loadNoData();
      //     return false;
      //   }
      // }

      final id = await UserSecureStorage.getUsername();
      final token = await UserSecureStorage.getToken();
      final usrr =
          await UserSecureStorage.getIdAnggota().then((String? strusername) {
        userid = strusername.toString();
      });

      final Uri url = Uri.parse(
          'http://192.168.18.185:8000/api/getreceipt?user=' +
              userid +
              '&rcptnbr=' +
              search.toString());

      loadfailed = false;
      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      }).timeout(const Duration(seconds: 20), onTimeout: () {
        setState(() {
          loadfailed = true;
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Error",
                  text: "Failed to load data"));
          refreshController.refreshFailed();
        });
        return http.Response('Error', 500);
      });

      if (response.statusCode == 200) {
        if (response.body == '') {
          setState(() {
            datapo = [];
          });
        } else {
          final result =
              receiptServices.searchdata(response.body).then((newlist) {
            setState(() {
              datapo = newlist;
            });
          });
        }

        onStart = true;

        setState(() {});
        return true;
      } else {
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

  Future init() async {
    final custid = await UserSecureStorage.getCustid();
    _custId = custid!;
  }

  @override
  void initState() {
    super.initState();
    // _getData();
    init();
  }

  _getData() {
    receiptServices.getdata().then((list) {
      setState(() {
        datapo = list;
      });
    });
  }

  Timer? debouncer;
  @override
  void dispose() {
    super.dispose();
    debouncer?.cancel();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffeceff1), Color(0xfffafafa)],
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter)),
          child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: _textCont,
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
                          prefixIcon: const Icon(Iconsax.search_normal),
                          suffixIcon: _textCont.text.isNotEmpty
                              ? GestureDetector(
                                  child: const Icon(Iconsax.close_square),
                                  onTap: () async {
                                    _textCont.clear();
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    currentFocus.unfocus();

                                    final result = await getPassData(
                                        isRefresh: true,
                                        search: _textCont.text);
                                    if (result) {
                                      refreshController.loadComplete();
                                      refreshController.refreshCompleted();
                                    } else {
                                      refreshController.refreshFailed();
                                    }
                                  },
                                )
                              : null,
                          border: InputBorder.none),
                      onChanged: (text) async {
                        debounce(() async {
                          setState(() {
                            overlayloading = true;
                          });

                          final result =
                              await getPassData(isRefresh: true, search: text);
                          if (result) {
                            refreshController.loadComplete();
                            refreshController.refreshCompleted();
                          } else {
                            refreshController.refreshFailed();
                          }

                          setState(() {
                            overlayloading = false;
                          });
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: SmartRefresher(
                    controller: refreshController,
                    enablePullUp: true,
                    onRefresh: () async {
                      final result = await getPassData(
                          isRefresh: true, search: _textCont.text);
                      if (result) {
                        refreshController.loadComplete();
                        refreshController.refreshCompleted();
                      } else {
                        refreshController.refreshFailed();
                      }
                    },
                    onLoading: () async {
                      final result = await getPassData(search: _textCont.text);
                      if (result) {
                        refreshController.loadComplete();
                      } else {
                        refreshController.loadNoData();
                        // refreshController.loadFailed();
                      }
                    },
                    child: loadfailed
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
                                  "Load Data Failed, Scroll Up to Retry",
                                  style: content,
                                ),
                              ),
                            ))
                        : datapo.isEmpty && onStart
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
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final user = datapo[index];

                                  return ExpandableNotifier(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    child: Card(
                                        elevation: 0,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: <Widget>[
                                              ScrollOnExpand(
                                                scrollOnExpand: true,
                                                scrollOnCollapse: false,
                                                child: ExpandablePanel(
                                                  theme:
                                                      const ExpandableThemeData(
                                                    headerAlignment:
                                                        ExpandablePanelHeaderAlignment
                                                            .center,
                                                    tapBodyToCollapse: true,
                                                  ),
                                                  header: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Iconsax.note_2,
                                                            color: Colors.red,
                                                          ),
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0),
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Receipt Number: ${user.rcpt_nbr}",
                                                                      style:
                                                                          title,
                                                                    ),
                                                                    Text(
                                                                      'PO Number: ${user.ponbr}',
                                                                      softWrap:
                                                                          true,
                                                                      style:
                                                                          subTitle,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  collapsed: Text(
                                                    'Location : ${user.rcptd_loc ?? ""}',
                                                    softWrap: true,
                                                    style: content,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  expanded: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            'Location : ${user.rcptd_loc ?? ""} ',
                                                            style: content,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            'Lot : ${user.rcptd_lot ?? ""} ',
                                                            style: content,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            'Order Date : ${user.rcpt_date ?? ""}',
                                                            style: content,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            'Due Date : ${user.rcpt_date ?? ""}',
                                                            style: content,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          )),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Ink(
                                                            decoration:
                                                                const ShapeDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    shape:
                                                                        CircleBorder()),
                                                            child: IconButton(
                                                              icon: const Icon(Icons
                                                                  .remove_red_eye),
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () => {
                                                                print(datapo[
                                                                        index]
                                                                    .userid
                                                                    .toString()),
                                                                print(userid),
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            receiptview(
                                                                              ponbr: datapo[index].ponbr.toString(),
                                                                              rcpt_nbr: datapo[index].rcpt_nbr.toString(),
                                                                              rcpt_date: datapo[index].rcpt_date.toString(),
                                                                              rcptd_part: datapo[index].rcptd_part.toString(),
                                                                              rcptd_qty_arr: datapo[index].rcptd_qty_arr.toString(),
                                                                              rcptd_lot: datapo[index].rcptd_lot.toString(),
                                                                              rcptd_loc: datapo[index].rcptd_loc.toString(),
                                                                              rcptd_qty_appr: datapo[index].rcptd_qty_appr.toString(),
                                                                              rcptd_qty_rej: datapo[index].rcptd_qty_rej.toString(),
                                                                              // angkutan: datapo[index].rcptd_loc.toString(),
                                                                              // nopol: datapo[index].rcptd_lot.toString(),
                                                                              supplier: datapo[index].supplier.toString(),
                                                                              batch: datapo[index].batch.toString(),
                                                                              shipto: datapo[index].shipto.toString(),
                                                                              lastapproval: datapo[index].lastapproval.toString(),
                                                                              nextapproval: datapo[index].nextapproval.toString(),
                                                                            )))
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Ink(
                                                            decoration: datapo[
                                                                            index]
                                                                        .laststatus
                                                                        .toString() !=
                                                                    'Rejected'
                                                                ? datapo[index]
                                                                            .userid
                                                                            .toString() ==
                                                                        userid
                                                                    ? const ShapeDecoration(
                                                                        color: Colors
                                                                            .blue,
                                                                        shape:
                                                                            CircleBorder())
                                                                    : null
                                                                : null,
                                                            child: datapo[index]
                                                                        .laststatus
                                                                        .toString() !=
                                                                    'Rejected'
                                                                ? datapo[index]
                                                                            .userid
                                                                            .toString() ==
                                                                        userid
                                                                    ? IconButton(
                                                                        icon: const Icon(
                                                                            Icons.check_circle_rounded),
                                                                        color: Colors
                                                                            .white,
                                                                        onPressed: datapo[index].laststatus.toString() !=
                                                                                'Rejected'
                                                                            ? datapo[index].userid.toString() == userid
                                                                                ? () async {
                                                                                    String refresh = await Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => receiptform(
                                                                                                ponbr: datapo[index].ponbr.toString(),
                                                                                                rcpt_nbr: datapo[index].rcpt_nbr.toString(),
                                                                                                rcpt_date: datapo[index].rcpt_date.toString(),
                                                                                                rcptd_part: datapo[index].rcptd_part.toString(),
                                                                                                rcptd_qty_arr: datapo[index].rcptd_qty_arr.toString(),
                                                                                                rcptd_lot: datapo[index].rcptd_lot.toString(),
                                                                                                rcptd_loc: datapo[index].rcptd_loc.toString(),
                                                                                                rcptd_qty_appr: datapo[index].rcptd_qty_appr.toString(),
                                                                                                rcptd_qty_rej: datapo[index].rcptd_qty_rej.toString(),
                                                                                                // angkutan: datapo[index].rcptd_loc.toString(),
                                                                                                // nopol: datapo[index].rcptd_lot.toString(),
                                                                                                supplier: datapo[index].supplier.toString(),
                                                                                                batch: datapo[index].batch.toString(),
                                                                                                shipto: datapo[index].shipto.toString(),
                                                                                                lastapproval: datapo[index].lastapproval.toString(),
                                                                                                nextapproval: datapo[index].nextapproval.toString(),
                                                                                                userid: userid)));

                                                                                    if (refresh == 'refresh') {
                                                                                      Changedata();
                                                                                    }
                                                                                  }
                                                                                : null
                                                                            : null,
                                                                      )
                                                                    : null
                                                                : null,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  builder:
                                                      (_, collapsed, expanded) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 10),
                                                      child: Expandable(
                                                        collapsed: collapsed,
                                                        expanded: expanded,
                                                        theme:
                                                            const ExpandableThemeData(
                                                                crossFadePoint:
                                                                    0),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ));
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: datapo.length,
                              ),
                  )),
                ],
              )),
        ),
      ),
    );
  }

  //  Widget build(BuildContext context) {

  //   return Scaffold(

  //     body: ListView.builder(

  //       itemCount: _receiptlist.length,
  //       itemBuilder: (context, index) {

  //         return StickyHeader(
  //         header: Visibility(
  //               visible: boolvisible,
  //               child:
  //               Container(
  //                 width: double.infinity,
  //                 color: Colors.red,
  //                 padding: const EdgeInsets.all(16),
  //                 child: Text(_receiptlist[index].ponbr.toString()),

  //               )
  //               ),

  //         content:
  //           ListTile(

  //             title: Text(_receiptlist[index].rcpt_nbr.toString()),

  //             // shape: RoundedRectangleBorder(
  //             //   side: BorderSide(color: Colors.black, width: 1),
  //             //   borderRadius: BorderRadius.circular(5),
  //             // ),
  // onTap: () => {
  //   Navigator.push(context,
  //   MaterialPageRoute(
  //     builder: (context) => receiptform(
  //       ponbr: _receiptlist[index].ponbr.toString(),
  //       rcpt_nbr: _receiptlist[index].rcpt_nbr.toString(),
  //       rcpt_date: _receiptlist[index].rcpt_date.toString() ,
  //       rcptd_part: _receiptlist[index].rcptd_part.toString(),
  //       rcptd_qty_arr: _receiptlist[index].rcptd_qty_arr.toString(),
  //       rcptd_lot: _receiptlist[index].rcptd_lot.toString(),
  //       rcptd_loc: _receiptlist[index].rcptd_loc.toString())
  //   ))

  // },
  //         )
  //         );
  //       }
  //       )
  //       );

  //       }
}
