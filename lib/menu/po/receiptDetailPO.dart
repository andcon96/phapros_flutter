import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/menu/po/model/poModel.dart';

import 'package:flutter_template/utils/styles.dart';

class receiptdetail extends StatefulWidget {
  final String ponbr;
  final String povend;
  final String orddate;
  final String duedate;
  final String total;
  final String? receiptno;
  final String? receiptstatus;
  final List<GetDetail>? receiptDetail;

  const receiptdetail(
      {Key? key,
      required this.ponbr,
      required this.receiptno,
      required this.receiptstatus,
      required this.povend,
      required this.orddate,
      required this.duedate,
      required this.total,
      required this.receiptDetail})
      : super(key: key);

  @override
  _receiptdetailState createState() => _receiptdetailState();
}

class _receiptdetailState extends State<receiptdetail> {
  List<GetDetail> listdetail = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.receiptDetail);
    listdetail = widget.receiptDetail ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Detail Receipt",
                style: titleForm,
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              _textInfo(
                  data: widget.ponbr, title: 'PO Number', panjang: 100.00),
              const Divider(),
              _textInfo(
                  data: widget.povend, title: 'PO Vendor', panjang: 100.00),
              const Divider(),
              _textInfo(
                  data: widget.receiptno, title: 'No Receipt', panjang: 100.00),
              const Divider(),
              _textInfo(
                  data: widget.receiptstatus.toString().kapital(),
                  title: 'Status Receipt',
                  panjang: 100.00),
              const Divider(),
              _textInfo(
                  data: '${listdetail.length} Detail(s)',
                  title: 'Detail',
                  panjang: 130.00),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              if (listdetail.isEmpty)
                const Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      'Tidak ada Data Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 10, top: 5),
                  ),
                ),
              if (listdetail.isNotEmpty)
                for (int i = 0; i < listdetail.length; i++)
                  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple[400],
                                maxRadius: 20,
                                child: Text(
                                  "${listdetail[i].rcptdLine}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                  '${listdetail[i].rcptdPart!} - ${listdetail[i].rcptdPartDesc}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      'Qty Datang : ${listdetail[i].rcptdQtyArr}'),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      'Qty Terima : ${listdetail[i].rcptdQtyAppr}'),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      'Qty Reject : ${listdetail[i].rcptdQtyRej}'),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text('Lokasi : ${listdetail[i].rcptdLoc}'),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      'Lot Serial : ${listdetail[i].rcptdLot}'),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text('Batch : ${listdetail[i].rcptdBatch}'),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      const Divider(),
                    ],
                  )
            ],
          ),
        ),
      ),
    ));
  }
}

Widget _textInfo({controller, data, title, panjang}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: titleDetail,
        ),
        Container(
          width: panjang,
          child: Text(
            data,
            style: contentDetail,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        )
      ],
    ),
  );
}

extension MyExtension on String {
  String kapital() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
