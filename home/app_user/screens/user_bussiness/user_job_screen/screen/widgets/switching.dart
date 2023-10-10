import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:near_mine/utility/utility.dart';

class Switching extends StatefulWidget {
  Switching({
    super.key,
    this.db,
    required this.statusBusy,
    required this.statusAvailable,
    required this.statusOff,
  });
  dynamic db;
  final bool statusBusy;
  final bool statusAvailable;
  final bool statusOff;
  @override
  _SwitchingState createState() => _SwitchingState();
}

class _SwitchingState extends State<Switching> {
  // bool isOn = false;
  // bool isAvailable = false;
  // bool isBusy = false;
  bool switchAvailable = false;
  bool switchBusy = false;
  bool switchOff = false;
  switch1(value) {
    setState(() {
      switchAvailable = value;
      switchBusy = false;
      switchOff = false;
    });
    if (widget.db != null && widget.db.update != null) {
      widget.db.update({
        "switch_available": value,
        "switch_busy": false,
        "switch_off": false,
      });
    }
  }

  switch2(value) {
    setState(() {
      switchAvailable = false;
      switchBusy = value;
      switchOff = false;
    });
    if (widget.db != null && widget.db.update != null) {
      widget.db.update({
        "switch_available": false,
        "switch_busy": value,
        "switch_off": false,
      });
    }
  }

  switch3(value) {
    setState(() {
      switchAvailable = false;
      switchBusy = false;
      switchOff = value;
    });

    if (widget.db != null && widget.db.update != null) {
      widget.db.update({
        "switch_available": false,
        "switch_busy": false,
        "switch_off": value,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switchAvailable = widget.statusAvailable;
    switchBusy = widget.statusBusy;
    switchOff = widget.statusOff;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              bool value = !switchAvailable;
              switch1(value);
            },
            child: Column(
              children: [
                Switch(
                    value: switchAvailable,
                    onChanged: (value) {
                      switch1(value);
                    }),
                Text("Available",
                    style: TextStyle(
                        color: switchAvailable ? null : Colors.grey,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              bool value = !switchBusy;
              switch2(value);
            },
            child: Column(
              children: [
                Switch(
                    value: switchBusy,
                    onChanged: (value) {
                      switch2(value);
                    }),
                Text("Busy",
                    style: TextStyle(
                        color: switchBusy ? null : Colors.grey,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              bool value = !switchOff;
              switch3(value);
            },
            child: Column(
              children: [
                Switch(
                    value: switchOff,
                    onChanged: (value) {
                      switch3(value);
                    }),
                Text("Off",
                    style: TextStyle(
                        color: switchOff ? null : Colors.grey,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget switchWidget(valueSwitch) {
    return Column(
      children: [Text("data")],
    );
  }

  void updateSwitchStatus() {
    final CollectionReference switchesCollection =
        FirebaseFirestore.instance.collection('switches');

    // switchesCollection.doc('switch1').update({'on': isOn});
    // switchesCollection.doc('switch2').update({'available': isAvailable});
    // switchesCollection.doc('switch3').update({'busy': isBusy});
  }
}
