# PALM HR Mobile Application

## Overview

PALM HR Mobile Application is a comprehensive Human Resources management system built with Flutter. The application provides employees and HR personnel with powerful tools to manage attendance, leave requests, payroll, and personnel information in a modern, intuitive mobile interface.

### Key Features

- 🕐 **Attendance Management** - Clock in/out, view attendance history, and track working hours
- 🏖️ **Leave Management** - Request leave, view leave balance, and track approval status
- 💰 **Payroll Management** - View salary details, account information, and withdrawal history
- 👥 **Personnel Management** - Staff directory, team management, and role administration
- 📊 **Reports & Analytics** - Comprehensive attendance reports and performance metrics
- 🔐 **Authentication** - Secure login with biometric support
- 📍 **Location Services** - GPS tracking for attendance verification
- 🔔 **Notifications** - Real-time updates for approvals and system alerts

### Architecture Patterns

This application follows clean architecture principles with the following patterns:

- **Repository Pattern** - Abstract data layer with mock and Laravel implementations
- **Provider Pattern** - State management using Flutter Provider for reactive UI updates
- **Service Layer** - Complex business logic separated into dedicated service classes
- **Factory Pattern** - Repository factory for easy switching between mock and real data sources

## Project Structure

The application is organized into logical folders following Flutter best practices:

```
lib/
├── main.dart                   # Application entry point
├── app.dart                   # App widget wrapper
├── data/                      # Data layer - repositories, DTOs, network
├── models/                    # Data models and entities
├── providers/                 # State management (Provider pattern)
├── services/                  # Business logic services
├── screens/                   # UI screens and pages
├── widgets/                   # Reusable UI components
├── utils/                     # Utilities and helper functions
└── theme/                     # App theming and styling
```

### Detailed Folder Structure

#### 📁 `data/` - Data Layer
Contains all data-related components following the repository pattern:

- **`dto/`** - Data Transfer Objects for API communication
  - `approval_dto.dart` - Approval process data structures
  - `attendance_dto.dart` - Attendance record data structures
  - `leave_dto.dart` - Leave request data structures
  - `settings_dto.dart` - Application settings data
  - `staff_dto.dart` - Staff member data structures
  - `user_dto.dart` - User profile data structures

- **`repository/`** - Repository pattern implementation
  - **`abstract/`** - Abstract repository interfaces
  - **`laravel_repository/`** - Laravel backend implementations
  - **`mock_repository/`** - Mock implementations for testing
  - `repository_factory.dart` - Factory for repository creation

- **`Network/`** - Network layer configuration
  - `api_constant.dart` - API constants and configuration
  - `api_endpoints.dart` - API endpoint definitions

- **`dummydata/`** - Mock data for development and testing

#### 📁 `models/` - Domain Models
Contains business entities and domain models:

- **`attendance/`** - Attendance-related models
- **`leaves/`** - Leave management models
- **`approval/`** - Approval workflow models
- **`commission/`** - Commission calculation models
- **`payroll/`** - Payroll and account models
- **`staff/`** - Staff and team management models
- **`activities/`** - Daily activities and training models

#### 📁 `providers/` - State Management
Provider pattern implementation for reactive state management:

- `auth/` - Authentication state management
- `attendance/` - Attendance data and UI state
- `leave/` - Leave request and approval state
- `approval/` - Approval workflow state
- `staff/` - Staff management state
- `providers_setup.dart` - Provider configuration and setup

#### 📁 `services/` - Business Logic
Service layer containing complex business logic:

- `attendance_service.dart` - Attendance calculations and business rules
- `attendance_statistics_service.dart` - Attendance analytics
- `location_service.dart` - GPS and location management
- `camera_services.dart` - Camera and photo capture
- `pdf_service.dart` - PDF generation and management
- `notification_util.dart` - Push notification handling

#### 📁 `screens/` - User Interface
Application screens organized by feature:

