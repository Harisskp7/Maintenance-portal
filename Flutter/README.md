# Maintenance Portal - Flutter Frontend

A modern Flutter application for maintenance department employees to view notifications and work orders.

## Features

- **Modern Login Interface**: Beautiful login screen with validation
- **Dashboard with Tabs**: Separate tabs for Notifications and Work Orders
- **Plant Selection**: Choose different plants to view data
- **Real-time Data**: Fetches data from your backend API
- **Responsive Design**: Works on mobile and desktop
- **Pull to Refresh**: Refresh data by pulling down
- **Detailed Views**: Tap on items to see full details

## Backend Integration

This Flutter app connects to your Node.js backend running on port 5000:

- **Login API**: `POST /api/maint/login`
- **Notifications API**: `GET /api/maint/notisfy/{plantId}`
- **Work Orders API**: `GET /api/maint/work/{plantId}`
- **Plants API**: `GET /api/maint/plant`

## Getting Started

### Prerequisites

1. Make sure your backend server is running on `http://localhost:5000`
2. Install Flutter SDK
3. Install dependencies

### Installation

1. Navigate to the Flutter directory:
   ```bash
   cd Flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

### For Web Development

To run on web (recommended for development):

```bash
flutter run -d chrome
```

### For Mobile Development

To run on connected device or emulator:

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── notification.dart
│   └── work_order.dart
├── screens/                  # UI screens
│   ├── login_screen.dart
│   └── dashboard_screen.dart
├── services/                 # API services
│   └── api_service.dart
└── widgets/                  # Reusable widgets
    ├── notification_card.dart
    └── work_order_card.dart
```

## API Endpoints

The app expects these endpoints from your backend:

### Login
- **URL**: `POST /api/maint/login`
- **Body**: `{"EMPLOYEE_ID": "string", "PASSWORD": "string"}`
- **Response**: `{"success": true, "employee_id": "string", "MESSAGE": "string"}`

### Notifications
- **URL**: `GET /api/maint/notisfy/{plantId}`
- **Response**: `{"success": true, "data": [...]}`

### Work Orders
- **URL**: `GET /api/maint/work/{plantId}`
- **Response**: `{"success": true, "data": [...]}`

## Features

### Login Screen
- Employee ID and password validation
- Modern UI with gradient background
- Error handling and loading states
- Form validation

### Dashboard
- Tabbed interface for Notifications and Work Orders
- Plant selection dropdown
- Pull-to-refresh functionality
- Loading states and error handling
- Detailed view dialogs

### Notifications
- Priority-based color coding (High/Medium/Low)
- Status badges
- Equipment and plant information
- Tap to view details

### Work Orders
- Work order type badges
- Plant and company code information
- Cost center details
- Tap to view details

## Troubleshooting

### Common Issues

1. **Connection Error**: Make sure your backend is running on port 5000
2. **CORS Issues**: Ensure your backend has CORS enabled
3. **Data Not Loading**: Check the network tab for API errors

### Debug Mode

Run with debug information:
```bash
flutter run --debug
```

## Development Notes

- The app uses Material Design 3
- All API calls are handled through the `ApiService` class
- Error handling is implemented throughout the app
- The UI is responsive and works on different screen sizes
- Data is fetched asynchronously with loading indicators

## Backend Requirements

Your backend should:
1. Run on port 5000
2. Have CORS enabled
3. Return JSON responses
4. Handle the specified API endpoints
5. Return data in the expected format

The Flutter app is now ready to connect to your maintenance portal backend!
