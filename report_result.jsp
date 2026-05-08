<%@ page import="java.util.*, java.math.BigDecimal, com.model.FeePayment" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Result - College Fee System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 50px 0;
        }
        .result-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 30px;
            max-width: 1200px;
            margin: auto;
        }
        .report-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        .summary-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }
        .badge-paid {
            background-color: #28a745;
        }
        .badge-overdue {
            background-color: #dc3545;
        }
        .btn-print {
            background: #6c757d;
            color: white;
            border: none;
        }
        .btn-back {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
        }
        @media print {
            body {
                background: white;
                padding: 0;
            }
            .no-print {
                display: none;
            }
            .result-container {
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="result-container">
        <div class="report-header">
            <h2 class="text-center mb-2">
                <i class="fas fa-chart-line me-2"></i>
                <%= request.getAttribute("reportTitle") %>
            </h2>
            <p class="text-center mb-0">
                <i class="fas fa-calendar-alt me-2"></i>
                Generated on: <%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new java.util.Date()) %>
            </p>
        </div>
        
        <!-- Summary Statistics -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="summary-card">
                    <h6 class="text-muted">Total Records</h6>
                    <h3><%= request.getAttribute("recordCount") != null ? request.getAttribute("recordCount") : "0" %></h3>
                </div>
            </div>
            
            <% if(request.getAttribute("totalAmount") != null) { %>
                <div class="col-md-4">
                    <div class="summary-card">
                        <h6 class="text-muted">Total Amount</h6>
                        <h3 class="text-success">₹<%= String.format("%,.2f", ((BigDecimal)request.getAttribute("totalAmount"))) %></h3>
                    </div>
                </div>
            <% } %>
            
            <% if(request.getAttribute("totalCollection") != null) { %>
                <div class="col-md-4">
                    <div class="summary-card">
                        <h6 class="text-muted">Total Collection</h6>
                        <h3 class="text-success">₹<%= String.format("%,.2f", ((BigDecimal)request.getAttribute("totalCollection"))) %></h3>
                    </div>
                </div>
            <% } %>
            
            <% if(request.getAttribute("startDate") != null) { %>
                <div class="col-md-4">
                    <div class="summary-card">
                        <h6 class="text-muted">Date Range</h6>
                        <h6><%= request.getAttribute("startDate") %> to <%= request.getAttribute("endDate") %></h6>
                    </div>
                </div>
            <% } %>
        </div>
        
        <!-- Data Table -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover" id="dataTable">
                <thead class="table-dark">
                    <tr>
                        <th>Payment ID</th>
                        <th>Student ID</th>
                        <th>Student Name</th>
                        <th>Payment Date</th>
                        <% if(request.getAttribute("showAmount") != null && (Boolean)request.getAttribute("showAmount")) { %>
                            <th>Amount (₹)</th>
                        <% } %>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<FeePayment> reportData = (List<FeePayment>) request.getAttribute("reportData");
                        if(reportData != null && !reportData.isEmpty()) {
                            for(FeePayment payment : reportData) {
                    %>
                        <tr>
                            <td><%= payment.getPaymentId() %></td>
                            <td><%= payment.getStudentId() %></td>
                            <td><%= payment.getStudentName() %></td>
                            <td><%= payment.getPaymentDate() %></td>
                            <% if(request.getAttribute("showAmount") != null && (Boolean)request.getAttribute("showAmount")) { %>
                                <td class="text-end">₹<%= String.format("%,.2f", payment.getAmount()) %></td>
                            <% } %>
                            <td>
                                <span class="badge <%= payment.getStatus().equals("Paid") ? "bg-success" : "bg-danger" %>">
                                    <%= payment.getStatus() %>
                                </span>
                            </td>
                        </tr>
                    <%      }
                        } else { %>
                        <tr>
                            <td colspan="<%= (request.getAttribute("showAmount") != null && (Boolean)request.getAttribute("showAmount")) ? 6 : 5 %>" 
                                class="text-center py-4">
                                <i class="fas fa-inbox fa-2x text-muted mb-2 d-block"></i>
                                No records found
                            </td>
                        </tr>
                    <% } %>
                </tbody>
                <% if(reportData != null && !reportData.isEmpty() && request.getAttribute("totalCollection") != null) { %>
                    <tfoot class="table-secondary">
                        <tr>
                            <th colspan="4" class="text-end">Total Collection:</th>
                            <th class="text-end">₹<%= String.format("%,.2f", (BigDecimal)request.getAttribute("totalCollection")) %></th>
                            <th></th>
                        </tr>
                    </tfoot>
                <% } %>
            </table>
        </div>
        
        <!-- Action Buttons -->
        <div class="text-center mt-4 no-print">
            <button onclick="window.print()" class="btn btn-print me-2">
                <i class="fas fa-print me-2"></i>Print Report
            </button>
            <button onclick="window.location.href='report_form.jsp'" class="btn btn-back">
                <i class="fas fa-arrow-left me-2"></i>Back to Reports
            </button>
        </div>
    </div>
</div>

<script>
    // Add print functionality
    function printReport() {
        window.print();
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>