- **`splash/`** - App startup and loading screens
- **`auth_screen/`** - Login and authentication UI
- **`home/`** - Dashboard and home screen
- **`app/`** - Main app navigation and feature access
- **`attendance/`** - Attendance tracking and reporting
- **`leave/`** - Leave request and management
- **`payroll/`** - Payroll and financial information
- **`approval/`** - Approval workflows and management
- **`settings/`** - App settings and configuration
- **`profile/`** - User profile management

#### 📁 `widgets/` - Reusable Components
Common UI components used across the application:

- **`inputs/`** - Custom input fields and forms
- **`actions/`** - Action buttons and interactive elements
- **`display/`** - Display components and cards
- **`custom_dropdowns/`** - Specialized dropdown components
- `bottom_navigator.dart` - Main navigation component
- `loading_widget.dart` - Loading states and indicators

#### 📁 `utils/` - Utilities and Helpers
Helper functions and utilities:

- `constants.dart` - App-wide constants
- `colors.dart` - Color definitions
- `date_time_utils.dart` - Date and time utilities
- `location_management.dart` - Location services
- `error_handler.dart` - Error handling utilities
- `responsive.dart` - Responsive design helpers
- `routes.dart` - App routing configuration

#### 📁 `theme/` - Visual Design
Application theming and visual design:

- `app_theme.dart` - Main theme configuration
- `theme_config.dart` - Theme customization options

## Dependencies

The application uses carefully selected packages to provide robust functionality:

### Core Flutter Dependencies

#### **State Management & Architecture**
- **`provider: ^6.1.2`** - State management using Provider pattern for reactive UI updates
- **`flutter: sdk`** - Core Flutter framework

#### **UI & User Experience**
- **`cupertino_icons: ^1.0.2`** - iOS-style icons for consistent cross-platform design
- **`google_fonts: ^6.2.1`** - Custom fonts from Google Fonts library
- **`loading_animation_widget: ^1.3.0`** - Beautiful loading animations
- **`animated_text_kit: ^4.2.2`** - Animated text effects
- **`carousel_slider: ^5.0.0`** - Image and content carousels
- **`flutter_spinkit: ^5.2.1`** - Additional loading indicators
- **`skeletonizer: ^2.1.0`** - Skeleton loading screens
- **`device_preview: ^1.2.0`** - Device preview for responsive testing
- **`flutter_screenutil: ^5.9.3`** - Screen size adaptation

#### **Navigation & Routing**
- **`persistent_bottom_nav_bar: any`** - Persistent bottom navigation
- **`restart_app: ^1.3.2`** - App restart functionality

#### **Network & API**
- **`http: ^1.4.0`** - HTTP client for API communication
- **`cached_network_image: ^3.4.1`** - Efficient image loading and caching

#### **Data & Storage**
- **`shared_preferences: ^2.3.4`** - Local key-value storage
- **`shared_preferences_web: ^2.4.2`** - Web support for shared preferences
- **`path_provider: ^2.1.4`** - File system path access

#### **Media & Files**
- **`image_picker: ^1.1.2`** - Camera and gallery image selection
- **`image_picker_for_web: ^3.0.6`** - Web support for image picker
- **`file_picker: ^10.2.0`** - File selection from device storage
- **`video_player: ^2.8.3`** - Video playback functionality
- **`flutter_svg: ^2.0.9`** - SVG image support

#### **Location & Maps**
- **`geolocator: ^14.0.1`** - GPS location services
- **`geocoding: ^4.0.0`** - Address geocoding and reverse geocoding
- **`google_maps_flutter: ^2.5.3`** - Google Maps integration

#### **Authentication & Security**
- **`local_auth: ^2.2.0`** - Biometric authentication (fingerprint, face ID)
- **`permission_handler: ^12.0.0+1`** - Runtime permission handling

#### **PDF & Documents**
- **`flutter_pdfview: ^1.4.0`** - PDF viewing functionality
- **`printing: ^5.13.4`** - PDF printing and sharing
- **`pdf: ^3.11.1`** - PDF generation and manipulation

