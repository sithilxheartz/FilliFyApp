import 'package:firebase_auth_tutorials/services/shift_request_service.dart';
import 'package:firebase_auth_tutorials/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftRequestView extends StatelessWidget {
  const ShiftRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.description_outlined, color: mainColor, size: 35),
                  SizedBox(width: 5),
                  Text(
                    "Pumper Requests",
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                "Consider pumpers' reasons for their requests and be flexible in adjusting them.",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 15,
                ),
              ),
              Divider(),
              StreamBuilder(
                stream: ShiftRequestService().shiftrequest,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 5,
                        ),
                        child: Column(
                          children: [Text("No Requests are available.")],
                        ),
                      ),
                    );
                  } else {
                    final shiftrequests = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: shiftrequests.length,
                      itemBuilder: (context, index) {
                        final shiftrequest = shiftrequests[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: mainColor),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pending_actions_outlined,
                                      color: mainColor,
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: 290,
                                      child: Text(
                                        "Request from: ${shiftrequest.pumperName}",
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  DateFormat(
                                    'yyyy-MMMM-dd',
                                  ).format(shiftrequest.date),
                                  style: TextStyle(
                                    color: subTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),

                                Text(
                                  shiftrequest.shiftType,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Reason:",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 290,
                                      child: Text(
                                        shiftrequest.description,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onDoubleTap: () {
                                        ShiftRequestService().deleteTask(
                                          shiftrequest.id,
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
