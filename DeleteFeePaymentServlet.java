package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/deleteFeePayment")
public class DeleteFeePaymentServlet extends HttpServlet {
    private FeePaymentDAO dao = new FeePaymentDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("search".equals(action)) {
            // Search by Student ID
            try {
                String studentIdStr = request.getParameter("studentId");
                if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Student ID is required");
                }
                
                int studentId = Integer.parseInt(studentIdStr);
                List<FeePayment> payments = dao.getPaymentsByStudentId(studentId);
                
                if (payments != null && !payments.isEmpty()) {
                    request.setAttribute("payments", payments);
                    request.setAttribute("studentId", studentId);
                } else {
                    request.setAttribute("message", "No payments found for Student ID: " + studentId);
                    request.setAttribute("messageType", "warning");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "Invalid Student ID format");
                request.setAttribute("messageType", "error");
            } catch (Exception e) {
                request.setAttribute("message", "Error: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
            request.getRequestDispatcher("feepaymentdelete.jsp").forward(request, response);
            
        } else if ("delete".equals(action)) {
            // Delete specific payment by Payment ID
            try {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                
                if (dao.deleteFeePayment(paymentId)) {
                    request.setAttribute("message", "Payment record deleted successfully!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Failed to delete payment record");
                    request.setAttribute("messageType", "error");
                }
            } catch (Exception e) {
                request.setAttribute("message", "Error: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
            
            // Redirect back to search page or show updated list
            request.getRequestDispatcher("feepaymentdelete.jsp").forward(request, response);
        }
    }
}