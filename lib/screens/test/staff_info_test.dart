import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/models/staff/staff_info.dart';

class StaffInfoTestScreen extends StatefulWidget {
  const StaffInfoTestScreen({super.key});

  @override
  State<StaffInfoTestScreen> createState() => _StaffInfoTestScreenState();
}

class _StaffInfoTestScreenState extends State<StaffInfoTestScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch staff info when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffProvider>().getStaffInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Information'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<StaffProvider>(
        builder: (context, staffProvider, child) {
          final staffInfo = staffProvider.staffInfo;

          if (staffInfo == null) {
            return const Center(
              child: Text(
                'Tap refresh to load staff information',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          switch (staffInfo.state) {
            case AsyncValueState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case AsyncValueState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${staffInfo.error}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StaffProvider>().getStaffInfo();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case AsyncValueState.success:
              return _buildStaffInfoDisplay(staffInfo.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<StaffProvider>().getStaffInfo();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildStaffInfoDisplay(StaffInfo staff) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Staff Info Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Staff Information',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Staff ID:', staff.staffId),
                  _buildInfoRow('English Name:', '${staff.firstNameEng ?? ''} ${staff.lastNameEng ?? ''}'),
                  _buildInfoRow('Khmer Name:', '${staff.firstNameKh ?? ''} ${staff.lastNameKh ?? ''}'),
                  _buildInfoRow('Email:', staff.email ?? 'N/A'),
                  _buildInfoRow('Phone:', staff.phone ?? 'N/A'),
                  _buildInfoRow('Position ID:', staff.positionId ?? 'N/A'),
                  _buildInfoRow('Branch Code:', staff.branchCode ?? 'N/A'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Leave Balance Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave Balance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLeaveBalanceItem('Annual', staff.balanceAnnually ?? '0', Colors.blue),
                      _buildLeaveBalanceItem('Sick', staff.balanceSick ?? '0', Colors.orange),
                      _buildLeaveBalanceItem('Special', staff.balanceSpecial ?? '0', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Manager Card
          if (staff.manager != null) ...[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manager',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Staff ID:', staff.manager!.staffId),
                    _buildInfoRow('Name:', '${staff.manager!.firstNameEng ?? ''} ${staff.manager!.lastNameEng ?? ''}'),
                    _buildInfoRow('Email:', staff.manager!.email ?? 'N/A'),
                    _buildInfoRow('Phone:', staff.manager!.phone ?? 'N/A'),
                    _buildInfoRow('Branch:', staff.manager!.branchCode ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Supervisor Card
          if (staff.supervisor != null) ...[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supervisor',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Staff ID:', staff.supervisor!.staffId),
                    _buildInfoRow('Name:', '${staff.supervisor!.firstNameEng ?? ''} ${staff.supervisor!.lastNameEng ?? ''}'),
                    _buildInfoRow('Email:', staff.supervisor!.email ?? 'N/A'),
                    _buildInfoRow('Phone:', staff.supervisor!.phone ?? 'N/A'),
                    _buildInfoRow('Branch:', staff.supervisor!.branchCode ?? 'N/A'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
