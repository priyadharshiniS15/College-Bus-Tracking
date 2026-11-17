import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SeatAvailability extends StatefulWidget {
  final String akey;
  final String seat;
  final String busno;
  final String date;
  final String route;

  const SeatAvailability({
    Key? key,
    required this.akey,
    required this.seat,
    required this.busno,
    required this.date,
    required this.route,
  }) : super(key: key);

  @override
  _SeatAvailabilityState createState() => _SeatAvailabilityState();
}

class _SeatAvailabilityState extends State<SeatAvailability> {
  List<bool> seatStatus = [];
  int totalSeats = 0;
  int availableSeats = 0;
  String? userId;
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  bool hasBooked = false;
  int? selectedSeatIndex;
  int? existingSeatNumber;
  Set<int> occupiedSeats = {};

  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeSeats();
    _getCurrentUser();
  }

  void _initializeSeats() {
    try {
      totalSeats = int.parse(widget.seat);
      availableSeats = totalSeats;
      seatStatus = List<bool>.filled(totalSeats, false);
    } catch (e) {
      totalSeats = 0;
      availableSeats = 0;
      seatStatus = [];
    }
  }

  Future<void> _getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        await _fetchStudentData(userId!);
        await _fetchAllBookings();
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Failed to get user data: ${e.toString()}');
    }
  }

  Future<void> _fetchStudentData(String uid) async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Student').child(uid).get();
      if (snapshot.value != null) {
        setState(() {
          studentData = Map<String, dynamic>.from(snapshot.value as Map);
        });
      }
    } catch (e) {
      _showError('Failed to fetch student data');
    }
  }

  Future<void> _fetchAllBookings() async {
    try {
      DataSnapshot snapshot = await _dbRef.child('Seats')
          .orderByChild('busNo_date_route')
          .equalTo('${widget.busno}_${widget.date}_${widget.route}')
          .once()
          .then((snapshot) => snapshot.snapshot);

      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        values.forEach((key, value) {
          int seatNum = value['seatNumber'];
          occupiedSeats.add(seatNum);

          if (seatNum <= totalSeats) {
            seatStatus[seatNum - 1] = true;
          }


          if (value['studentId'] == userId) {
            setState(() {
              hasBooked = true;
              existingSeatNumber = seatNum;
            });
          }
        });


        setState(() {
          availableSeats = totalSeats - occupiedSeats.length;
        });
      }
    } catch (e) {
      print('Error fetching all bookings: $e');
    }
  }

  void _toggleSeat(int index) {
    if (hasBooked) {
      _showError('You have already selected a seat');
      return;
    }

    if (occupiedSeats.contains(index + 1)) {
      _showError('This seat is already occupied');
      return;
    }

    setState(() {
      if (selectedSeatIndex != null && selectedSeatIndex != index) {

        seatStatus[selectedSeatIndex!] = false;
        availableSeats++;
      }

      seatStatus[index] = !seatStatus[index];
      if (seatStatus[index]) {
        availableSeats--;
        selectedSeatIndex = index;
      } else {
        availableSeats++;
        selectedSeatIndex = null;
      }
    });
  }

  Future<void> _confirmBooking() async {
    if (selectedSeatIndex == null) {
      _showError('Please select a seat first');
      return;
    }

    if (studentData == null) {
      _showError('Student data not found');
      return;
    }

    if (hasBooked) {
      _showError('You have already selected a seat');
      return;
    }

    if (occupiedSeats.contains(selectedSeatIndex! + 1)) {
      _showError('This seat is already occupied');
      return;
    }

    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Seat Selection'),
        content: Text(
          'You are about to select Seat ${selectedSeatIndex! + 1} on Bus ${widget.busno} for ${widget.date}.\n\n'
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[800],
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await _processBooking();
    }
  }

  Future<void> _processBooking() async {
    try {
      setState(() {
        isLoading = true;
      });


      String compositeKey = '${widget.busno}_${widget.date}_${widget.route}';

      DatabaseReference seatRef = _dbRef.child('Seats').push();
      await seatRef.set({
        'busNo': widget.busno,
        'date': widget.date,
        'route': widget.route,
        'busNo_date_route': compositeKey,
        'seatNumber': selectedSeatIndex! + 1,
        'studentId': userId,
        'studentName': studentData!['name'],
        'studentEmail': studentData!['email'],
        'studentRollNo': studentData!['rollno'],
        'year': studentData!['year'],
        'department': studentData!['department'],
        'studentIDNo': studentData!['idno'],
        'bookingTime': DateTime.now().toIso8601String(),
        'status': 'confirmed',
      });


      setState(() {
        hasBooked = true;
        existingSeatNumber = selectedSeatIndex! + 1;
        occupiedSeats.add(selectedSeatIndex! + 1);
        availableSeats--;
        isLoading = false;
      });

      _showSuccess('Seat selected successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Selection failed: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildLegendItem(Color bgColor, Color textColor, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Seat Availability'),
          backgroundColor: Colors.blue[800],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seat Availability - Bus ${widget.busno}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bus No: ${widget.busno}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Route: ${widget.route}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Date: ${widget.date}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$availableSeats Available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            if (studentData != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue[800]),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentData!['name'] ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Roll No: ${studentData!['rollno'] ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        if (hasBooked && existingSeatNumber != null)
                          Text(
                            'Your Seat: $existingSeatNumber',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Driver',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: totalSeats,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedSeatIndex == index;
                        bool isExistingBooking = hasBooked && existingSeatNumber == index + 1;
                        bool isOccupied = occupiedSeats.contains(index + 1) && !isExistingBooking;

                        return GestureDetector(
                          onTap: isOccupied || isExistingBooking ? null : () => _toggleSeat(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isExistingBooking
                                  ? Colors.purple[200] // User's existing seat
                                  : isSelected
                                  ? Colors.blue[200] // Selected seat
                                  : isOccupied
                                  ? Colors.red[200] // Occupied by others
                                  : Colors.green[200], // Available
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2)),
                              ],
                              border: isSelected || isExistingBooking
                                  ? Border.all(
                                  color: isExistingBooking
                                      ? Colors.purple[800]!
                                      : Colors.blue[800]!,
                                  width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chair,
                                  size: 32,
                                  color: isExistingBooking
                                      ? Colors.purple[800]
                                      : isSelected
                                      ? Colors.blue[800]
                                      : isOccupied
                                      ? Colors.red[800]
                                      : Colors.green[800],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Seat ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isExistingBooking
                                        ? Colors.purple[800]
                                        : isSelected
                                        ? Colors.blue[800]
                                        : isOccupied
                                        ? Colors.red[800]
                                        : Colors.green[800],
                                  ),
                                ),
                                if (isOccupied)
                                  Text(
                                    'Occupied',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                if (isExistingBooking)
                                  Text(
                                    'Your Seat',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.purple[800],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                          Colors.green[200]!,
                          Colors.green[800]!,
                          'Available',
                        ),
                        SizedBox(width: 10),
                        _buildLegendItem(
                          Colors.red[200]!,
                          Colors.red[800]!,
                          'Occupied',
                        ),
                        SizedBox(width: 10),
                        _buildLegendItem(
                          Colors.blue[200]!,
                          Colors.blue[800]!,
                          'You',
                        ),
                        if (hasBooked) SizedBox(width: 10),
                        if (hasBooked)
                          _buildLegendItem(
                            Colors.purple[200]!,
                            Colors.purple[800]!,
                            'Your Seat',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: hasBooked ? null : _confirmBooking,
                child: Text(
                  hasBooked ? 'Seat Selection Confirmed' : 'Confirm Seat Selection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}