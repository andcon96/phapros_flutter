import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/menu/po/editReceiptPO.dart';
import 'package:flutter_template/menu/po/model/poModel.dart';
import 'package:flutter_template/menu/po/receiptDetailPO.dart';

import 'package:flutter_template/utils/styles.dart';

class PoReceipt extends StatefulWidget {
  final String podomain;
  final String ponbr;
  final String povend;
  final String poshipto;
  final String orddate;
  final String duedate;
  final String total;
  final List<PoListReceipt> polistreceipt;

  const PoReceipt(
      {Key? key,
      required this.podomain,
      required this.ponbr,
      required this.povend,
      required this.poshipto,
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
              _textInfo(data: widget.ponbr, title: 'No PO', panjang: 100.00),
              const Divider(),
              _textInfo(
                  data: widget.povend, title: 'PO Vendor', panjang: 250.00),
              const Divider(),
              _textInfo(
                  data: widget.orddate,
                  title: 'Tanggal Pesan',
                  panjang: 200.00),
              const Divider(),
              _textInfo(
                  data: widget.duedate,
                  title: 'Tanggal Jatuh Tempo',
                  panjang: 100.00),
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
                                  "${i + 1}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text('No Rcpt. ${listdetail[i].rcptNbr}'),
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
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.book),
                                    color: Colors.purple,
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => receiptdetail(
                                                  ponbr: widget.ponbr,
                                                  receiptno:
                                                      listdetail[i].rcptNbr,
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
                                  if (listdetail[i].rcptStatus != 'finished')
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color:
                                          const Color.fromARGB(255, 0, 76, 138),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  editReceiptPO(
                                                      ponbr: widget.ponbr
                                                          .toString(),
                                                      rcpt_nbr: listdetail[i]
                                                          .rcptNbr
                                                          .toString(),
                                                      rcpt_date: listdetail[i]
                                                          .rcptDate
                                                          .toString(),
                                                      rcptd_part: listdetail[i]
                                                          .getDetail![0]
                                                          .rcptdPart
                                                          .toString(),
                                                      rcptd_qty_arr: listdetail[i]
                                                          .getDetail![0]
                                                          .rcptdQtyArr
                                                          .toString(),
                                                      rcptd_lot: listdetail[i]
                                                          .getDetail![0]
                                                          .rcptdLot
                                                          .toString(),
                                                      rcptd_loc: listdetail[i]
                                                          .getDetail![0]
                                                          .rcptdLoc
                                                          .toString(),
                                                      rcptd_qty_appr:
                                                          listdetail[i]
                                                              .getDetail![0]
                                                              .rcptdQtyAppr
                                                              .toString(),
                                                      rcptd_qty_rej: listdetail[i]
                                                          .getDetail![0]
                                                          .rcptdQtyRej
                                                          .toString(),
                                                      // angkutan: datapo[index].rcptd_loc.toString(),
                                                      // nopol: datapo[index].rcptd_lot.toString(),
                                                      supplier: widget.povend
                                                          .toString(),
                                                      shipto: widget.poshipto
                                                          .toString(),
                                                      domain: widget.podomain
                                                          .toString(),
                                                      imrnbr: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcImrNbr
                                                          .toString(),
                                                      donbr: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcDoNbr
                                                          .toString(),
                                                      articlenbr: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcArticleNbr
                                                          .toString(),
                                                      imrdate: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcImrDate
                                                          .toString(),
                                                      arrivaldate: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcArrivalDate
                                                          .toString(),
                                                      proddate: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcProdDate
                                                          .toString(),
                                                      expdate: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcExpDate
                                                          .toString(),
                                                      manufacturer: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcManufacturer
                                                          .toString(),
                                                      country: listdetail[i]
                                                          .getChecklist!
                                                          .rcptcCountry
                                                          .toString(),
                                                      iscertofanalys: listdetail[i]
                                                          .getDocument!
                                                          .rcptdocIsCertofanalys
                                                          .toString(),
                                                      certofanalys: listdetail[i]
                                                          .getDocument!
                                                          .rcptdocCertofanalys
                                                          .toString(),
                                                      ismsds: listdetail[i].getDocument!.rcptdocIsMsds.toString(),
                                                      msds: listdetail[i].getDocument!.rcptdocMsds.toString(),
                                                      isforwarderdo: listdetail[i].getDocument!.rcptdocIsForwarderdo.toString(),
                                                      forwarderdo: listdetail[i].getDocument!.rcptdocForwarderdo.toString(),
                                                      ispackinglist: listdetail[i].getDocument!.rcptdocIsPackinglist.toString(),
                                                      packinglist: listdetail[i].getDocument!.rcptdocPackinglist.toString(),
                                                      isotherdocs: listdetail[i].getDocument!.rcptdocIsOtherdocs.toString(),
                                                      otherdocs: listdetail[i].getDocument!.rcptdocOtherdocs.toString(),
                                                      kemasansacdos: listdetail[i].getKemasan!.rcptkKemasanSacdos.toString(),
                                                      kemasansacdosdesc: listdetail[i].getKemasan!.rcptkKemasanSacdosDesc.toString(),
                                                      kemasandrumvat: listdetail[i].getKemasan!.rcptkKemasanDrumvat.toString(),
                                                      kemasandrumvatdesc: listdetail[i].getKemasan!.rcptkKemasanDrumvatDesc.toString(),
                                                      kemasanpalletpeti: listdetail[i].getKemasan!.rcptkKemasanPalletpeti.toString(),
                                                      kemasanpalletpetidesc: listdetail[i].getKemasan!.rcptkKemasanPalletpetiDesc.toString(),
                                                      isclean: listdetail[i].getKemasan!.rcptkIsClean.toString(),
                                                      iscleandesc: listdetail[i].getKemasan!.rcptkIsCleanDesc.toString(),
                                                      isdry: listdetail[i].getKemasan!.rcptkIsDry.toString(),
                                                      isdrydesc: listdetail[i].getKemasan!.rcptkIsDryDesc.toString(),
                                                      isnotspilled: listdetail[i].getKemasan!.rcptkIsNotSpilled.toString(),
                                                      isnotspilleddesc: listdetail[i].getKemasan!.rcptkIsNotSpilledDesc.toString(),
                                                      issealed: listdetail[i].getKemasan!.rcptkIsSealed.toString(),
                                                      ismanufacturerlabel: listdetail[i].getKemasan!.rcptkIsManufacturerLabel.toString(),
                                                      transporttransporterno: listdetail[i].getTransport!.rcpttTransporterNo.toString(),
                                                      transportpoliceno: listdetail[i].getTransport!.rcpttPoliceNo.toString(),
                                                      transportisclean: listdetail[i].getTransport!.rcpttIsClean.toString(),
                                                      transportiscleandesc: listdetail[i].getTransport!.rcpttIsCleanDesc.toString(),
                                                      transportisdry: listdetail[i].getTransport!.rcpttIsDry.toString(),
                                                      transportisdrydesc: listdetail[i].getTransport!.rcpttIsDryDesc.toString(),
                                                      transportisnotspilled: listdetail[i].getTransport!.rcpttIsNotSpilled.toString(),
                                                      transportisnotspilleddesc: listdetail[i].getTransport!.rcpttIsNotSpilledDesc.toString(),
                                                      transportispositionsingle: listdetail[i].getTransport!.rcpttIsPositionSingle.toString(),
                                                      transportispositionsingledesc: listdetail[i].getTransport!.rcpttIsPositionSingleDesc.toString(),
                                                      transportissegregated: listdetail[i].getTransport!.rcpttIsSegregated.toString(),
                                                      transportissegregateddesc: listdetail[i].getTransport!.rcpttIsSegregatedDesc.toString(),
                                                      transportangkutancatatan: listdetail[i].getTransport!.rcpttAngkutanCatatan.toString(),
                                                      transportkelembapan: listdetail[i].getTransport!.rcpttKelembapan.toString(),
                                                      transportsuhu: listdetail[i].getTransport!.rcpttSuhu.toString())),
                                        );
                                      },
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
