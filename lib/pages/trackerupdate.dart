import 'package:flutter/material.dart';

class trackerupdate extends StatefulWidget {
  const trackerupdate({super.key});

  @override
  State<trackerupdate> createState() => _trackerupdateState();
}

class _trackerupdateState extends State<trackerupdate> {
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            Container(
              child: SizedBox(height: 45),
            ),
            Container(
              width: sw / 1.2,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "What's the hold up? ",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Update your broker how things are doing.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: SizedBox(height: 15),
            ),
            Container(
              width: sw / 1.2,
              child: Text(
                "Delivery Updates: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 17),
              ),
            ),
            Container(
              child: SizedBox(height: 15),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Picked up the load. Ready to roll!",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Made it to the halfway. No issues so far",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Stuck in traffic due to an accident ahead",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Waiting at the unloading dock instructions",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Weather problems, slowing me down.",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Encountered road closures. taking a detour.",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Facing a minor mechanical issue.",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  width: sw / 1.2,
                  child: ElevatedButton(
                    child: Text(
                      "Delivery done! Getting paperwork signed.",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {},
                  ),
                )
              ]),
            ),
          ],
        ),
      )),
    );
  }
}