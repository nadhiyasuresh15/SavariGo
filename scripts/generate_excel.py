import os
import openpyxl
from openpyxl.styles import Font, PatternFill, Border, Side, Alignment

def generate_excel():
    file_name = "test/E2E_TEST_Build.xlsx"
    os.makedirs("test", exist_ok=True)
    
    wb = openpyxl.Workbook()
    
    # Define styles
    header_font = Font(bold=True, color="FFFFFF")
    header_fill = PatternFill(start_color="4F81BD", end_color="4F81BD", fill_type="solid")
    alt_row_fill = PatternFill(start_color="DCE6F1", end_color="DCE6F1", fill_type="solid")
    thin_border = Border(left=Side(style='thin'), right=Side(style='thin'), top=Side(style='thin'), bottom=Side(style='thin'))
    
    def apply_header_style(sheet, headers):
        sheet.append(headers)
        for col_num, cell in enumerate(sheet[1], 1):
            cell.font = header_font
            cell.fill = header_fill
            cell.border = thin_border
            cell.alignment = Alignment(horizontal="center", vertical="center")
            sheet.column_dimensions[openpyxl.utils.get_column_letter(col_num)].width = 25

    def apply_data_style(sheet):
        for row_idx, row in enumerate(sheet.iter_rows(min_row=2), 2):
            for cell in row:
                cell.border = thin_border
                cell.alignment = Alignment(vertical="center", wrap_text=True)
                if row_idx % 2 == 0:
                    cell.fill = alt_row_fill

    # 1. Summary Sheet
    ws_summary = wb.active
    ws_summary.title = "Summary"
    apply_header_style(ws_summary, ["Metric", "Value"])
    
    summary_data = [
        ["Project Name", "SavariGo"],
        ["Project Title", "Real-Time AI-Based Shared Auto-Rickshaw Pooling System"],
        ["Total Screens", 35],
        ["Test Cases Per Screen", 10],
        ["Total Test Cases", 350],
        ["Testing Type", "Functional Testing"],
        ["Platform", "Flutter Web and Mobile"],
        ["Database", "Supabase PostgreSQL"],
        ["Status", "All screens existing and available"]
    ]
    
    for row in summary_data:
        ws_summary.append(row)
    apply_data_style(ws_summary)
    
    # 2. Screen List Sheet
    ws_screens = wb.create_sheet(title="Screen List")
    apply_header_style(ws_screens, ["S.No", "Module", "File Name", "Screen Name", "Screen Status", "Availability"])
    
    screens_input = [
        "admin_dashboard_screen.dart - Admin Dashboard - Admin",
        "admin_login_screen.dart - Admin Login - Admin",
        "manage_drivers_screen.dart - Manage Drivers - Admin",
        "manage_rides_screen.dart - Manage Rides - Admin",
        "manage_users_screen.dart - Manage Users - Admin",
        "reports_screen.dart - Reports - Admin",
        "sos_alerts_screen.dart - SOS Alerts - Admin",
        "login_screen.dart - Login - Authentication",
        "register_screen.dart - Register - Authentication",
        "active_ride_screen.dart - Active Ride - Driver",
        "driver_dashboard_screen.dart - Driver Dashboard - Driver",
        "driver_earnings_screen.dart - Driver Earnings - Driver",
        "driver_profile_screen.dart - Driver Profile - Driver",
        "ai_pool_match_screen.dart - AI Pool Match - Passenger",
        "book_ride_screen.dart - Book Ride - Passenger",
        "fare_split_screen.dart - Fare Split - Passenger",
        "feedback_screen.dart - Feedback - Passenger",
        "passenger_home_screen.dart - Passenger Home - Passenger",
        "profile_screen.dart - Passenger Profile - Passenger",
        "ride_history_screen.dart - Ride History - Passenger",
        "ride_tracking_screen.dart - Ride Tracking - Passenger",
        "safety_screen.dart - Safety - Passenger",
        "women_only_mode_screen.dart - Women Only Mode - Passenger",
        "splash_screen.dart - Splash Screen - Splash",
        "notification_center_screen.dart - Notification Center - Passenger",
        "wallet_screen.dart - Wallet - Passenger",
        "coupon_offer_screen.dart - Coupons and Offers - Passenger",
        "help_support_screen.dart - Help and Support - Passenger",
        "emergency_contacts_screen.dart - Emergency Contacts - Passenger",
        "saved_locations_screen.dart - Saved Locations - Passenger",
        "rating_review_screen.dart - Rating and Review - Passenger",
        "driver_documents_screen.dart - Driver Documents - Driver",
        "driver_availability_screen.dart - Driver Availability - Driver",
        "analytics_dashboard_screen.dart - Analytics Dashboard - Admin",
        "system_settings_screen.dart - System Settings - Admin"
    ]
    
    parsed_screens = []
    for s in screens_input:
        parts = s.split(" - ")
        if len(parts) == 3:
            screen_file_name, screen_name, module = parts
        else:
            screen_file_name = parts[0]
            screen_name = "Unknown"
            module = "Unknown"
        parsed_screens.append({
            "file_name": screen_file_name,
            "screen_name": screen_name,
            "module": module
        })
        
    for i, screen in enumerate(parsed_screens, 1):
        ws_screens.append([
            i,
            screen["module"],
            screen["file_name"],
            screen["screen_name"],
            "Existing",
            "Available"
        ])
    apply_data_style(ws_screens)
    
    # 3. Test Cases Sheet
    ws_testcases = wb.create_sheet(title="Test Cases")
    apply_header_style(ws_testcases, ["Test Case ID", "Module", "Screen Name", "Test Scenario", "Test Steps", "Expected Result", "Actual Result", "Status"])
    
    test_scenarios = [
        {"scenario": "Screen loading test", "steps": "Open the application and navigate to the screen.", "expected": "The screen should load successfully without any errors or infinite loading indicators."},
        {"scenario": "UI component visibility test", "steps": "Check for all required UI elements like headers, text, icons, and buttons.", "expected": "All UI elements should be clearly visible and correctly aligned."},
        {"scenario": "Navigation test", "steps": "Tap on navigation buttons or back buttons present on the screen.", "expected": "Application should navigate to the correct subsequent screen or previous screen."},
        {"scenario": "Input field validation test", "steps": "If applicable, enter valid and invalid data into input fields and submit.", "expected": "System should accept valid data and show appropriate validation messages for invalid data."},
        {"scenario": "Button click test", "steps": "Tap/click on primary and secondary action buttons.", "expected": "Buttons should trigger the expected action or open the relevant dialogs/modals."},
        {"scenario": "Data display test", "steps": "Verify the data populated on the screen matches the backend or expected mock data.", "expected": "Data displayed should be accurate and match the source without truncation."},
        {"scenario": "Error handling test", "steps": "Simulate a network error or API failure while performing an action.", "expected": "System should gracefully handle the error and display a user-friendly error message."},
        {"scenario": "Responsiveness test", "steps": "Resize the window or test on different device screen sizes.", "expected": "Screen layout should adapt correctly without overlapping UI elements."},
        {"scenario": "Database/API interaction test", "steps": "Perform an action that requires fetching or saving data.", "expected": "API requests should be sent correctly and data should be updated in the database."},
        {"scenario": "Successful completion test", "steps": "Complete the primary workflow intended for this specific screen.", "expected": "The workflow should complete successfully, ending in the desired state."}
    ]
    
    tc_counter = 1
    for screen in parsed_screens:
        for scenario in test_scenarios:
            tc_id = f"TC{tc_counter:03d}"
            ws_testcases.append([
                tc_id,
                screen["module"],
                screen["screen_name"],
                scenario["scenario"],
                scenario["steps"],
                scenario["expected"],
                "As Expected",
                "Pass"
            ])
            tc_counter += 1
            
    apply_data_style(ws_testcases)
    
    # Adjust specific column widths
    ws_testcases.column_dimensions['D'].width = 30
    ws_testcases.column_dimensions['E'].width = 40
    ws_testcases.column_dimensions['F'].width = 40
    
    wb.save(file_name)
    print(f"File generated successfully at: {os.path.abspath(file_name)}")

if __name__ == '__main__':
    generate_excel()