#### **QR Code & Barcode**
- **`qr_flutter: ^4.1.0`** - QR code generation
- **`qr_code_scanner_plus: ^2.0.10+1`** - QR code scanning

#### **Charts & Data Visualization**
- **`fl_chart: ^0.66.1`** - Beautiful charts and graphs
- **`syncfusion_flutter_datepicker: ^27.2.5`** - Advanced date picker
- **`syncfusion_flutter_charts: ^27.2.5`** - Professional charts
- **`syncfusion_flutter_gauges: ^27.2.5`** - Gauge widgets

#### **Notifications & Communication**
- **`flutter_local_notifications: ^19.2.1`** - Local push notifications
- **`url_launcher: ^6.3.2`** - Launch URLs, phone calls, emails

#### **Localization & Formatting**
- **`intl: ^0.20.2`** - Internationalization and date formatting
- **`khmer_fonts: ^0.0.6`** - Khmer language font support

#### **Utilities**
- **`logging: ^1.3.0`** - Logging and debugging utilities
- **`font_awesome_flutter: ^10.8.0`** - Font Awesome icons

#### **Development & Build Tools**
- **`flutter_launcher_icons: ^0.14.3`** - App icon generation
- **`flutter_lints: ^5.0.0`** - Dart linting rules
- **`flutter_test: sdk`** - Testing framework

### Dependency Overrides
- **`geolocator_android: 4.6.1`** - Specific Android geolocator version for compatibility
- **`intl: ^0.20.2`** - Ensures consistent internationalization version

## Application Architecture

The PALM HR application follows clean architecture principles with clear separation of concerns. The architecture is designed to be maintainable, testable, and scalable.

### Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │    Business     │    │      Data       │
│     Layer       │◄──►│     Logic       │◄──►│     Layer       │
│                 │    │     Layer       │    │                 │
│ • Screens       │    │ • Services      │    │ • Repositories  │
│ • Widgets       │    │ • Providers     │    │ • Models        │
│ • UI Components │    │ • State Mgmt    │    │ • Network       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 1. Repository Pattern 🏛️

The repository pattern provides a clean abstraction layer for data access, allowing easy switching between different data sources.

#### Architecture Components:

**Abstract Layer (`data/repository/abstract/`)**
```dart
abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance();
  Future<Map<String, dynamic>> postAttendance(Attendance attendance);
}
```

**Implementation Layers:**
- **Laravel Repository (`data/repository/laravel_repository/`)** - Production API integration
- **Mock Repository (`data/repository/mock_repository/`)** - Development and testing data

**Factory Pattern (`repository_factory.dart`)**
```dart
class RepositoryFactory {
  AttendanceRepository getAttendanceRepository() {
    if (_useMockRepositories) {
      return MockAttendanceRepository();
    } else {
      return LaravelAttendanceRepository();
    }
  }
}
```

#### Benefits:
- ✅ **Testability** - Easy to mock data for testing
- ✅ **Flexibility** - Switch between mock and real data
- ✅ **Maintainability** - Changes to data layer don't affect business logic
- ✅ **Development Speed** - Work with mock data while backend is being developed

### 2. Provider Pattern (State Management) 🔄

The app uses Flutter's Provider package for reactive state management, following the MVVM pattern.

#### Provider Structure:

**Authentication Provider (`providers/auth/`)**
```dart
class AuthProvider extends ChangeNotifier {
  AuthRepository _repository;
  AsyncValue<User>? _user;
  
  Future<void> login(String username, String password) async {
    _user = AsyncValue.loading();
    notifyListeners();
    
    try {
      final result = await _repository.login(username, password);
      _user = AsyncValue.data(result);
    } catch (error) {
      _user = AsyncValue.error(error);
    }
    notifyListeners();
  }
}
```

