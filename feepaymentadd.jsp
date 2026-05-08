<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Fee Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 50px 0;
        }
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            max-width: 600px;
            margin: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .readonly-field {
            background-color: #e9ecef;
            cursor: not-allowed;
            font-weight: bold;
            font-size: 18px;
        }
        .next-number {
            font-size: 20px;
            font-weight: bold;
            color: #28a745;
        }
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<%
    Integer nextPaymentId = (Integer) request.getAttribute("nextPaymentId");
    Integer nextStudentId = (Integer) request.getAttribute("nextStudentId");
    String currentDate = (String) request.getAttribute("currentDate");
    
    // Debug output
    System.out.println("JSP - Next Payment ID: " + nextPaymentId);
    System.out.println("JSP - Next Student ID: " + nextStudentId);
    
    if(nextPaymentId == null) nextPaymentId = 1;
    if(nextStudentId == null) nextStudentId = 1001;
    if(currentDate == null) currentDate = LocalDate.now().toString();
%>
<div class="container">
    <div class="form-container">
        <h2 class="text-center mb-4">
            <i class="fas fa-plus-circle text-success"></i> Add Fee Payment
        </h2>
        
        <% if(request.getAttribute("message") != null) { %>
            <div class="alert alert-<%= request.getAttribute("messageType") %>">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>
        
        <% if(request.getAttribute("savedPayment") != null) { 
            com.model.FeePayment p = (com.model.FeePayment) request.getAttribute("savedPayment"); %>
            <div class="alert alert-success">
                <strong>✓ Payment Added Successfully!</strong><br>
                Payment ID: <strong><%= p.getPaymentId() %></strong><br>
                Student ID: <strong><%= p.getStudentId() %></strong><br>
                Student: <%= p.getStudentName() %>
            </div>
        <% } %>
        
        <div class="info-box">
            <i class="fas fa-database me-2"></i>
            <strong>Next Sequential Numbers (Based on MAX ID in Database):</strong><br>
            ➤ Next Payment ID: <span class="next-number"><%= nextPaymentId %></span><br>
            ➤ Next Student ID: <span class="next-number"><%= nextStudentId %></span>
        </div>
        
        <form action="addFeePayment" method="post">
            <div class="mb-3">
                <label><i class="fas fa-id-card"></i> Payment ID</label>
                <input type="text" class="form-control readonly-field" 
                       value="<%= nextPaymentId %>" readonly disabled>
                <small class="text-muted">Next sequential number (MAX PaymentID + 1)</small>
            </div>
            
            <div class="mb-3">
                <label><i class="fas fa-id-badge"></i> Student ID</label>
                <input type="text" class="form-control readonly-field" 
                       value="<%= nextStudentId %>" readonly disabled>
                <input type="hidden" name="studentId" value="<%= nextStudentId %>">
                <small class="text-muted">Next sequential number (MAX StudentID + 1)</small>
            </div>
            
            <div class="mb-3">
                <label><i class="fas fa-user"></i> Student Name *</label>
                <input type="text" class="form-control" name="studentName" required>
            </div>
            
            <div class="mb-3">
                <label><i class="fas fa-calendar"></i> Payment Date</label>
                <input type="text" class="form-control readonly-field" 
                       value="<%= currentDate %>" readonly disabled>
                <input type="hidden" name="paymentDate" value="<%= currentDate %>">
                <small class="text-muted">Current date auto-set</small>
            </div>
            
            <div class="mb-3">
                <label><i class="fas fa-rupee-sign"></i> Amount *</label>
                <input type="number" step="0.01" class="form-control" name="amount" required>
            </div>
            
            <div class="mb-3">
                <label><i class="fas fa-tag"></i> Status</label>
                <select class="form-select" name="status">
                    <option value="Paid">Paid</option>
                    <option value="Overdue">Overdue</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-save"></i> Save Payment
            </button>
        </form>
    </div>
</div>
</body>
</html>