import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List<Map<String, dynamic>> sortOptions = [
    {'value': 1, 'label': 'Date'},
    {'value': 2, 'label': 'Name'},
    {'value': 3, 'label': 'Priority'},
  ];
  int? selectedSort;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 15,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            cursorColor: Colors.black,

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16.sp,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade500,
                                  // Set your desired color
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Colors
                                          .grey
                                          .shade500, // Set your desired color for focus
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: Text(
                          "search",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sort by:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        height: 40,
                        width: 40.w,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.green,
                            ),
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            value: selectedSort,
                            borderRadius: BorderRadius.circular(10),
                            items:
                                sortOptions.map((option) {
                                  return DropdownMenuItem<int>(
                                    value: option['value'],
                                    child: Text(
                                      option['label'],
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedSort = val;
                              });
                            },
                            hint: Text("Select"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.grey.shade400, height: 0),

            Expanded(
              child: ListView(
                children: List.generate(
                  5,
                  (index) => BookTile(isfirstChild: index == 0 ? true : false),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Handle register logic
              },
              child: Text('Register Now', style: TextStyle(fontSize: 16.sp)),
            ),
          ),
        ),
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final bool isfirstChild;
  const BookTile({super.key, this.isfirstChild = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
        top: isfirstChild ? 20 : 0,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,

                        child: Text(
                          "1.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              "Vimal K V",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              "test user test state stete state test user test state stete state test user test state stete state",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.red,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "22/12/2025",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5.w),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.supervisor_account_outlined,
                                      color: Colors.red,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      "Vijayakumar",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade400, height: 15),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 11,
                        child: Text(
                          "View Booking Details",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