**Provider Setup (`providers_setup.dart`)**
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => AttendanceProvider()),
    ChangeNotifierProvider(create: (_) => LeaveProvider()),
    // ... other providers
  ],
  child: MyApp(),
)
```

#### AsyncValue Pattern:
```dart
class AsyncValue<T> {
  final AsyncValueState state;
  final T? data;
  final Object? error;
  
  bool get isLoading => state == AsyncValueState.loading;
  bool get hasData => state == AsyncValueState.success && data != null;
  bool get hasError => state == AsyncValueState.error;
}
```

#### Benefits:
- ✅ **Reactive UI** - UI automatically updates when state changes
- ✅ **Centralized State** - Single source of truth for each feature
- ✅ **Loading States** - Built-in loading, success, and error states
- ✅ **Performance** - Only rebuilds widgets that depend on changed data

### 3. Service Layer (Business Logic) ⚙️

Complex business logic is extracted into service classes, keeping providers clean and focused on state management.

#### Service Examples:

**Attendance Service (`services/attendance_service.dart`)**
```dart
class AttendanceService {
  /// Calculates weekly attendance summary
  static Map<String, String> getWeeklySummaryData(
    AttendanceProvider provider,
    {int attendanceType = 1}
  ) {
    // Complex business logic for calculating:
    // - Total working hours
    // - Attendance rate
    // - Average hours per day
    // - Absent hours
    return {
      'totalHours': _formatMinutes(totalMinutes),
      'attendanceRate': "$presentDays/$workingDays",
      'averageHours': _formatMinutes(avgMinutes),
      'absentHours': _formatMinutes(absentMinutes),
    };
  }
}
```

**PDF Service (`services/pdf_service.dart`)**
- PDF generation for reports
- Document formatting and styling
- File management and sharing

**Location Service (`services/location_service.dart`)**
- GPS tracking for attendance
- Address geocoding
- Location permission handling

#### Benefits:
- ✅ **Single Responsibility** - Each service has one clear purpose
- ✅ **Reusability** - Services can be used across multiple providers
- ✅ **Testability** - Business logic can be tested independently
- ✅ **Maintainability** - Complex logic is isolated and documented

### 4. Data Flow Architecture 🔄

#### Request Flow:
```
UI Widget → Provider → Service → Repository → API/Mock Data
                ↓
         notifyListeners()
                ↓
          Widget Rebuild
```

#### Example Flow - Attendance Loading:
1. **UI Trigger**: User opens attendance screen
2. **Provider**: `AttendanceProvider.getAttendanceList()`
3. **Service**: `AttendanceService.calculateWeeklySummary()`
4. **Repository**: `AttendanceRepository.getAttendance()`
5. **Data Source**: Laravel API or Mock data
6. **State Update**: Provider updates AsyncValue and notifies listeners
7. **UI Update**: Widgets rebuild with new data

### 5. Error Handling Strategy 🛡️

**AsyncValue Error States:**
```dart
Consumer<AttendanceProvider>(
  builder: (context, provider, child) {
    final attendanceList = provider.attendanceList;
    
    if (attendanceList?.isLoading == true) {
      return LoadingWidget();
    }
    
    if (attendanceList?.hasError == true) {
      return ErrorWidget(attendanceList!.error);
    }
    
    if (attendanceList?.hasData == true) {
      return AttendanceListView(attendanceList!.data);
    }
    
    return EmptyStateWidget();
  },
)
```

**Global Error Handling:**
- Centralized error logging
- User-friendly error messages
- Graceful fallbacks for network issues

### 6. Dependency Injection 💉

**Repository Factory Pattern:**
```dart
// In main.dart
final repositoryFactory = RepositoryFactory();
repositoryFactory.setUseMockRepositories(false);

