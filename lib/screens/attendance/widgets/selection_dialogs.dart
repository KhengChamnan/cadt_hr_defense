import 'package:flutter/material.dart';

class SelectionDialogs {
  static void showMonthPicker({
    required BuildContext context,
    required String currentMonth,
    required Function(String) onMonthSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              children: _buildMonthButtons(context, currentMonth, onMonthSelected),
            ),
          ),
        );
      },
    );
  }
  
  static List<Widget> _buildMonthButtons(
    BuildContext context, 
    String currentMonth,
    Function(String) onMonthSelected
  ) {
    final months = [
      'January', 'February', 'March', 
      'April', 'May', 'June',
      'July', 'August', 'September', 
      'October', 'November', 'December'
    ];
    
    return months.map((month) {
      final isSelected = month == currentMonth;
      final abbreviation = month.substring(0, 3);
      
      return InkWell(
        onTap: () {
          onMonthSelected(month);
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected 
                      ? Colors.black 
                      : Colors.grey.shade300,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  abbreviation,
                  style: TextStyle(
                    color: isSelected ? Colors.black : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      );
    }).toList();
  }
  
  static void showYearPicker({
    required BuildContext context,
    required int currentYear,
    required Function(int) onYearSelected,
  }) {
    final int startYear = currentYear - 10;
    final int endYear = currentYear + 10;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: endYear - startYear + 1,
              itemBuilder: (context, index) {
                final year = startYear + index;
                return InkWell(
                  onTap: () {
                    onYearSelected(year);
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: year == currentYear 
                                ? Colors.black 
                                : Colors.grey.shade300,
                            width: year == currentYear ? 2.0 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              color: year == currentYear ? Colors.black : null,
                              fontWeight: year == currentYear ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  
  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  static int getMonthNumber(String monthName) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months.indexOf(monthName) + 1;
  }
} 