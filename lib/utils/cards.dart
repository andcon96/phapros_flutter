import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_template/utils/styles.dart';

// ignore: must_be_immutable
class CardBuild extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CardBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ExpandableNotifier(
            child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          child: Card(
              elevation: 0,
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                        theme: const ExpandableThemeData(
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          tapBodyToCollapse: true,
                        ),
                        header: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Iconsax.note_2,
                                  color: Colors.purple,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "PO Number: ",
                                          style: title,
                                        ),
                                        Text(
                                          'Vendor : ',
                                          softWrap: true,
                                          style: subTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        collapsed: Text(
                          'Total : ',
                          softWrap: true,
                          style: content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Ship To :',
                                  style: content,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Order Date :',
                                  style: content,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Due Date :',
                                  style: content,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Currency :',
                                  style: content,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Total:',
                                  style: content,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'PPN:',
                                  style: content,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )),
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              theme:
                                  const ExpandableThemeData(crossFadePoint: 0),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
        )));
  }
}
