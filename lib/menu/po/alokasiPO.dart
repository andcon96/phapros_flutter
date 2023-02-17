// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, must_be_immutable

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/menu/po/wsaPoModel.dart';

import '../../utils/styles.dart';

class DetailPO extends StatefulWidget {
  Data cartItem;
  List<Data> ListDetailPO;
  List<Data> listLine;

  DetailPO(
      {required this.cartItem,
      required this.ListDetailPO,
      required this.listLine});
  @override
  _DetailPOState createState() => _DetailPOState();
}

class _DetailPOState extends State<DetailPO> {
  String _value = "";
  final _um = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = widget.cartItem.tLviLine!;
  }

  @override
  void didUpdateWidget(DetailPO oldWidget) {
    if (oldWidget.cartItem.tLviLine != widget.cartItem.tLviLine) {
      _value = widget.cartItem.tLviLine!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(
            color: Color.fromARGB(255, 157, 154, 154),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              itemHeight: 60,
              hint: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Select Line',
                      border: InputBorder.none,
                      labelText: 'Select Line'),
                ),
              ),
              value: _value,
              // ignore: prefer_const_literals_to_create_immutables
              items: widget.listLine.map((value) {
                return DropdownMenuItem(
                    value: value.tLviLine.toString(),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                            "${value.tLviLine}  - ${value.tLvcPart} - ${value.tLvcPartDesc}"),
                      ),
                    ));
              }).toList(),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (value) {
                setState(() {
                  _value = value!;
                  widget.cartItem.tLviLine = value;
                });
              }),
        ));
  }
}

class CartWidget extends StatefulWidget {
  List<Data> cart;
  int index;
  VoidCallback callback;
  List<Data> listLine;

  CartWidget(
      {required this.cart,
      required this.index,
      required this.listLine,
      required this.callback});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  TextEditingController batch = TextEditingController();
  TextEditingController lokasi = TextEditingController();
  TextEditingController lot = TextEditingController();
  TextEditingController qtydatang = TextEditingController();
  TextEditingController qtyterima = TextEditingController();
  TextEditingController qtyreject = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: 600,
          width: double.maxFinite,
          child: Card(
            elevation: 5,
            child: Column(children: [
              // Detailpo(cartItem: sel_detail),
              DetailPO(
                listLine: widget.listLine,
                cartItem: widget.cart[widget.index],
                ListDetailPO: widget.cart,
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: batch,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Batch / Lot',
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: lokasi,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: lot,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lot',
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: qtydatang,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Datang',
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: qtyreject,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Reject',
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: qtyterima,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qty Terima',
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    print(widget.index);
                    widget.cart.removeAt(widget.index);
                    widget.callback();
                  });
                },
              ),
            ]),
          )),
    );
  }
}

class alokasipo extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  alokasipo({Key? key, required this.selectedline}) : super(key: key);

  final List<Data> selectedline;

  @override
  _alokasipoState createState() => _alokasipoState();
}

class _alokasipoState extends State<alokasipo> {
  List<Data> cart = [];
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  final _formKey = GlobalKey<FormState>();

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Widget confirmbtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: FloatingActionButton(
        onPressed: () {
          cart.add(Data(
              tLviLine: widget.selectedline[0].tLviLine,
              tLvcPart: widget.selectedline[0].tLvcPart,
              tLvcPartDesc: widget.selectedline[0].tLvcPartDesc));
          setState(() {});
        },
        heroTag: "addbtn",
        tooltip: 'Add Data',
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget addbtn() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "confirmbtn",
        tooltip: 'Confrim',
        backgroundColor: Colors.purple,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: cart.length == 0
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.purpleAccent,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        title: Text(
                          "Click the button to add new data",
                          style: content,
                        ),
                      ),
                    ))
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                              // key: UniqueKey(), Bkin keyboard otomatis ketutup.
                              itemCount: cart.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return CartWidget(
                                    listLine: widget.selectedline,
                                    cart: cart,
                                    index: index,
                                    callback: refresh);
                              }),
                        ),
                      ],
                    ),
                  )),
        floatingActionButton: AnimatedFloatingActionButton(
            fabButtons: [addbtn(), confirmbtn()],
            key: key,
            colorStartAnimation: Colors.purple,
            colorEndAnimation: Colors.purpleAccent,
            animatedIconData: AnimatedIcons.menu_close));
  }
}
