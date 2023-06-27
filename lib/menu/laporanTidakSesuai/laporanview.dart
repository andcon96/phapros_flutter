import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;

class laporanview extends StatefulWidget {
  final String ponbr,
      rcpt_nbr,
      rcpt_date,
      rcptd_part,
      rcptd_qty_arr,
      rcptd_lot,
      rcptd_loc,
      rcptd_qty_rej,
      rcptd_qty_appr,
      angkutan,
      nopol,
      supplier,
      no,
      komplain,
      keterangan,
      komplaindetail,
      tanggal,
      createdby,
      batch,
      supplierdesc,
      um;

  const laporanview({
    Key? key,
    required this.ponbr,
    required this.rcpt_nbr,
    required this.rcpt_date,
    required this.rcptd_part,
    required this.rcptd_qty_arr,
    required this.rcptd_lot,
    required this.rcptd_loc,
    required this.rcptd_qty_appr,
    required this.rcptd_qty_rej,
    required this.angkutan,
    required this.nopol,
    required this.supplier,
    required this.no,
    required this.keterangan,
    required this.tanggal,
    required this.komplaindetail,
    required this.komplain ,
    required this.createdby,
    required this.batch,
    required this.supplierdesc,
    required this.um
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _laporanview createState() => _laporanview();
}


class AboutPage extends StatelessWidget {
  final String tag;
  final String photourl;

  AboutPage({
    required this.tag, 
    required this.photourl
  });
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: tag,
            child: 
                  Image.network('${globals.globalurlphoto}'+photourl,
                  errorBuilder: (context, Object exception, stackTrace) {
                    print('a');
                        return Text('Your error widget2');
                    },)),
          
        ),
      ),
    );
  }
}
class _laporanview extends State<laporanview> {
  int currentStep = 0;
  late TextEditingController IdRcp;
  late TextEditingController No;
  late TextEditingController Tanggal;
  late TextEditingController Supplier;
  late TextEditingController Komplain;
  late TextEditingController Keterangan;
  late TextEditingController NamaBarang;
  late TextEditingController TglMasuk;
  late TextEditingController JumlahMasuk;
  late TextEditingController KomplainDetail;
  late TextEditingController PO;
  late TextEditingController NomorLot;
  late TextEditingController Angkutan;
  late TextEditingController NoPol;
  late TextEditingController UM;
  late TextEditingController createdby;
  String rcptnbr = '';
  late String responseresult = '';

  List<String>? imagefiles = [];
  

  final children = <Widget>[];
  final childrendetail = <Widget>[];
  Future<bool> checkImageUrlExists(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> getFoto({String? search, String? batch, String? lot}) async {
    final token = await UserSecureStorage.getToken();
    final id = await UserSecureStorage.getIdAnggota();
    final Uri url = Uri.parse(
          '${globals.globalurl}/getlaporanfoto?rcptnbr=' +
              search.toString() + '&batch=' + batch.toString() + '&lot=' + lot.toString()
    );

    final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      }).timeout(const Duration(seconds: 20), onTimeout: () {
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

      
      List<dynamic>? responseresult = json.decode(response.body);
      

      if(responseresult != []){
        responseresult?.asMap().forEach((index,element) {
          var responsecheck = http.head(Uri.parse('${globals.globalurlphoto}'+element['li_path']))
         .then((responsecode) {
          // Check the response status code
          var statusCode = responsecode.statusCode;
          if(statusCode == 200){
            print('${globals.globalurlphoto}'+element['li_path']);
            setState(() { 
             children.add(
                new InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => new AboutPage(tag: index.toString(),photourl: element['li_path']))
                  ), 
                  child: Card(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Hero(tag: index.toString(),child:Image.network(
                      '${globals.globalurlphoto}'+element['li_path'],
                        
                      ))
                    ),
                  )
                ),
              );
            });
          }
          else{
            print(statusCode);
          }
        });
      });
        
      }
  }


  void initState() {
    super.initState();
    String rcptnumber = widget.rcpt_nbr;
    String s_batch = widget.batch;
    String s_lot = widget.rcptd_lot;
    getFoto(search: rcptnumber, batch: s_batch,lot: s_lot);
    IdRcp = TextEditingController(text: widget.rcpt_nbr);
    NamaBarang = TextEditingController(
        text: widget.rcptd_part != 'null' ? widget.rcptd_part : '');
    TglMasuk = TextEditingController(text: widget.rcpt_date);
    JumlahMasuk = TextEditingController(
        text: widget.rcptd_qty_arr != 'null' ? widget.rcptd_qty_arr : '');
    PO = TextEditingController(text: widget.ponbr);
    NomorLot = TextEditingController(text: widget.rcptd_lot);
    No = TextEditingController(text:widget.no);
    Tanggal = TextEditingController(text:widget.tanggal);
    Supplier = TextEditingController(
        text: widget.supplier != 'null' ? (widget.supplier + ' -- ' + widget.supplierdesc) : '');
    Komplain = TextEditingController( text: widget.komplain != 'null' ? widget.komplain  :'-');
    Keterangan = TextEditingController(text:widget.keterangan != 'null' ? widget.keterangan : '-');
    KomplainDetail = TextEditingController(
        text: widget.rcptd_qty_rej != 'null' ? widget.rcptd_qty_rej : '');
    Angkutan = TextEditingController(
        text: widget.angkutan != 'null' ? widget.angkutan : '');
    NoPol =
        TextEditingController(text: widget.nopol != 'null' ? widget.nopol : '');
    UM =
        TextEditingController(text: widget.um != 'null' ? widget.um : '');
    createdby =
        TextEditingController(text: widget.createdby != 'null' ? widget.createdby : '');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Table(
                    border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                    children: [
                      TableRow(children: [
                        TableCell(
                          
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                            'ID RCP',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                                
                          ),
                        ),
                        ),
                        TableCell(
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            IdRcp.text,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                            
                            child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            )),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            No.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Tanggal',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Tanggal.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Supplier',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Supplier.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Komplain',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Komplain.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Keterangan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Keterangan.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Nama Barang',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            NamaBarang.text,
                            style: TextStyle(fontSize: 16),
                          ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'UM',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            UM.text,
                            style: TextStyle(fontSize: 16),
                          ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Tanggal Masuk',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            TglMasuk.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Jumlah Masuk',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            JumlahMasuk.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Komplain',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            KomplainDetail.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'PO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            PO.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Nomor Lot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            NomorLot.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Angkutan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            Angkutan.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            'Nomor Polisi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle, 
                          child: Container(
                            height:50,
                            alignment: Alignment.centerLeft,
                          child: Text(
                            NoPol.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                      ]),
                    ]),
                    Container(
                      height:50,
                            alignment: Alignment.center,
                          child: Text(
                            'Foto',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          
                          ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      children: children
                    ),

                    SizedBox(height: 30),
                        
                    
              ]),
              
            ),
          )
        ],
      ));
}