// In providers_setup.dart
ChangeNotifierProvider(
  create: (_) => AttendanceProvider(
    attendanceRepository: repositoryFactory.getAttendanceRepository(),
  ),
)
```

This architecture ensures:
- **Scalability** - Easy to add new features
- **Maintainability** - Clear separation of concerns
- **Testability** - Each layer can be tested independently
- **Flexibility** - Easy to swap implementations

## Application Flow

### User Journey Overview

The application follows a logical flow from startup to feature usage:

```
App Start → Authentication → Home Dashboard → Feature Selection → Specific Functionality
```

### Detailed Application Flow

#### 1. 🚀 Application Startup

```
main.dart
    ↓
App Widget (app.dart)
    ↓
ProviderSetup (providers_setup.dart)
    ↓
Repository Factory Initialization
    ↓
MultiProvider Setup (Auth, Attendance, Leave, etc.)
    ↓
MyApp Widget (MaterialApp)
    ↓
SplashScreen
```

**Key Components:**
- **Repository Factory**: Configures data sources (Mock vs Laravel)
- **Provider Setup**: Initializes all state management providers
- **Splash Screen**: Shows loading animation while app initializes

#### 2. 🔐 Authentication Flow

```
SplashScreen
    ↓
Auth Check (AuthProvider)
    ↓
┌─ Logged In ────────┐    ┌─ Not Logged In ──┐
│  Load User Data    │    │  Login Screen    │
│  Navigate to Home  │    │  Authenticate    │
└────────────────────┘    │  Save Token      │
                          │  Navigate to Home│
                          └──────────────────┘
```

**Authentication Features:**
- Token-based authentication
- Biometric login support (fingerprint, face ID)
- Remember credentials functionality
- Automatic session management

#### 3. 🏠 Home Dashboard Flow

```
Home Screen (HomeScreen)
    ↓
┌─────────────────────────────────────┐
│            Home Dashboard           │
│                                     │
│  ┌─ Profile Card ─────────────────┐  │
│  │  User Info & Status           │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌─ Attendance Pie Chart ────────┐  │
│  │  Present/Absent/Late Summary  │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌─ QR Scanner Button ───────────┐  │
│  │  Quick Attendance Check-in    │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
    ↓
Bottom Navigation (4 tabs)
```

**Home Screen Components:**
- **Profile Card**: Displays user information and current status
- **Attendance Chart**: Visual summary of attendance data
- **QR Scanner**: Quick access to attendance check-in
- **Real-time Data**: Updates automatically via providers

#### 4. 📱 App Features Navigation

```
Bottom Navigation Bar
    ↓
┌─ Home ─┐  ┌─ App ──┐  ┌─ Report ─┐  ┌─ Setting ─┐
│ 🏠     │  │ 📱     │  │ 📊       │  │ ⚙️        │
│ Dashboard│ Features │  Reports   │  Settings   │
└────────┘  └────────┘  └──────────┘  └───────────┘
                ↓
         App Feature Screen
              ↓
    ┌─ Attendance ─┐ ┌─ Leave ─┐ ┌─ Personnel ─┐ ┌─ Payroll ─┐
    │     🕐       │ │   🏖️    │ │     👥      │ │    💰     │
    │   Tab 1      │ │  Tab 2  │ │   Tab 3     │ │   Tab 4   │
    └──────────────┘ └─────────┘ └─────────────┘ └───────────┘
```

#### 5. 🕐 Attendance Feature Flow

```
Attendance Tab (AttendanceMenuGrid)
    ↓
┌─ Quick Actions ─────────────────────┐
│ • Check In/Out                      │
│ • QR Code Scanner                   │
│ • Manual Attendance Entry           │
└─────────────────────────────────────┘
    ↓
┌─ Reports & Analytics ───────────────┐
│ • Daily Attendance                  │
│ • Weekly Summary                    │
│ • Monthly Reports                   │
│ • Yearly Analytics                  │
└─────────────────────────────────────┘
    ↓
Attendance Screen (AttendanceScreen)
    ↓
Tab Navigation (Daily/Weekly/Monthly/Yearly)
    ↓
