import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/menu/po/model/poModel.dart';
import 'package:flutter_template/menu/po/receiptDetailPO.dart';

import 'package:flutter_template/utils/styles.dart';

class PoReceipt extends StatefulWidget {
  final String ponbr;
  final String povend;
  final String orddate;
  final String duedate;
  final String total;
  final List<PoListReceipt> polistreceipt;

  const PoReceipt(
      {Key? key,
      required this.ponbr,
      required this.povend,
      required this.orddate,
      required this.duedate,
      required this.total,
      required this.polistreceipt})
      : super(key: key);

  @override
  _PoReceiptState createState() => _PoReceiptState();
}

class _PoReceiptState extends State<PoReceipt> {
  List<PoListReceipt> listdetail = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listdetail = widget.polistreceipt;
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
                "List Receipt PO",
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
                  data: widget.orddate, title: 'Order Date', panjang: 200.00),
              const Divider(),
              _textInfo(
                  data: widget.duedate, title: 'Due Date', panjang: 100.00),
              const Divider(),
              _textInfo(data: widget.total, title: 'Total', panjang: 100.00),
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
                      'No Detail Available',
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
                                "${i + 1}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title:
                                Text('Receipt No : ${listdetail[i].rcptNbr}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text('Status : ${listdetail[i].rcptStatus}'),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    'Approval Status : ${listdetail[i].getIsOngoinApproval!.isEmpty ? 'Not Started' : 'On Going'}'),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.book),
                              color: Colors.purple,
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => receiptdetail(
                                            ponbr: widget.ponbr,
                                            receiptno: listdetail[i].rcptNbr,
                                            receiptstatus:
                                                listdetail[i].rcptStatus,
                                            povend: widget.povend,
                                            orddate: widget.orddate,
                                            duedate: widget.duedate,
                                            total: widget.total,
                                            receiptDetail:
                                                listdetail[i].getDetail,
                                          )),
                                );
                              },
                            ),
                          ),
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
