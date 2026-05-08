package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addFeePayment")
public class AddFeePaymentServlet extends HttpServlet {
    private FeePaymentDAO dao = new FeePaymentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get next numbers
        int nextPaymentId = dao.getNextPaymentId();
        int nextStudentId = dao.getNextStudentId();
        
        request.setAttribute("nextPaymentId", nextPaymentId);
        request.setAttribute("nextStudentId", nextStudentId);
        request.setAttribute("currentDate", LocalDate.now().toString());
        
        request.getRequestDispatcher("feepaymentadd.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String studentName = request.getParameter("studentName");
            String paymentDate = request.getParameter("paymentDate");
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            String status = request.getParameter("status");
            
            // Validation
            if (studentName == null || studentName.trim().isEmpty()) {
                throw new Exception("Student Name is required");
            }
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("Amount must be greater than 0");
            }
            
            FeePayment payment = new FeePayment();
            payment.setStudentId(studentId);
            payment.setStudentName(studentName);
            payment.setPaymentDate(Date.valueOf(paymentDate));
            payment.setAmount(amount);
            payment.setStatus(status);
            
            FeePayment saved = dao.addFeePayment(payment);
            
            if (saved != null) {
                request.setAttribute("message", "Payment added successfully!");
                request.setAttribute("messageType", "success");
                request.setAttribute("savedPayment", saved);
            } else {
                throw new Exception("Failed to add payment");
            }
        } catch (Exception e) {
            request.setAttribute("message", e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        // Get updated next numbers
        request.setAttribute("nextPaymentId", dao.getNextPaymentId());
        request.setAttribute("nextStudentId", dao.getNextStudentId());
        request.setAttribute("currentDate", LocalDate.now().toString());
        
        request.getRequestDispatcher("feepaymentadd.jsp").forward(request, response);
    }
}