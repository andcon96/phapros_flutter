import 'dart:async';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/menu/po/detailPO.dart';
import 'package:flutter_template/menu/po/receiptPO.dart';
import 'package:flutter_template/menu/po/wsaPO.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_template/utils/styles.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_template/utils/globalurl.dart' as globals;
import 'model/poModel.dart';

class POBrowse extends StatefulWidget {
  final String searchdefault;
  const POBrowse({Key? key, required this.searchdefault}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _POBrowseState createState() => _POBrowseState();
}

class _POBrowseState extends State<POBrowse> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  final _textCont = TextEditingController();
  String _custId = "";

  int currentPage = 1;
  late int totalPage;
  bool loadfailed = false;
  bool overlayloading = false;
  bool onStart = false;
  bool isEmpty = false;
  bool hasSearch = false;
  List<Data> datapo = [];
  Future<bool> getPassData({bool isRefresh = false, String? search}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
      } else {
        if (currentPage > totalPage) {
          refreshController.loadNoData();
          return false;
        }
      }

      final id = await UserSecureStorage.getUsername();
      final token = await UserSecureStorage.getToken();

      final Uri url = Uri.parse(
          '${globals.globalurl}/getpo?page=$currentPage&search=$search');

      loadfailed = false;
      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      }).timeout(const Duration(milliseconds: 5000), onTimeout: () {
        setState(() {
          loadfailed = true;
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Error",
                  text: "Gagalmemuat data"));
          refreshController.refreshFailed();
        });
        return http.Response('Error', 500);
      });

      if (response.statusCode == 200) {
        final result = purchaseOrderFromJson(response.body);
        if (result.data!.length == 0) {
          isEmpty = true;
        }

        if (search != '') {
          hasSearch = true;
        }

        onStart = true;

        if (isRefresh) {
          datapo = result.data!;
        } else {
          datapo.addAll(result.data!);
        }

        currentPage++;

        totalPage = result.meta?.lastPage ?? 0;

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
              text: "Tidak Ada Internet"));
      return false;
    }
  }

  Future init() async {
    final custid = await UserSecureStorage.getCustid();
    final token = await UserSecureStorage.getToken();
    final idanggota = await UserSecureStorage.getIdAnggota();
    final username = await UserSecureStorage.getUsername();
    _textCont.text = widget.searchdefault;

    _custId = custid!;
  }

  @override
  void initState() {
    super.initState();
    init();
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
                                  "Gagal memuat Data, Scroll Keatas to Coba Lagi",
                                  style: content,
                                ),
                              ),
                            ))
                        : datapo.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Card(
                                  elevation: 0,
                                  shadowColor: Colors.red,
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    title: onStart && isEmpty && hasSearch
                                        ? Text(
                                            "Tidak ada Data",
                                            style: content,
                                          )
                                        : Text(
                                            "Cari Data berdasarkan Nomor PO / Vendor",
                                            style: content,
                                          ),
                                  ),
                                ))
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final user = datapo[index];
                                  final details = user.poDetails;

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
                                                            color:
                                                                Colors.purple,
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
                                                                      "PO No.: ${user.poNbr}",
                                                                      style:
                                                                          title,
                                                                    ),
                                                                    Text(
                                                                      'Vendor : ${user.poVend} - ${user.poVendDesc}',
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
                                                  collapsed: Column(
                                                    children: [
                                                      Text(
                                                        'List Barang',
                                                        style: title,
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        'Line - Kode Barang - Jumlah Pesan',
                                                        style: title,
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            details!.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final detail =
                                                              details[index];

                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Line : ${detail.podLine} - ${detail.podPartDesc} - ${detail.podQtyOrd}',
                                                                softWrap: true,
                                                                style: content,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
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
                                                            'Vendor : ${user.poVend} - ${user.poVendDesc} ',
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
                                                            'Tujuan : ${user.poShip} ',
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
                                                            'Tanggal Pesan : ${user.poOrdDate}',
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
                                                            'Tanggal Jatuh Tempo : ${user.poDueDate}',
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
                                                            'Mata Uang : ${user.poCurr ?? ''}',
                                                            style: content,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          )),
                                                      // Padding(
                                                      //     padding:
                                                      //         const EdgeInsets
                                                      //                 .only(
                                                      //             bottom: 10),
                                                      //     child: Text(
                                                      //       'Total: ${user.poTotal}',
                                                      //       style: content,
                                                      //       softWrap: true,
                                                      //       overflow:
                                                      //           TextOverflow
                                                      //               .fade,
                                                      //     )),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Ink(
                                                            decoration:
                                                                const ShapeDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            55,
                                                                            48,
                                                                            107,
                                                                            0.9),
                                                                    shape:
                                                                        CircleBorder()),
                                                            child: IconButton(
                                                              icon: const Icon(Icons
                                                                  .remove_red_eye_sharp),
                                                              color:
                                                                  Colors.white,
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              podetail(
                                                                                ponbr: user.poNbr!,
                                                                                povend: '${user.poVend!} - ${user.poVendDesc}',
                                                                                orddate: user.poOrdDate!,
                                                                                duedate: user.poDueDate!,
                                                                                total: user.poTotal!,
                                                                                poddetail: user.poDetails!,
                                                                              )),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          // List Receipt
                                                          if (user
                                                              .poListReceipt!
                                                              .isNotEmpty)
                                                            Ink(
                                                              decoration: const ShapeDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          158,
                                                                          71,
                                                                          132,
                                                                          0.9),
                                                                  shape:
                                                                      CircleBorder()),
                                                              child: IconButton(
                                                                icon: const Icon(
                                                                    Icons.book),
                                                                color: Colors
                                                                    .white,
                                                                onPressed:
                                                                    () async {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    CupertinoPageRoute(
                                                                        builder: (context) =>
                                                                            PoReceipt(
                                                                              podomain: user.poDomain!,
                                                                              ponbr: user.poNbr!,
                                                                              povend: '${user.poVend!} - ${user.poVendDesc}',
                                                                              poshipto: '${user.poShip}',
                                                                              orddate: user.poOrdDate!,
                                                                              duedate: user.poDueDate!,
                                                                              total: user.poTotal!,
                                                                              polistreceipt: user.poListReceipt!,
                                                                            )),
                                                                  );
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
      floatingActionButton: _custId != 'null'
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => const wsaPO()));
              },
              backgroundColor: Colors.purple,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
    );
  }
}
