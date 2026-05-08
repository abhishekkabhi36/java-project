<%@ page import="java.util.*, com.dao.FeePaymentDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Generator - College Fee System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 50px 0;
        }
        .report-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 900px;
            margin: auto;
        }
        .report-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .report-header h2 {
            margin: 0;
            font-weight: bold;
        }
        .report-body {
            padding: 30px;
        }
        .report-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            transition: all 0.3s;
            cursor: pointer;
            border: 2px solid transparent;
        }
        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        .report-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        .date-range-form {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }
        .btn-generate {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            padding: 10px 30px;
            font-weight: bold;
        }
        .stat-box {
            background: linear-gradient(135deg, #667eea15, #764ba215);
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<%
    FeePaymentDAO dao = new FeePaymentDAO();
    int overdueCount = dao.getOverduePayments().size();
    int paidCount = dao.getPaidPayments().size();
    int totalCount = dao.getAllPayments().size();
%>
<div class="container">
    <div class="report-container">
        <div class="report-header">
            <i class="fas fa-chart-line fa-3x mb-3"></i>
            <h2>Fee Payment Reports</h2>
            <p class="mb-0">Generate various reports for fee analysis</p>
        </div>
        
        <div class="report-body">
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <!-- Statistics Summary -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stat-box">
                        <i class="fas fa-receipt fa-2x mb-2"></i>
                        <h3><%= totalCount %></h3>
                        <p class="mb-0">Total Payments</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box">
                        <i class="fas fa-check-circle fa-2x mb-2 text-success"></i>
                        <h3><%= paidCount %></h3>
                        <p class="mb-0">Paid Payments</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box">
                        <i class="fas fa-exclamation-triangle fa-2x mb-2 text-danger"></i>
                        <h3><%= overdueCount %></h3>
                        <p class="mb-0">Overdue Payments</p>
                    </div>
                </div>
            </div>
            
            <!-- Report Type 1: Overdue Payments -->
            <div class="report-card" onclick="generateReport('overdue')">
                <div class="row align-items-center">
                    <div class="col-md-2 text-center">
                        <div class="report-icon text-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <div class="col-md-10">
                        <h4>Overdue Payments Report</h4>
                        <p class="text-muted mb-0">View all students with overdue fee payments. Shows payment details, student information, and overdue amounts.</p>
                    </div>
                </div>
                <form id="formOverdue" action="reportCriteria" method="post" style="display:none;">
                    <input type="hidden" name="reportType" value="overdue">
                </form>
            </div>
            
            <!-- Report Type 2: Paid Payments -->
            <div class="report-card" onclick="generateReport('paid')">
                <div class="row align-items-center">
                    <div class="col-md-2 text-center">
                        <div class="report-icon text-success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="col-md-10">
                        <h4>Paid Payments Report</h4>
                        <p class="text-muted mb-0">View all successfully completed payments. Track collection history and payment patterns.</p>
                    </div>
                </div>
                <form id="formPaid" action="reportCriteria" method="post" style="display:none;">
                    <input type="hidden" name="reportType" value="paid">
                </form>
            </div>
            
            <!-- Report Type 3: Date Range Report -->
            <div class="report-card" onclick="toggleDateRange()">
                <div class="row align-items-center">
                    <div class="col-md-2 text-center">
                        <div class="report-icon text-primary">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                    </div>
                    <div class="col-md-10">
                        <h4>Date Range Report</h4>
                        <p class="text-muted mb-0">Generate collection report for specific date range with total collection summary.</p>
                    </div>
                </div>
            </div>
            
            <!-- Date Range Form -->
            <div id="dateRangeForm" class="date-range-form">
                <form action="reportCriteria" method="post" onsubmit="return validateDates()">
                    <input type="hidden" name="reportType" value="dateRange">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="form-label">
                                <i class="fas fa-calendar-start"></i> Start Date
                            </label>
                            <input type="date" name="startDate" id="startDate" class="form-control" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">
                                <i class="fas fa-calendar-end"></i> End Date
                            </label>
                            <input type="date" name="endDate" id="endDate" class="form-control" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary btn-generate w-100">
                                <i class="fas fa-download"></i> Generate
                            </button>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-12">
                            <small class="text-muted">
                                <i class="fas fa-info-circle"></i> 
                                This report will show all payments between selected dates and total collection amount.
                            </small>
                        </div>
                    </div>
                </form>
            </div>
            
            <!-- Instructions -->
            <div class="alert alert-info mt-4">
                <i class="fas fa-info-circle me-2"></i>
                <strong>How to use:</strong> Click on any report card to generate the report. For date range report, select start and end dates.
            </div>
        </div>
    </div>
</div>

<script>
    function generateReport(type) {
        if(type === 'overdue') {
            document.getElementById('formOverdue').submit();
        } else if(type === 'paid') {
            document.getElementById('formPaid').submit();
        }
    }
    
    function toggleDateRange() {
        var div = document.getElementById('dateRangeForm');
        if(div.style.display === 'none' || div.style.display === '') {
            div.style.display = 'block';
        } else {
            div.style.display = 'none';
        }
    }
    
    function validateDates() {
        var startDate = document.getElementById('startDate').value;
        var endDate = document.getElementById('endDate').value;
        
        if(!startDate || !endDate) {
            alert('Please select both start date and end date');
            return false;
        }
        
        if(startDate > endDate) {
            alert('Start date cannot be after end date');
            return false;
        }
        
        return true;
    }
    
    // Set default dates (current month)
    var today = new Date();
    var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
    
    function formatDate(date) {
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }
    
    document.getElementById('startDate').value = formatDate(firstDay);
    document.getElementById('endDate').value = formatDate(today);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>