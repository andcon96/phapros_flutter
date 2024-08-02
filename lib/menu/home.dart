// ignore_for_file: unnecessary_const

import 'package:flutter/services.dart';
import 'package:flutter_template/menu/laporanTidakSesuai/laporanbrowse.dart';
import 'package:flutter_template/menu/receiptapproval/receiptbrowse.dart';
import 'package:flutter_template/menu/po/browsePO.dart';
import 'package:flutter_template/menu/user/userprof.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/utils/color.dart';
import 'package:flutter_template/utils/styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi IMI",
      theme: ThemeData(
          useMaterial3: false,
          primaryColor: Colors.blueGrey[500],
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.blueAccent[500])),
      home: const NavHome(
        selPage: 0,
        searchvalue: '',
      ),
    );
  }
}

class NavHome extends StatefulWidget {
  final int selPage;
  final String searchvalue;
  const NavHome({Key? key, required this.selPage, required this.searchvalue})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavHomeState createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> with SingleTickerProviderStateMixin {
  int touchedIndex = -1;

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
                )),
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
                  // Navigator.of(context).pop(true);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          );
        });

    return Future.value(exit);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: DefaultTabController(
          initialIndex: widget.selPage,
          length: 4,
          child: Scaffold(
              // drawer: NavDrawer(),
              // appBar: apptab(),

              // ignore: prefer_const_constructors
              body: TabBarView(
                children: [
                  POBrowse(
                    searchdefault: widget.searchvalue ?? '',
                  ),
                  laporanbrowse(
                    searchdefault: widget.searchvalue ?? '',
                  ),
                  const receiptbrowse(),
                  const userProf()
                  // const Center(child: const Text('Content of Tab 4')),
                  // SignaturePage(),
                  // CreateSignature(),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 5))
                ]),
                child: TabBar(
                  labelStyle: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: orangeColor, width: 3.0),
                    insets: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 72.0),
                  ),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    const Tab(
                      icon: Icon(
                        Iconsax.home,
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "PO",
                    ),
                    const Tab(
                        icon: Icon(Iconsax.clipboard_import),
                        iconMargin: EdgeInsets.only(bottom: 5),
                        text: "Unsuitable Receipt"),
                    const Tab(
                        icon: Icon(Iconsax.clipboard_export),
                        iconMargin: EdgeInsets.only(bottom: 5),
                        text: "Approve Receipt"),
                    const Tab(
                      icon: Icon(
                        Iconsax.user,
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "User",
                    ),
                    // const Tab(
                    //     icon: Icon(Iconsax.archive_book),
                    //     iconMargin: EdgeInsets.only(bottom: 5),
                    //     text: "KN")
                  ],
                  labelColor: orangeColor,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  // indicatorColor: orangeColor,
                ),
              )),
        ));
  }
}
