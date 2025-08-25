# Attendance Service Algorithms

## Total Working Hours Algorithm

### Data Organization:
- Attendance records are first grouped by date to process each day separately
- For each day, records are sorted chronologically by time

### Daily Calculation:
- Find the first check-in record for the day
- Find the last check-out record for the day
- Calculate working minutes = (check-out time - check-in time)
- This captures the full span from when an employee first arrives until they last leave

### Period Aggregation:
- Daily working minutes are summed up for the period (week/month/year)
- The total is converted to hours by dividing by 60

This approach accurately measures actual time between first arrival and last departure each day, rather than counting all individual check-ins and check-outs separately.

## Absent Hours Algorithm

### Workday Identification:
- Only weekdays (Monday to Friday) are considered as workdays
- Only days up to the current date are counted (not future days)

### Absence Detection:
- A set of dates with attendance records is created
- For each workday in the period, check if the date exists in this set
- If a workday has no attendance record, it's counted as absent

### Hours Calculation:
- Each absent day is multiplied by 8 hours (standard workday)
- Total absent hours = absent days × 8

This ensures consistency across different time periods and properly accounts for weekends and future dates.

## Late Hours Algorithm

### Late Arrival Detection:
- For each day, find the first check-in record
- If check-in time is after 8:00 AM (480 minutes from midnight), it's considered late
- Late minutes = check-in time - 480 minutes

### Period Aggregation:
- Late minutes are summed up for all days in the period
- The total is converted to hours by dividing by 60

This tracks how many hours an employee arrived after the standard start time across the entire period.

---

All three algorithms work together to provide a comprehensive view of attendance patterns, work hours, and punctuality across different time periods in your application.