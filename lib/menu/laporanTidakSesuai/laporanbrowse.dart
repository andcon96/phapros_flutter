import 'dart:async';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/laporanview.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/model/laporanModel.dart';
import 'package:flutter_template/menu/po/wsaPO.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_template/utils/styles.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/services/laporanServices.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/laporanform.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;

import 'package:http/http.dart' as http;

// import 'poModel.dart';

class laporanbrowse extends StatefulWidget {
  final String searchdefault;

  const laporanbrowse({Key? key, required this.searchdefault})
      : super(key: key);
  // const laporanbrowse({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _laporanbrowse createState() => _laporanbrowse();
}

class _laporanbrowse extends State<laporanbrowse> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  final _textCont = TextEditingController();
  String _custId = "";

  int currentPage = 1;
  late int totalPage;
  bool loadfailed = false;
  bool overlayloading = false;
  bool onStart = false;
  List<laporanModel> datapo = [];
  List<laporanModel> _laporanlist = [];

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

      final Uri url = Uri.parse(
          '${globals.globalurl}/getpolaporan?receiptnbr=' + search.toString());
      print(url);
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
              laporanServices.searchdata(response.body).then((newlist) {
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
    _textCont.text = widget.searchdefault;
    _getData();
    init();
  }

  _getData() {
    laporanServices.getdata().then((list) {
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
                            overlayloading = true;
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
                      refreshController.loadComplete();
                      refreshController.refreshCompleted();
                      final result = await getPassData(
                          isRefresh: true, search: _textCont.text);
                      if (result) {
                      } else {
                        // refreshController.refreshFailed();
                      }
                    },
                    onLoading: () async {
                      final result = await getPassData(search: _textCont.text);
                      if (result) {
                        refreshController.loadComplete();
                      } else {
                        refreshController.loadNoData();
                        refreshController.loadFailed();
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
                                                            color: Colors.green,
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
                                                    'Lot : ${user.rcptd_lot ?? ""}',
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
                                                            'Batch : ${user.rcptd_batch ?? ""} ',
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
                                                            'Qty Masuk : ${user.rcptd_qty_arr ?? ""}',
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
                                                            'Qty Reject : ${user.rcptd_qty_rej ?? ""}',
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
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => laporanview(
                                                                            ponbr:
                                                                                datapo[index].ponbr.toString(),
                                                                            rcpt_nbr: datapo[index].rcpt_nbr.toString(),
                                                                            rcpt_date: datapo[index].rcpt_date.toString(),
                                                                            rcptd_part: datapo[index].rcptd_part.toString(),
                                                                            rcptd_qty_arr: datapo[index].rcptd_qty_arr.toString(),
                                                                            rcptd_lot: datapo[index].rcptd_lot.toString(),
                                                                            rcptd_loc: datapo[index].rcptd_loc.toString(),
                                                                            rcptd_qty_appr: datapo[index].rcptd_qty_appr.toString(),
                                                                            rcptd_qty_rej: datapo[index].rcptd_qty_rej.toString(),
                                                                            nopol: datapo[index].nopol.toString(),
                                                                            angkutan: datapo[index].angkutan.toString(),
                                                                            supplier: datapo[index].supplier.toString(),
                                                                            supplierdesc: datapo[index].supplierdesc.toString(),
                                                                            no: datapo[index].no.toString(),
                                                                            komplain: datapo[index].komplain.toString(),
                                                                            keterangan: datapo[index].keterangan.toString(),
                                                                            tanggal: datapo[index].tanggal.toString(),
                                                                            komplaindetail: datapo[index].komplaindetail.toString(),
                                                                            createdby: datapo[index].createdby.toString(),
                                                                            batch: datapo[index].rcptd_batch.toString(),
                                                                            um: datapo[index].umdesc.toString(),
                                                                            )))
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Ink(
                                                            decoration:
                                                                const ShapeDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    shape:
                                                                        CircleBorder()),
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .edit_note),
                                                              color:
                                                                  Colors.white,
                                                              onPressed:
                                                                  () async {
                                                                String?
                                                                    refresh =
                                                                    await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => laporanform(
                                                                                  ponbr: datapo[index].ponbr.toString(),
                                                                                  rcpt_nbr: datapo[index].rcpt_nbr.toString(),
                                                                                  rcpt_imr: datapo[index].rcptd_imr.toString(),
                                                                                  batch: datapo[index].rcptd_batch.toString(),
                                                                                  rcpt_date: datapo[index].rcpt_date.toString(),
                                                                                  rcptd_part: datapo[index].rcptd_part.toString(),
                                                                                  rcptd_qty_arr: datapo[index].rcptd_qty_arr.toString(),
                                                                                  rcptd_lot: datapo[index].rcptd_lot.toString(),
                                                                                  rcptd_loc: datapo[index].rcptd_loc.toString(),
                                                                                  rcptd_qty_appr: datapo[index].rcptd_qty_appr.toString(),
                                                                                  rcptd_qty_rej: datapo[index].rcptd_qty_rej.toString(),
                                                                                  nopol: datapo[index].nopol.toString(),
                                                                                  angkutan: datapo[index].angkutan.toString(),
                                                                                  supplier: datapo[index].supplier.toString(),
                                                                                  supplierdesc: datapo[index].supplierdesc.toString(),
                                                                                  um: datapo[index].umdesc.toString(),
                                                                                  itemcode: datapo[index].itemcode.toString(),
                                                                                )));

                                                                if (refresh ==
                                                                    'refresh') {
                                                                      print('a');
                                                                  Changedata();
                                                                }
                                                              },
                                                            ),
                                                          ),
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

  //       itemCount: _laporanlist.length,
  //       itemBuilder: (context, index) {

  //         return StickyHeader(
  //         header: Visibility(
  //               visible: boolvisible,
  //               child:
  //               Container(
  //                 width: double.infinity,
  //                 color: Colors.red,
  //                 padding: const EdgeInsets.all(16),
  //                 child: Text(_laporanlist[index].ponbr.toString()),

  //               )
  //               ),

  //         content:
  //           ListTile(

  //             title: Text(_laporanlist[index].rcpt_nbr.toString()),

  //             // shape: RoundedRectangleBorder(
  //             //   side: BorderSide(color: Colors.black, width: 1),
  //             //   borderRadius: BorderRadius.circular(5),
  //             // ),
  // onTap: () => {
  //   Navigator.push(context,
  //   MaterialPageRoute(
  //     builder: (context) => laporanform(
  //       ponbr: _laporanlist[index].ponbr.toString(),
  //       rcpt_nbr: _laporanlist[index].rcpt_nbr.toString(),
  //       rcpt_date: _laporanlist[index].rcpt_date.toString() ,
  //       rcptd_part: _laporanlist[index].rcptd_part.toString(),
  //       rcptd_qty_arr: _laporanlist[index].rcptd_qty_arr.toString(),
  //       rcptd_lot: _laporanlist[index].rcptd_lot.toString(),
  //       rcptd_loc: _laporanlist[index].rcptd_loc.toString())
  //   ))

  // },
  //         )
  //         );
  //       }
  //       )
  //       );

  //       }
}
