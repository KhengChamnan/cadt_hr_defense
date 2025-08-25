// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  AttendanceReportScreenState createState() => AttendanceReportScreenState();
}

class AttendanceReportScreenState extends State<AttendanceReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Your actual API data
  final List<Map<String, dynamic>> apiData = [
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-19",
      "attendance_time": "11:31:09",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-19",
      "attendance_time": "11:37:10",
      "in_out": "out",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-19",
      "attendance_time": "11:39:56",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-19",
      "attendance_time": "11:40:26",
      "in_out": "out",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-19",
      "attendance_time": "11:41:18",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-19",
      "attendance_time": "11:41:31",
      "in_out": "out",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-20",
      "attendance_time": "17:43:09",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-20",
      "attendance_time": "17:46:35",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-21",
      "attendance_time": "10:01:47",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-21",
      "attendance_time": "14:13:05",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-21",
      "attendance_time": "14:20:34",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-21",
      "attendance_time": "14:21:26",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-23",
      "attendance_time": "13:28:42",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-23",
      "attendance_time": "14:46:40",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-25",
      "attendance_time": "23:04:40",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-25",
      "attendance_time": "23:56:54",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-30",
      "attendance_time": "14:17:34",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-30",
      "attendance_time": "14:23:17",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-30",
      "attendance_time": "14:24:08",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-30",
      "attendance_time": "14:32:24",
      "in_out": "out",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-05-30",
      "attendance_time": "14:41:43",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "12:05:07",
      "in_out": "out",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "15:19:44",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "15:21:04",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "15:21:54",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "15:27:28",
      "in_out": "in",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "15:28:37",
      "in_out": "out",
      "status": "1"
    },
    {
      "profile_id": "U2501160001",
      "profile_name": "Buntheuorn Admin",
      "branch_id": "PALM-00170001",
      "attendance_date": "2025-06-02",
      "attendance_time": "15:30:02",
      "in_out": "in",
      "status": "1"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Attendance Reports', 
          style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 18),
                      SizedBox(width: 8),
                      Text('List View'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.analytics, size: 18),
                      SizedBox(width: 8),
                      Text('Summary'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AttendanceListView(apiData: apiData),
          AttendanceSummaryView(apiData: apiData),
        ],
      ),
    );
  }
}

class AttendanceListView extends StatefulWidget {
  final List<Map<String, dynamic>> apiData;
  
  const AttendanceListView({Key? key, required this.apiData}) : super(key: key);

  @override
  AttendanceListViewState createState() => AttendanceListViewState();
}

class AttendanceListViewState extends State<AttendanceListView> {
  Map<String, bool> expandedDays = {};
  
  Map<String, List<Map<String, dynamic>>> get groupedByDate {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var record in widget.apiData) {
      String date = record['attendance_date'];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(record);
    }
    
    // Sort dates in descending order
    var sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    Map<String, List<Map<String, dynamic>>> sortedGrouped = {};
    for (String key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    
    return sortedGrouped;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "Buntheuorn Admin",
                      items: ["Buntheuorn Admin"]
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  foregroundColor: Colors.blue[600],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green[50],
                  foregroundColor: Colors.green[600],
                ),
              ),
            ],
          ),
        ),
        
        // List Content
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: groupedByDate.keys.length,
            itemBuilder: (context, index) {
              String date = groupedByDate.keys.elementAt(index);
              List<Map<String, dynamic>> dayRecords = groupedByDate[date]!;
              bool isExpanded = expandedDays[date] ?? false;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Date Header
                    InkWell(
                      onTap: () {
                        setState(() {
                          expandedDays[date] = !isExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.blue[600],
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEEE, MMM dd, yyyy')
                                        .format(DateTime.parse(date)),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${dayRecords.length} entries',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildStatusChip(dayRecords),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Expanded Records
                    if (isExpanded) ...[
                      const Divider(height: 1),
                      ...dayRecords.map((record) => _buildRecordTile(record)),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(List<Map<String, dynamic>> records) {
    int checkIns = records.where((r) => r['in_out'] == 'in').length;
    int checkOuts = records.where((r) => r['in_out'] == 'out').length;
    
    Color bgColor = Colors.green[50]!;
    Color textColor = Colors.green[700]!;
    
    // Warning for unmatched entries
    if (checkIns > checkOuts && checkOuts == 0) {
      bgColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
    } else if (checkIns != checkOuts) {
      bgColor = Colors.yellow[50]!;
      textColor = Colors.yellow[800]!;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$checkIns IN / $checkOuts OUT',
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecordTile(Map<String, dynamic> record) {
    bool isCheckIn = record['in_out'] == 'in';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isCheckIn ? Colors.green[500] : Colors.red[500],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            isCheckIn ? Icons.login : Icons.logout,
            color: isCheckIn ? Colors.green[600] : Colors.red[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCheckIn ? 'Check In' : 'Check Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isCheckIn ? Colors.green[700] : Colors.red[700],
                  ),
                ),
                Text(
                  record['profile_name'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                record['attendance_time'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                record['branch_id'],
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceSummaryView extends StatelessWidget {
  final List<Map<String, dynamic>> apiData;
  
  const AttendanceSummaryView({Key? key, required this.apiData}) : super(key: key);

  Map<String, Map<String, int>> get dailySummary {
    Map<String, Map<String, int>> summary = {};
    
    for (var record in apiData) {
      String date = record['attendance_date'];
      if (!summary.containsKey(date)) {
        summary[date] = {'in': 0, 'out': 0};
      }
      summary[date]![record['in_out']] = (summary[date]![record['in_out']] ?? 0) + 1;
    }
    
    return Map.fromEntries(
      summary.entries.toList()..sort((a, b) => b.key.compareTo(a.key))
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = dailySummary;
    final totalDays = summary.keys.length;
    final totalEntries = apiData.length;
    final totalCheckIns = apiData.where((r) => r['in_out'] == 'in').length;
    final totalCheckOuts = apiData.where((r) => r['in_out'] == 'out').length;
    final irregularDays = summary.values.where((day) => day['in']! != day['out']!).length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Buntheuorn Admin',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Branch: PALM-00170001',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildStatCard('Working Days', '$totalDays', Icons.calendar_month, Colors.blue),
              _buildStatCard('Total Entries', '$totalEntries', Icons.touch_app, Colors.purple),
              _buildStatCard('Check Ins', '$totalCheckIns', Icons.login, Colors.green),
              _buildStatCard('Check Outs', '$totalCheckOuts', Icons.logout, Colors.red),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Alert Card for Irregular Patterns
          if (irregularDays > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[600], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attention Required',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        Text(
                          '$irregularDays days with unmatched check-ins/outs',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Daily Breakdown
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Daily Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...summary.entries.map((entry) => _buildDailySummaryTile(
                  date: entry.key,
                  checkIns: entry.value['in']!,
                  checkOuts: entry.value['out']!,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummaryTile({
    required String date,
    required int checkIns,
    required int checkOuts,
  }) {
    bool isIrregular = checkIns != checkOuts;
    List<Map<String, dynamic>> dayRecords = apiData.where((r) => r['attendance_date'] == date).toList();
    String firstTime = dayRecords.isNotEmpty ? dayRecords.first['attendance_time'] : '--';
    String lastTime = dayRecords.isNotEmpty ? dayRecords.last['attendance_time'] : '--';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isIrregular ? Colors.orange[500] : Colors.green[500],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM dd, yyyy').format(DateTime.parse(date)),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Check Ins: $checkIns',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Check Outs: $checkOuts',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                firstTime,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                lastTime,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}