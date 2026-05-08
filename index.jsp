<%@ page import="java.util.*, com.dao.FeePaymentDAO, com.model.FeePayment, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>College Fee Payment System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .navbar {
            background: rgba(255,255,255,0.95);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 0;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .nav-link {
            font-weight: 500;
            margin: 0 10px;
            transition: all 0.3s;
        }
        .nav-link:hover {
            transform: translateY(-2px);
            color: #667eea !important;
        }
        .hero {
            padding: 60px 0;
            text-align: center;
            color: white;
        }
        .hero h1 {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 20px;
        }
        .hero p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .stats-container {
            margin-top: -50px;
            margin-bottom: 50px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s;
            cursor: pointer;
        }
        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        .stat-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0;
            color: #667eea;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .section-title {
            text-align: center;
            margin: 60px 0 40px;
            color: white;
        }
        .section-title h2 {
            font-size: 2.5rem;
            font-weight: 700;
        }
        .module-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            height: 100%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .module-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        .module-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        .module-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 15px 0;
            color: #333;
        }
        .module-desc {
            color: #666;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .module-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            padding: 10px 25px;
            border-radius: 25px;
            color: white;
            font-weight: 500;
            transition: all 0.3s;
        }
        .module-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .footer {
            background: #1a1a2e;
            color: white;
            padding: 40px 0 20px;
            margin-top: 60px;
        }
        .footer a {
            color: #ddd;
            text-decoration: none;
        }
        .footer a:hover {
            color: #667eea;
        }
    </style>
</head>
<body>

<%
    FeePaymentDAO dao = new FeePaymentDAO();
    List<FeePayment> allPayments = dao.getAllPayments();
    
    BigDecimal totalCollection = BigDecimal.ZERO;
    int paidCount = 0;
    int overdueCount = 0;
    Set<Integer> uniqueStudents = new HashSet<>();
    
    for(FeePayment p : allPayments) {
        if("Paid".equals(p.getStatus())) {
            totalCollection = totalCollection.add(p.getAmount());
            paidCount++;
        } else {
            overdueCount++;
        }
        uniqueStudents.add(p.getStudentId());
    }
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="fas fa-university me-2"></i>College Fee System
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="index.jsp">
                        <i class="fas fa-home me-1"></i>Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="feepaymentadd.jsp">
                        <i class="fas fa-plus-circle me-1"></i>Add Payment
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="feepaymentupdate.jsp">
                        <i class="fas fa-edit me-1"></i>Update
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="feepaymentdelete.jsp">
                        <i class="fas fa-trash me-1"></i>Delete
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="feepaymentdisplay">
                        <i class="fas fa-eye me-1"></i>View All
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="report_form.jsp">
                        <i class="fas fa-chart-line me-1"></i>Reports
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="hero">
    <div class="container">
        <h1>College Fee Payment System</h1>
        <p>Efficiently manage student fee payments, track collections, and generate reports</p>
        <div class="mt-4">
            <a href="feepaymentadd.jsp" class="btn btn-light btn-lg me-3">
                <i class="fas fa-plus-circle"></i> Add Payment
            </a>
            <a href="feepaymentdisplay" class="btn btn-outline-light btn-lg">
                <i class="fas fa-eye"></i> View Records
            </a>
        </div>
    </div>
</div>

<!-- Statistics Cards -->
<div class="container stats-container">
    <div class="row g-4">
        <div class="col-md-3 col-sm-6">
            <div class="stat-card" onclick="location.href='feepaymentdisplay'">
                <div class="stat-icon">
                    <i class="fas fa-money-bill-wave" style="color: #28a745;"></i>
                </div>
                <div class="stat-number">₹<%= String.format("%,.0f", totalCollection) %></div>
                <div class="stat-label">Total Collection</div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="stat-card" onclick="location.href='feepaymentdisplay'">
                <div class="stat-icon">
                    <i class="fas fa-receipt" style="color: #17a2b8;"></i>
                </div>
                <div class="stat-number"><%= allPayments.size() %></div>
                <div class="stat-label">Total Payments</div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="stat-card" onclick="location.href='feepaymentdisplay'">
                <div class="stat-icon">
                    <i class="fas fa-users" style="color: #ffc107;"></i>
                </div>
                <div class="stat-number"><%= uniqueStudents.size() %></div>
                <div class="stat-label">Active Students</div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="stat-card" onclick="location.href='report_form.jsp'">
                <div class="stat-icon">
                    <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
                </div>
                <div class="stat-number"><%= overdueCount %></div>
                <div class="stat-label">Overdue Payments</div>
            </div>
        </div>
    </div>
