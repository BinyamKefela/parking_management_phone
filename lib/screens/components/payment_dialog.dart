import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:arifpay_flutter_sdk/arifpay_flutter_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:arifpay_flutter_sdk/Model/checkoutModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class PaymentDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final String name;
  final String address;
  final String floorNumber;
  final String slotName;
  final String slotGroup;
  final int selectedSlotId;

  const PaymentDialog(
      {super.key,
      required this.onCancel,
      required this.name,
      required this.address,
      required this.floorNumber,
      required this.slotName,
      required this.slotGroup,
      required this.selectedSlotId});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  TimeOfDay _arrivalTime = TimeOfDay.now();
  TimeOfDay? _leaveTime;
  final arifpay_key = dotenv.env["arifpay_key"]!.toString();

  TimeOfDay addOneHour(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final newDt = dt.add(const Duration(hours: 1));
    return TimeOfDay(hour: newDt.hour, minute: newDt.minute);
  }

  @override
  void initState() {
    super.initState();
    _leaveTime = addOneHour(TimeOfDay.now());
    doPayment();
  }

  Future<void> doPayment() async {
    final arifPay = Arifpay(arifpay_key);
    CheckoutModel checkoutModel = CheckoutModel(
        cancelUrl: "https://error.com",
        phone: "251977171807",
        email: "email@ecample.com",
        errorUrl: "https://error.com",
        notifyUrl: "https://notify.com",
        successUrl: "https://success.com",
        paymentMethods: ["TELEBIRR"],
        expireDate: "2025-09-09T00:00:00",
        items: [
          CheckoutItem(
              name: "parking slot",
              price: 1,
              quantity: 1,
              description: "this is a slot payment",
              image: '')
        ],
        beneficiaries: [
          Beneficiary(
              accountNumber: "10002800001278", amount: 1, bank: "AWINETAA")
        ],
        lang: 'EN');
    final responseUrl = await arifPay.initializePayment(checkoutModel);
    print(r"payment response " + responseUrl.toString());
  }

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.address,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(r"slot group " + widget.slotGroup,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(r'floor number ' + widget.floorNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          Text(
                            widget.slotName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                            child: const Text('slot',
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateTime.now().year.toString() +
                        r'/' +
                        DateTime.now().month.toString() +
                        r"/" +
                        DateTime.now().day.toString()),
                    const Icon(Icons.calendar_month)
                  ]),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                          context: context, initialTime: _arrivalTime);

                      if (picked != null) {
                        setState(() {
                          _arrivalTime = picked;
                        });
                      }
                    },
                    child: Container(
                      width: 120,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(229, 237, 245, 1)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "select arrival time",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(_arrivalTime.format(context))
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                          context: context, initialTime: _leaveTime!);
                      if (picked != null) {
                        setState(() {
                          _leaveTime = picked;
                        });
                      }
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(229, 237, 245, 1)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "select leave time",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(_leaveTime!.format(context))
                          ]),
                    ),
                  )
                ],
              ),
            ),
            /*Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(229, 237, 245, 1)),
              width: double.infinity,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("subtotal"), Text("40 Br")]),
            ),*/
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
