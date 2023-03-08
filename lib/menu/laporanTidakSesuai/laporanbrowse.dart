import 'package:flutter/material.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/laporanform.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/model/laporanModel.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/services/laporanServices.dart';
import 'package:flutter_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:flutter_template/main.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';






class laporanbrowse extends StatefulWidget {
  const laporanbrowse({Key? key}) : super(key: key);
  
  
  @override
  // ignore: library_private_types_in_public_api
  _laporanbrowse createState() => _laporanbrowse();
}

class _laporanbrowse extends State {
  late String currentpo = '';
  int currentStep = 0;
  final IdRcp = TextEditingController();
  final No = TextEditingController();
  final Tanggal = TextEditingController();
  final Supplier = TextEditingController();
  final Komplain = TextEditingController();
  final Keterangan = TextEditingController();
  final NamaBarang = TextEditingController();
  final TglMasuk = TextEditingController();
  final JumlahMasuk = TextEditingController();
  final KomplainDetail = TextEditingController();
  final PO = TextEditingController();
  final NomorLot = TextEditingController();
  final Angkutan = TextEditingController();
  final NoPol = TextEditingController();
  List<laporanModel> _laporanlist = [];
  late bool boolvisible = false;
  void initState(){
    super.initState();
    // _laporanbrowse();
    _getData();
    boolvisible = false;
    currentpo = '';
    
  }
    
  _getData(){
    laporanServices.getdata().then((list){
        setState(() {
          
          _laporanlist = list;
          
        });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body: ListView.builder(
        
        itemCount: _laporanlist.length,
        itemBuilder: (context, index) {
          boolvisible = currentpo != _laporanlist[index].ponbr.toString() ? true : false;
          currentpo = _laporanlist[index].ponbr.toString();
          print('a');
          return StickyHeader(
          header: Visibility(
                visible: boolvisible, 
                child:
                Container(
                  width: double.infinity,
                  color: Colors.red,
                  padding: const EdgeInsets.all(16),
                  child: Text(_laporanlist[index].ponbr.toString()),
                  
                )
                ),
                
          content: 
            ListTile(
            
              title: Text(_laporanlist[index].rcpt_nbr.toString()),
              
              
              // shape: RoundedRectangleBorder(
              //   side: BorderSide(color: Colors.black, width: 1),
              //   borderRadius: BorderRadius.circular(5),
              // ), 
              onTap: () => {
                Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => laporanform(
                    ponbr: _laporanlist[index].ponbr.toString(), 
                    rcpt_nbr: _laporanlist[index].rcpt_nbr.toString(), 
                    rcpt_date: _laporanlist[index].rcpt_date.toString() , 
                    rcptd_part: _laporanlist[index].rcptd_part.toString(), 
                    rcptd_qty_arr: _laporanlist[index].rcptd_qty_arr.toString(), 
                    rcptd_lot: _laporanlist[index].rcptd_lot.toString(), 
                    rcptd_loc: _laporanlist[index].rcptd_loc.toString())
                ))
            
              },
          )
          );
        }
        )
        );

         
        } 
}
        

// class laporanbrowse extends StatefulWidget {
//   const laporanbrowse({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _laporanbrowse createState() => _laporanbrowse();
// }

  

  

  
//   class _laporanbrowse extends State {
//       int currentStep = 0;
//       final IdRcp = TextEditingController();
//       final No = TextEditingController();
//       final Tanggal = TextEditingController();
//       final Supplier = TextEditingController();
//       final Komplain = TextEditingController();
//       final Keterangan = TextEditingController();
//       final NamaBarang = TextEditingController();
//       final TglMasuk = TextEditingController();
//       final JumlahMasuk = TextEditingController();
//       final KomplainDetail = TextEditingController();
//       final PO = TextEditingController();
//       final NomorLot = TextEditingController();
//       final Angkutan = TextEditingController();
//       final NoPol = TextEditingController();
//       List<laporanModel> _laporanlist = [];
  //     @override
  //   //   void initState(){
  //   //   super.initState();
  //   //   _laporanbrowse();
  //   // }
    
  // //   _getData(){
  // //   laporanServices.getdata().then((list){
  // //       setState(() {
  // //         _laporanlist = list;
  // //         print(_laporanlist.toString());
  // //       });
      
  // //   });
  // // }

  
//   @override

//   Widget build(BuildContext context){
      
//      return Scaffold(
//       backgroundColor: Color(0xff151515),
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: ListView(
//             children: [
//               Row(
//                 children: [
//                   Text('Hello, ',
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ), 
//                 ],
//               ),
//               SizedBox(height: 24,),
//               Text(
//                 "Students Data",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold
//                 ),
//               ),
//               SizedBox(height: 12,),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Table students(){
//     return Table(
//       border: TableBorder(
//         horizontalInside: BorderSide(
//           width: 1,
//           color: Colors.grey,
//         ),
//       ),
//       children: [
//         TableRow(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
//               child: Text(
//                 "ID",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
//               child: Text(
//                 "FULL NAME",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
//               child: Text(
//                 "OPTION",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ]
//         ),
//       ],
//     );
//   }
//   }