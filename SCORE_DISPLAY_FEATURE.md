# Score Display Feature for Daily Activities

## Overview
The score display feature allows administrators to evaluate employee daily activities and assign scores. Employees can view their scores in the activity list, with clear distinction between evaluated and non-evaluated activities.

## Implementation

### 1. Model Updates (DailyActivity)
- Added `score` field of type `double?` to the DailyActivity model
- Score range: 0-100 (nullable - null indicates not yet evaluated)
- Updated constructor, fromJson, toJson, and copyWith methods to handle score field

### 2. UI Components

#### Score Display in List Tile
The score is displayed as a small badge/chip in the activity list tile with:
- **Evaluated activities**: Shows "Score: XX.X/100" with star icon and primary color
- **Not evaluated activities**: Shows "Not evaluated" with outline star icon and gray color

#### Visual Design
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: evaluated ? primary.withOpacity(0.1) : grey.withOpacity(0.1),
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: evaluated ? primary.withOpacity(0.3) : grey.withOpacity(0.3)),
  ),
  child: Row(
    children: [
      Icon(evaluated ? Icons.star : Icons.star_outline),
      Text(evaluated ? "Score: ${score}/100" : "Not evaluated"),
    ],
  ),
)
```

### 3. Sample Data
Updated sample activities to include example scores:
- Activity 1: Score 85.5 (completed meeting)
- Activity 2: Score 92.0 (client visit)
- Activity 3: No score (in progress - not yet evaluated)

## Usage

### For Employees
- View their scores in the activity list
- Clearly see which activities have been evaluated vs. not evaluated
- Scores are displayed with appropriate visual indicators

### For Administrators (Future Enhancement)
- Ability to assign scores to activities (not implemented in this phase)
- Score range validation (0-100)
- Evaluation status tracking

## Technical Details

### Database Schema Changes
When implementing with actual backend:
```sql
ALTER TABLE daily_activities 
ADD COLUMN score DECIMAL(5,2) NULL;
```

### API Considerations
- GET endpoints should include score field in response
- PUT/PATCH endpoints for admin score assignment
- Proper validation for score range (0-100)

## File Changes
1. `lib/models/activities/daily_activies.dart` - Added score field to model
2. `lib/screens/activities/daily_activities/widgets/daily_activity_list_tile.dart` - Added score display
3. `lib/screens/activities/daily_activities/daily_activities_screen.dart` - Updated sample data and constructor calls

## Future Enhancements
1. Admin interface for score assignment
2. Score history and tracking
3. Average score calculations
4. Performance analytics based on scores
5. Score-based notifications and achievements
