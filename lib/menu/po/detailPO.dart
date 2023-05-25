import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/menu/po/model/poModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_template/utils/styles.dart';

class podetail extends StatefulWidget {
  final String ponbr;
  final String povend;
  final String orddate;
  final String duedate;
  final String total;
  final List<PoDetails> poddetail;

  const podetail(
      {Key? key,
      required this.ponbr,
      required this.povend,
      required this.orddate,
      required this.duedate,
      required this.total,
      required this.poddetail})
      : super(key: key);

  @override
  _podetailState createState() => _podetailState();
}

class _podetailState extends State<podetail> {
  List<PoDetails> listdetail = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listdetail = widget.poddetail;
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
                "Detail PO",
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
                                "${listdetail[i].podLine}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                                '${listdetail[i].podPart!} - ${listdetail[i].podPartDesc ?? ''}'),
                            subtitle: Text(
                                'Qty Pesan : ${listdetail[i].podQtyOrd}, Qty Open : ${double.parse(listdetail[i].podQtyOrd!) - double.parse(listdetail[i].podQtyRcvd!)}'),
                            // trailing: Icon(Icons.food_bank),
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
