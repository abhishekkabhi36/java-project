<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 50px 0;
        }
        .report-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            max-width: 800px;
            margin: auto;
        }
        .report-card {
            background: linear-gradient(135deg, #667eea15, #764ba215);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .date-range {
            display: none;
            margin-top: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="report-container">
        <h2 class="text-center mb-4">
            <i class="fas fa-chart-bar"></i> Payment Reports
        </h2>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <!-- Overdue Report -->
        <div class="report-card" onclick="submitReport('overdue')">
            <div class="row">
                <div class="col-2 text-center">
                    <i class="fas fa-exclamation-triangle fa-3x text-danger"></i>
                </div>
                <div class="col-10">
                    <h5>Overdue Payments</h5>
                    <p class="text-muted">View all payments that are overdue</p>
                </div>
            </div>
            <form id="formOverdue" action="report" method="post">
                <input type="hidden" name="reportType" value="overdue">
            </form>
        </div>
        
        <!-- Paid Report -->
        <div class="report-card" onclick="submitReport('paid')">
            <div class="row">
                <div class="col-2 text-center">
                    <i class="fas fa-check-circle fa-3x text-success"></i>
                </div>
                <div class="col-10">
                    <h5>Paid Payments</h5>
                    <p class="text-muted">View all successfully paid payments</p>
                </div>
            </div>
            <form id="formPaid" action="report" method="post">
                <input type="hidden" name="reportType" value="paid">
            </form>
        </div>
        
        <!-- Date Range Report -->
        <div class="report-card" onclick="toggleDateRange()">
            <div class="row">
                <div class="col-2 text-center">
                    <i class="fas fa-calendar-alt fa-3x text-primary"></i>
                </div>
                <div class="col-10">
                    <h5>Date Range Report</h5>
                    <p class="text-muted">View payments between specific dates</p>
                </div>
            </div>
        </div>
        
        <div id="dateRangeForm" class="date-range">
            <form action="report" method="post">
                <input type="hidden" name="reportType" value="dateRange">
                <div class="row">
                    <div class="col-md-5">
                        <label>Start Date</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="col-md-5">
                        <label>End Date</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                    <div class="col-md-2">
                        <label>&nbsp;</label>
                        <button type="submit" class="btn btn-primary w-100">Generate</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    function submitReport(type) {
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
    
    // Set default dates
    var today = new Date();
    var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
    document.querySelector('input[name="startDate"]').valueAsDate = firstDay;
    document.querySelector('input[name="endDate"]').valueAsDate = today;
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>