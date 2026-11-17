// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LateReportsApp());
}

class LateReportsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Late Reports',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: LateReportsListPage(),
    );
  }
}

class LateReport {
  final String id;
  final String busnumber;
  final String category;
  final String date;
  final String drivername;
  final String location;
  final String mobile;
  final String reason;
  final String route;
  final String time;
  final String busno;

  LateReport({
    required this.id,
    required this.busnumber,
    required this.category,
    required this.date,
    required this.drivername,
    required this.location,
    required this.mobile,
    required this.reason,
    required this.route,
    required this.time,
    required this.busno,
  });

  factory LateReport.fromMap(Map<dynamic, dynamic> data, String id) {
    return LateReport(
      id: id,
      busnumber: data['busnumber'] ?? 'N/A',
      category: data['category'] ?? 'N/A',
      date: data['date'] ?? 'N/A',
      drivername: data['drivername'] ?? 'N/A',
      location: data['location'] ?? 'N/A',
      mobile: data['mobile'] ?? 'N/A',
      reason: data['reason'] ?? 'N/A',
      route: data['route'] ?? 'N/A',
      time: data['time'] ?? 'N/A',
      busno: data['busname'] ?? 'N/A',
    );
  }

  String get formattedDate {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat('MMM dd, yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}

class LateReportsListPage extends StatefulWidget {
  @override
  _LateReportsListPageState createState() => _LateReportsListPageState();
}

class _LateReportsListPageState extends State<LateReportsListPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Lateform');
  List<LateReport> _reportsList = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchReportsData();
  }

  Future<void> _fetchReportsData() async {
    setState(() => _isRefreshing = true);

    try {
      final event = await _dbRef.once();
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        List<LateReport> reports = [];
        Map<dynamic, dynamic> reportsData = dataSnapshot.value as Map<dynamic, dynamic>;
        reportsData.forEach((key, value) {
          LateReport report = LateReport.fromMap(value, key.toString());
          reports.add(report);
        });

        // Sort by date (newest first)
        reports.sort((a, b) => b.date.compareTo(a.date));

        setState(() {
          _reportsList = reports;
          _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading reports: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Late Reports',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _fetchReportsData,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
          ),
        )
            : _reportsList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.report_problem,
                size: 60,
                color: Colors.blue[200],
              ),
              SizedBox(height: 20),
              Text(
                'No Late Reports',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'There are no late reports to display',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: _fetchReportsData,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: _reportsList.length,
            itemBuilder: (context, index) {
              return _buildReportCard(_reportsList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(LateReport report) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Add action when card is tapped
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange[600]!, Colors.orange[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.drivername,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bus Name: ${report.busnumber}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bus No: ${report.busno}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Late',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDetailRow(Icons.calendar_today, 'Date', report.formattedDate),
                _buildDetailRow(Icons.access_time, 'Time', report.time),
                _buildDetailRow(Icons.location_on, 'Location', report.location),
                _buildDetailRow(Icons.route, 'Route', report.route),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        report.reason,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue[600],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminHomePage(),
      ),
    );
    return false;
  }
}