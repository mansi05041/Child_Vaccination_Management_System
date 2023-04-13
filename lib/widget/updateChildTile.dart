import 'package:flutter/material.dart';

class UpdateChildTile extends StatefulWidget {
  final String childName;
  final String childId;
  const UpdateChildTile(
      {Key? key, required this.childId, required this.childName})
      : super(key: key);

  @override
  State<UpdateChildTile> createState() => _UpdateChildTileState();
}

class _UpdateChildTileState extends State<UpdateChildTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: Text(
                widget.childName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Change the color here
              ),
              child: const Text("Vaccine Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