┌─ Weekly View Example ───────────────┐
│                                     │
│ Week Selector ← → (Navigation)      │
│     ↓                               │
│ Weekly Summary Card                 │
│ • Total Hours: 42h 30m              │
│ • Attendance Rate: 5/5              │
│ • Average Hours: 8h 30m             │
│     ↓                               │
│ Weekly Attendance Cards             │
│ Monday   | 08:00 - 17:30 | 8h 30m   │
│ Tuesday  | 08:15 - 17:45 | 8h 30m   │
│ Wednesday| 08:00 - 17:30 | 8h 30m   │
│ Thursday | 08:10 - 17:40 | 8h 30m   │
│ Friday   | 08:00 - 17:30 | 8h 30m   │
└─────────────────────────────────────┘
```

**Attendance Data Flow:**
1. **Provider**: `AttendanceProvider.getAttendanceList()`
2. **Service**: `AttendanceService.getWeeklySummaryData()`
3. **Repository**: `AttendanceRepository.getAttendance()`
4. **UI Update**: Widgets rebuild with calculated data

#### 6. 🏖️ Leave Management Flow

```
Leave Tab (LeaveMenuGrid)
    ↓
┌─ Quick Actions ─────────────────────┐
│ • Request New Leave                 │
│ • View Leave Balance               │
│ • Check Leave History              │
└─────────────────────────────────────┘
    ↓
Leave Request Flow
    ↓
┌─ Leave Type Selection ──────────────┐
│ • Annual Leave                      │
│ • Sick Leave                        │
│ • Personal Leave                    │
│ • Emergency Leave                   │
└─────────────────────────────────────┘
    ↓
┌─ Date Range Selection ──────────────┐
│ Start Date: [Date Picker]           │
│ End Date: [Date Picker]             │
│ Duration: X days                    │
└─────────────────────────────────────┘
    ↓
┌─ Leave Details ─────────────────────┐
│ Reason: [Text Input]                │
│ Attachments: [File Upload]          │
│ Emergency Contact: [Optional]       │
└─────────────────────────────────────┘
    ↓
┌─ Review & Submit ───────────────────┐
│ • Validate leave balance            │
│ • Check approval workflow           │
│ • Submit request                    │
└─────────────────────────────────────┘
    ↓
┌─ Approval Workflow ─────────────────┐
│ Submitted → HR Review → Manager     │
│            Approval → Final Status  │
└─────────────────────────────────────┘
```

**Leave Request Components:**
- **Leave Type Selection**: Different leave categories with specific rules
- **Date Range Picker**: Calendar interface for selecting dates
- **Validation**: Automatic balance checking and conflict detection
- **Approval Workflow**: Multi-level approval system
- **Real-time Status**: Live updates on request status

#### 7. 📊 Data Synchronization Flow

```
UI Interaction
    ↓
Provider State Change
    ↓
Repository Call
    ↓
┌─ Mock Data ─┐    ┌─ Laravel API ─┐
│ Local JSON  │ OR │ HTTP Request  │
│ Files       │    │ with Auth     │
└─────────────┘    └───────────────┘
    ↓
Data Processing (Service Layer)
    ↓
State Update (notifyListeners)
    ↓
Widget Rebuild (Consumer)
    ↓
UI Update
```

### State Management Flow

**AsyncValue State Transitions:**
```
Initial State (null)
    ↓
Loading State (AsyncValueState.loading)
    ↓
