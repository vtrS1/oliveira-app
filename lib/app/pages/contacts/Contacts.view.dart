import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/app/pages/contacts/Add/Add.Contacts.view.dart';
import 'package:oliveira_fotos/app/pages/contacts/Contacts.controller.dart';

class ContactsView extends StatelessWidget {
  final ContactsController controller =
      Get.put<ContactsController>(ContactsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Contatos (Os: ${controller.os.id})',
              style:
                  Get.theme.appBarTheme.titleTextStyle!.copyWith(fontSize: 18)),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black87),
          actions: [
            IconButton(
              icon: Icon(FeatherIcons.plus),
              onPressed: () async {
                showCupertinoModalBottomSheet(
                    expand: false,
                    enableDrag: true,
                    bounce: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    isDismissible: true,
                    context: context,
                    builder: (cttxReview) => AddContatoView(controller.os));
              },
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: GetBuilder<ContactsController>(
                init: controller,
                initState: (_) => controller.init(),
                builder: (_) => ListView.builder(
                    itemCount: _.contacts.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 10),
                            title: Text(_.contacts[index].tipoContatosNome ??
                                'Contato'),
                            subtitle: Text(_.contacts[index].contato ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: Icon(FeatherIcons.edit),
                                //   onPressed: () {
                                //     // _.updateContact(_.contacts[index]);
                                //   },
                                // ),
                                IconButton(
                                  icon: Icon(
                                    _.contacts[index].status == 1
                                        ? FeatherIcons.toggleRight
                                        : FeatherIcons.toggleLeft,
                                  ),
                                  color: _.contacts[index].status == 1
                                      ? Colors.green
                                      : Colors.red[200],
                                  onPressed: () {
                                    _.toggleContact(_.contacts[index]);
                                  },
                                )
                              ],
                            ),
                          ),
                        )))));
  }
}