</div>

<!-- Modules Section -->
<div class="container">
    <div class="section-title">
        <h2>Payment Management Modules</h2>
        <p>Access all fee management features from one place</p>
    </div>
    
    <div class="row g-4">
        <!-- Add Payment Module -->
        <div class="col-md-4">
            <div class="module-card" onclick="location.href='feepaymentadd.jsp'">
                <div class="module-icon">
                    <i class="fas fa-plus-circle text-success"></i>
                </div>
                <h3 class="module-title">Add Payment</h3>
                <p class="module-desc">Record new fee payments with auto-generated IDs. Student ID and Payment ID are automatically generated by the system.</p>
                <button class="module-btn">
                    <i class="fas fa-plus"></i> Add Payment
                </button>
            </div>
        </div>
        
        <!-- Update Payment Module -->
        <div class="col-md-4">
            <div class="module-card" onclick="location.href='feepaymentupdate.jsp'">
                <div class="module-icon">
                    <i class="fas fa-edit text-warning"></i>
                </div>
                <h3 class="module-title">Update Payment</h3>
                <p class="module-desc">Search by Student ID to view all payments, then select and modify payment details as needed.</p>
                <button class="module-btn">
                    <i class="fas fa-pencil-alt"></i> Update Payment
                </button>
            </div>
        </div>
        
        <!-- Delete Payment Module -->
        <div class="col-md-4">
            <div class="module-card" onclick="location.href='feepaymentdelete.jsp'">
                <div class="module-icon">
                    <i class="fas fa-trash-alt text-danger"></i>
                </div>
                <h3 class="module-title">Delete Payment</h3>
                <p class="module-desc">Search by Student ID to view all payments, then select and delete specific payment record.</p>
                <button class="module-btn">
                    <i class="fas fa-trash"></i> Delete Payment
                </button>
            </div>
        </div>
        
        <!-- View All Payments Module -->
        <div class="col-md-4">
            <div class="module-card" onclick="location.href='feepaymentdisplay'">
                <div class="module-icon">
                    <i class="fas fa-table text-info"></i>
                </div>
                <h3 class="module-title">View All Payments</h3>
                <p class="module-desc">Display all payment records in a table format with sorting and search capabilities.</p>
                <button class="module-btn">
                    <i class="fas fa-eye"></i> View Records
                </button>
            </div>
        </div>
        
        <!-- Reports Module -->
        <div class="col-md-4">
            <div class="module-card" onclick="location.href='report_form.jsp'">
                <div class="module-icon">
                    <i class="fas fa-chart-line text-primary"></i>
                </div>
                <h3 class="module-title">Reports</h3>
                <p class="module-desc">Generate overdue payments report, paid payments report, and date range collection report.</p>
                <button class="module-btn">
                    <i class="fas fa-chart-bar"></i> View Reports
                </button>
            </div>
        </div>
        
        <!-- Dashboard Module -->
        <div class="col-md-4">
            <div class="module-card" onclick="location.href='index.jsp'">
                <div class="module-icon">
                    <i class="fas fa-tachometer-alt text-secondary"></i>
                </div>
                <h3 class="module-title">Dashboard</h3>
                <p class="module-desc">View statistics summary including total collection, payment counts, and student information.</p>
                <button class="module-btn">
                    <i class="fas fa-chart-pie"></i> Dashboard
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5><i class="fas fa-university me-2"></i>College Fee System</h5>
                <p class="text-muted">Efficient fee management solution for educational institutions</p>
            </div>
            <div class="col-md-4 mb-4">
                <h6>Quick Links</h6>
                <ul class="list-unstyled">
                    <li><a href="feepaymentadd.jsp"><i class="fas fa-angle-right me-2"></i>Add Payment</a></li>
                    <li><a href="feepaymentdisplay"><i class="fas fa-angle-right me-2"></i>View Payments</a></li>
                    <li><a href="report_form.jsp"><i class="fas fa-angle-right me-2"></i>Reports</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-4">
                <h6>Contact</h6>
                <ul class="list-unstyled">
                    <li><i class="fas fa-envelope me-2"></i> support@collegefeesystem.com</li>
                    <li><i class="fas fa-phone me-2"></i> +91 1234567890</li>
                </ul>
            </div>
        </div>
        <hr>
        <div class="text-center">
            <p class="mb-0 text-muted">&copy; 2024 College Fee Payment System. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>