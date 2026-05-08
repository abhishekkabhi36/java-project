<%@ page import="java.util.*, com.model.FeePayment" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Fee Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 50px 0;
        }
        .container-box {
            background: white;
            border-radius: 20px;
            padding: 30px;
            max-width: 800px;
            margin: auto;
        }
        .payment-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .payment-card:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }
        .readonly-field {
            background-color: #e9ecef;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="container-box">
        <h2 class="text-center mb-4">
            <i class="fas fa-edit text-warning"></i> Update Payment
        </h2>
        
        <% if(request.getAttribute("message") != null) { %>
            <div class="alert alert-<%= request.getAttribute("messageType") %>">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>
        
        <!-- Search Form -->
        <form method="post" action="updateFeePayment">
            <input type="hidden" name="action" value="search">
            <div class="row">
                <div class="col-md-8">
                    <label><i class="fas fa-search"></i> Enter Student ID</label>
                    <input type="number" class="form-control" name="studentId" 
                           value="<%= request.getAttribute("searchedId") != null ? request.getAttribute("searchedId") : "" %>" required>
                </div>
                <div class="col-md-4">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">Search</button>
                </div>
            </div>
        </form>
        
        <!-- Display Payments -->
        <% if(request.getAttribute("payments") != null) { 
            List<FeePayment> payments = (List<FeePayment>) request.getAttribute("payments"); %>
            <div class="mt-4">
                <h5>Payment Records Found:</h5>
                <% for(FeePayment p : payments) { %>
                    <div class="payment-card" onclick="editPayment(<%= p.getPaymentId() %>)">
                        <div class="row">
                            <div class="col-md-3"><strong>Payment ID:</strong> <%= p.getPaymentId() %></div>
                            <div class="col-md-3"><strong>Student ID:</strong> <%= p.getStudentId() %></div>
                            <div class="col-md-3"><strong>Amount:</strong> ₹<%= p.getAmount() %></div>
                            <div class="col-md-3"><strong>Status:</strong> <%= p.getStatus() %></div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-6"><strong>Student:</strong> <%= p.getStudentName() %></div>
                            <div class="col-md-6"><strong>Date:</strong> <%= p.getPaymentDate() %></div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Edit Form -->
        <% if(request.getAttribute("editPayment") != null) { 
            FeePayment p = (FeePayment) request.getAttribute("editPayment"); %>
            <div class="mt-4 p-3 bg-light rounded">
                <h5>Edit Payment Details</h5>
                <form method="post" action="updateFeePayment">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>">
                    
                    <div class="mb-3">
                        <label>Payment ID</label>
                        <input type="text" class="form-control readonly-field" value="<%= p.getPaymentId() %>" readonly disabled>
                    </div>
                    
                    <div class="mb-3">
                        <label>Student ID</label>
                        <input type="text" class="form-control readonly-field" value="<%= p.getStudentId() %>" readonly disabled>
                    </div>
                    
                    <div class="mb-3">
                        <label>Student Name</label>
                        <input type="text" class="form-control" name="studentName" value="<%= p.getStudentName() %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label>Payment Date</label>
                        <input type="date" class="form-control" name="paymentDate" value="<%= p.getPaymentDate() %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label>Amount</label>
                        <input type="number" step="0.01" class="form-control" name="amount" value="<%= p.getAmount() %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label>Status</label>
                        <select class="form-select" name="status">
                            <option value="Paid" <%= p.getStatus().equals("Paid") ? "selected" : "" %>>Paid</option>
                            <option value="Overdue" <%= p.getStatus().equals("Overdue") ? "selected" : "" %>>Overdue</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-warning w-100">Update Payment</button>
                </form>
            </div>
        <% } %>
    </div>
</div>
<script>
    function editPayment(paymentId) {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = 'updateFeePayment';
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'edit';
        var idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'paymentId';
        idInput.value = paymentId;
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>