<%@ page import="java.util.*, com.model.FeePayment" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View All Payments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 50px 0;
        }
        .table-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .badge-paid {
            background-color: #28a745;
        }
        .badge-overdue {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="table-container">
        <h2 class="text-center mb-4">
            <i class="fas fa-list"></i> All Payment Records
        </h2>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Payment ID</th>
                        <th>Student ID</th>
                        <th>Student Name</th>
                        <th>Payment Date</th>
                        <th>Amount (₹)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<FeePayment> payments = (List<FeePayment>) request.getAttribute("payments");
                        
                        // Debug print
                        System.out.println("JSP - Payments list: " + payments);
                        
                        if(payments != null && !payments.isEmpty()) {
                            int count = 0;
                            for(FeePayment p : payments) {
                                count++;
                    %>
                        <tr>
                            <td><%= p.getPaymentId() %></td>
                            <td><%= p.getStudentId() %></td>
                            <td><%= p.getStudentName() != null ? p.getStudentName() : "" %></td>
                            <td><%= p.getPaymentDate() != null ? p.getPaymentDate() : "" %></td>
                            <td>₹<%= String.format("%,.2f", p.getAmount()) %></td>
                            <td>
                                <span class="badge <%= "Paid".equals(p.getStatus()) ? "bg-success" : "bg-danger" %>">
                                    <%= p.getStatus() != null ? p.getStatus() : "" %>
                                </span>
                            </td>
                        </tr>
                    <%      }
                        } else { %>
                        <tr>
                            <td colspan="6" class="text-center">
                                <i class="fas fa-inbox fa-2x text-muted mb-2 d-block"></i>
                                <strong>No payment records found</strong><br>
                                <small class="text-muted">Click "Add New Payment" to add records</small>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <div class="text-center mt-3">
            <a href="index.jsp" class="btn btn-secondary">
                <i class="fas fa-home"></i> Back to Home
            </a>
            <a href="feepaymentadd.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add New Payment
            </a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>