┌─ Success ──────────┐    ┌─ Error ────────────┐
│ AsyncValueState.   │    │ AsyncValueState.   │
│ success            │    │ error              │
│ + data             │    │ + error message    │
└────────────────────┘    └────────────────────┘
```

**Real-time Updates:**
- Providers automatically notify listeners when data changes
- UI components rebuild only when their specific data changes
- Loading states provide immediate user feedback
- Error states show user-friendly messages

This flow ensures a smooth, responsive user experience with clear navigation paths and immediate feedback for all user actions.

## Key Features & Functionality

### 🔐 Authentication & Security
- **Secure Login**: Token-based authentication with session management
- **Biometric Support**: Fingerprint and Face ID authentication
- **Remember Me**: Option to save credentials securely
- **Auto-logout**: Automatic session timeout for security
- **Role-based Access**: Different permissions for users, HR, and supervisors

### 🏠 Dashboard & Home
- **Personal Dashboard**: Customized home screen with relevant information
- **Profile Card**: Real-time user status and information display
- **Attendance Overview**: Visual pie chart showing attendance summary
- **Quick Actions**: One-tap access to frequently used features
- **Real-time Updates**: Live data synchronization across all screens

### 🕐 Attendance Management
#### Check-in/Check-out System
- **QR Code Scanner**: Quick attendance marking via QR codes
- **GPS Verification**: Location-based attendance validation
- **Manual Entry**: Alternative check-in methods for flexibility
- **Time Tracking**: Precise time recording with automatic calculations

#### Attendance Analytics
- **Weekly Reports**: Detailed weekly attendance with hours breakdown
- **Monthly Analysis**: Comprehensive monthly attendance patterns
- **Yearly Overview**: Annual attendance trends and statistics
- **Custom Date Ranges**: Flexible reporting periods
- **Multiple Work Types**: Support for Normal, Overtime, and Part-time attendance

#### Advanced Calculations
- **Working Hours**: Automatic calculation of daily/weekly/monthly hours
- **Overtime Tracking**: Weekend and holiday overtime monitoring
- **Late/Early Detection**: Automatic status determination based on check-in times
- **Absence Management**: Smart absence detection and reporting
- **Attendance Rate**: Real-time attendance percentage calculations

### 🏖️ Leave Management
#### Leave Request System
- **Multiple Leave Types**: Annual, Sick, Personal, Emergency leave categories
- **Intuitive Date Selection**: User-friendly calendar interface
- **Leave Balance Checking**: Real-time balance validation
- **Conflict Detection**: Automatic overlap checking with existing requests
- **File Attachments**: Support for medical certificates and documents

#### Approval Workflow
- **Multi-level Approval**: Configurable approval chains (HR → Manager → Final)
- **Real-time Status**: Live updates on request progress
- **Push Notifications**: Instant alerts for status changes
- **Approval History**: Complete audit trail of approval decisions
- **Bulk Actions**: Efficient handling of multiple requests

#### Leave Analytics
- **Leave Overview**: Visual representation of leave usage
- **Balance Tracking**: Real-time leave balance monitoring
- **Usage Patterns**: Historical leave usage analysis
- **Team Calendar**: Team-wide leave visibility for managers

### 👥 Personnel Management
- **Staff Directory**: Comprehensive employee database
- **Team Structure**: Organizational hierarchy visualization
- **Role Management**: Position and responsibility tracking
- **Contact Information**: Easy access to colleague details
- **Search & Filter**: Advanced employee search capabilities

### 💰 Payroll & Financial Management
- **Salary Information**: Detailed pay slip viewing
- **Account Management**: Bank account and financial details
- **Withdrawal Tracking**: Transaction history and status
- **Commission Calculation**: Sales commission tracking and reporting
- **Financial Reports**: Comprehensive financial summaries

### 📊 Reports & Analytics
#### Comprehensive Reporting
- **Attendance Reports**: Daily, weekly, monthly, yearly attendance data
- **Leave Reports**: Leave usage and balance reports
- **Performance Metrics**: Individual and team performance indicators
- **Custom Reports**: Flexible report generation with date ranges
- **Export Options**: PDF generation and sharing capabilities

#### Data Visualization
- **Interactive Charts**: Beautiful charts using FL Chart library
- **Pie Charts**: Attendance distribution visualization
- **Bar Charts**: Comparative analysis across periods
- **Gauges**: Performance indicator displays
- **Trend Analysis**: Historical data pattern recognition

### 🔔 Notification System
- **Real-time Alerts**: Instant notifications for important events
- **Approval Notifications**: Updates on leave request status changes
- **Reminder Alerts**: Check-in/check-out reminders
- **System Notifications**: App updates and maintenance alerts
- **Customizable Settings**: User-controlled notification preferences

### 📱 Mobile-First Design
#### User Experience
- **Responsive Design**: Optimized for various screen sizes
- **Intuitive Navigation**: Easy-to-use bottom navigation
- **Modern UI**: Clean, professional interface design
- **Loading States**: Smooth loading animations and skeleton screens
- **Offline Support**: Graceful handling of network issues

#### Performance Features
- **Image Caching**: Efficient image loading and caching
- **Lazy Loading**: On-demand data loading for better performance
- **Memory Management**: Optimized memory usage
- **Battery Optimization**: Efficient battery usage patterns

### 🌐 Integration Capabilities
- **API Integration**: RESTful API communication with Laravel backend
- **Mock Data Support**: Development and testing with mock data
- **File Management**: Document upload and management
- **GPS Integration**: Location services for attendance verification
- **Camera Integration**: Photo capture for profile and documentation

### ⚙️ Configuration & Settings
- **App Preferences**: Customizable app behavior settings
- **Theme Configuration**: Light/dark mode support
- **Language Support**: Multi-language capability (including Khmer)
- **Privacy Settings**: User data and privacy controls
- **Developer Options**: Debug and development features

### 🔄 Data Management
#### State Management
- **Provider Pattern**: Reactive state management using Provider
- **AsyncValue Handling**: Robust loading, success, and error states
- **Real-time Sync**: Automatic data synchronization
- **Cache Management**: Intelligent data caching strategies

#### Data Sources
- **Repository Pattern**: Abstract data layer with multiple implementations
- **Mock Repositories**: Local JSON data for development
- **Laravel Repositories**: Production API integration
- **Factory Pattern**: Easy switching between data sources

This comprehensive feature set makes PALM HR a complete solution for modern HR management, providing both employees and administrators with powerful tools for efficient workforce management.

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.4 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd hr_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   # For mock data (development)
   # Set repositoryFactory.setUseMockRepositories(true) in main.dart
   
   # For Laravel backend (production)
   # Configure API endpoints in lib/data/Network/api_endpoints.dart
   # Set repositoryFactory.setUseMockRepositories(false) in main.dart
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Project Configuration

#### Repository Mode Selection
In `lib/main.dart`, configure the data source:

```dart
// Use mock repositories for development/testing
repositoryFactory.setUseMockRepositories(true);

