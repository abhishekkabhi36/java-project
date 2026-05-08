<%@ page import="java.util.*, com.model.FeePayment" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Fee Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 50px 0;
            min-height: 100vh;
        }
        .container-box {
            background: white;
            border-radius: 20px;
            padding: 30px;
            max-width: 900px;
            margin: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .payment-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            border-left: 4px solid #dc3545;
            transition: all 0.3s;
        }
        .payment-card:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            color: #856404;
        }
        .btn-delete {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
        }
        .btn-delete:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(220,53,69,0.4);
        }
        .student-info {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }
        .delete-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="container-box">
        <h2 class="text-center mb-4">
            <i class="fas fa-trash-alt text-danger"></i> Delete Payment
        </h2>
        <p class="text-center text-muted mb-4">Enter Student ID to view and delete payment records</p>
        
        <!-- Success/Error Messages -->
        <% if(request.getAttribute("message") != null) { %>
            <div class="alert alert-<%= request.getAttribute("messageType") %> alert-dismissible fade show">
                <i class="fas fa-<%= request.getAttribute("messageType").equals("success") ? "check-circle" : "exclamation-circle" %> me-2"></i>
                <%= request.getAttribute("message") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Search Form - Search by Student ID -->
        <form method="post" action="deleteFeePayment" class="mb-4">
            <input type="hidden" name="action" value="search">
            <div class="row g-3">
                <div class="col-md-8">
                    <label class="form-label">
                        <i class="fas fa-id-badge me-2"></i>Enter Student ID
                    </label>
                    <input type="number" class="form-control" name="studentId" 
                           placeholder="Enter Student ID (e.g., 1000, 1001, etc.)" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">&nbsp;</label>
                    <button type="submit" class="btn btn-danger w-100">
                        <i class="fas fa-search me-2"></i>Search Payments
                    </button>
                </div>
            </div>
        </form>
        
        <!-- Display Payment Records for the Student -->
        <% if(request.getAttribute("payments") != null) { 
            List<FeePayment> payments = (List<FeePayment>) request.getAttribute("payments");
            Integer studentId = (Integer) request.getAttribute("studentId");
        %>
            <div class="student-info">
                <i class="fas fa-info-circle me-2"></i>
                <strong>Student ID: <%= studentId %></strong> - 
                Found <strong><%= payments.size() %></strong> payment record(s)
            </div>
            
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Select</th>
                            <th>Payment ID</th>
                            <th>Student Name</th>
                            <th>Payment Date</th>
                            <th>Amount (₹)</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(FeePayment payment : payments) { %>
                            <tr>
                                <td class="text-center">
                                    <input type="radio" name="selectedPayment" value="<%= payment.getPaymentId() %>" 
                                           class="payment-select" onclick="selectPayment(<%= payment.getPaymentId() %>)">
                                </td>
                                <td><%= payment.getPaymentId() %></td>
                                <td><%= payment.getStudentName() %></td>
                                <td><%= payment.getPaymentDate() %></td>
                                <td>₹<%= String.format("%,.2f", payment.getAmount()) %></td>
                                <td>
                                    <span class="badge <%= payment.getStatus().equals("Paid") ? "bg-success" : "bg-danger" %>">
                                        <%= payment.getStatus() %>
                                    </span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Delete Form - Shows after selecting a payment -->
            <div id="deleteSection" class="delete-form" style="display: none;">
                <div class="warning-box">
                    <i class="fas fa-exclamation-triangle fa-2x mb-2 d-block"></i>
                    <strong>Warning!</strong> This action cannot be undone. The payment record will be permanently deleted.
                </div>
                
                <form method="post" action="deleteFeePayment" onsubmit="return confirmDelete()">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="paymentId" id="deletePaymentId">
                    
                    <div class="mb-3">
                        <label class="form-label">
                            Type <strong class="text-danger">DELETE</strong> to confirm:
                        </label>
                        <input type="text" class="form-control" id="confirmText" 
                               placeholder="Enter DELETE to confirm" required>
                    </div>
                    
                    <button type="submit" class="btn btn-danger btn-delete w-100" id="deleteBtn" disabled>
                        <i class="fas fa-trash-alt me-2"></i>Permanently Delete Record
                    </button>
                </form>
            </div>
        <% } %>
        
        <div class="text-center mt-3">
            <a href="index.jsp" class="btn btn-secondary">
                <i class="fas fa-home"></i> Back to Home
            </a>
        </div>
    </div>
</div>

<script>
    function selectPayment(paymentId) {
        document.getElementById('deletePaymentId').value = paymentId;
        document.getElementById('deleteSection').style.display = 'block';
        document.getElementById('confirmText').value = '';
        document.getElementById('deleteBtn').disabled = true;
        
        // Scroll to delete section
        document.getElementById('deleteSection').scrollIntoView({ behavior: 'smooth' });
    }
    
    // Enable delete button when DELETE is typed
    document.getElementById('confirmText')?.addEventListener('input', function(e) {
        let deleteBtn = document.getElementById('deleteBtn');
        if (e.target.value === 'DELETE') {
            deleteBtn.disabled = false;
        } else {
            deleteBtn.disabled = true;
        }
    });
    
    function confirmDelete() {
        let confirmText = document.getElementById('confirmText').value;
        if (confirmText !== 'DELETE') {
            alert('Please type "DELETE" to confirm deletion');
            return false;
        }
        return confirm('Are you absolutely sure you want to delete this payment record? This action cannot be undone!');
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>