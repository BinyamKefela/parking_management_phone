import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentDialog extends StatefulWidget {
  final VoidCallback onCancel;
  const PaymentDialog({super.key, required this.onCancel});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Megenagna",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("city mall infront of zefmesh",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text("Br 20 per hour",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("3rd floor",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Card(
                  elevation: 5,
                  color: const Color.fromRGBO(66, 122, 154, 1),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "A-09",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                            child: Text("4X2",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8)),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(229, 237, 245, 1)),
              width: double.infinity,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("25/2/7"), Icon(Icons.calendar_month)]),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(229, 237, 245, 1)),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("arrive"), Text("03:00")]),
                  ),
                  Container(
                    width: 120,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(229, 237, 245, 1)),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("leave"), Text("05:00")]),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(229, 237, 245, 1)),
              width: double.infinity,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("subtotal"), Text("40 Br")]),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(66, 122, 154, 1),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text("proced to payment"))),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(228, 137, 137, 1),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      widget.onCancel();
                    },
                    child: const Text("cancel")))
          ],
        ),
      ),
    );
  }
}