// Use Laravel repositories for production
repositoryFactory.setUseMockRepositories(false);
```

#### API Configuration
Update API endpoints in `lib/data/Network/api_endpoints.dart`:

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-api-domain.com';
  static const String login = '$baseUrl/api/auth/login';
  static const String attendance = '$baseUrl/api/attendance';
  // ... other endpoints
}
```

### Development Workflow

1. **Feature Development**: Use mock repositories for rapid development
2. **Testing**: Comprehensive unit tests for business logic
3. **Integration**: Switch to Laravel repositories for backend integration
4. **Production**: Deploy with real API endpoints

### Build Configuration

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

### Assets & Resources

The app includes the following asset directories:
- `assets/icons/` - Application icons
- `assets/images/` - Images and graphics
- `assets/figma_icons/` - Figma exported icons
- `assets/figma_images/` - Figma exported images

---

## Technical Specifications

### Minimum Requirements
- **Android**: API level 21 (Android 5.0)
- **iOS**: iOS 11.0+
- **Flutter**: 3.2.4+
- **Dart**: 2.18.0+

### Performance Optimizations
- Lazy loading for large datasets
- Image caching and optimization
- Memory-efficient state management
- Battery usage optimization

### Security Features
- Token-based authentication
- Biometric authentication support
- Secure credential storage
- API request encryption

---

*Built with ❤️ using Flutter*
#   p a l m _ d e f e n s e _ h r  
 #   c a d t _ h r _ d e f e n s e  
 