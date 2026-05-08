package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/updateFeePayment")
public class UpdateFeePaymentServlet extends HttpServlet {
    private FeePaymentDAO dao = new FeePaymentDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("search".equals(action)) {
            try {
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                List<FeePayment> payments = dao.getPaymentsByStudentId(studentId);
                if (payments.isEmpty()) {
                    request.setAttribute("message", "No records found for Student ID: " + studentId);
                    request.setAttribute("messageType", "warning");
                } else {
                    request.setAttribute("payments", payments);
                    request.setAttribute("searchedId", studentId);
                }
            } catch (Exception e) {
                request.setAttribute("message", "Invalid Student ID");
                request.setAttribute("messageType", "error");
            }
            request.getRequestDispatcher("feepaymentupdate.jsp").forward(request, response);
            
        } else if ("edit".equals(action)) {
            try {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                FeePayment payment = dao.getPaymentById(paymentId);
                request.setAttribute("editPayment", payment);
            } catch (Exception e) {
                request.setAttribute("message", "Error loading payment");
                request.setAttribute("messageType", "error");
            }
            request.getRequestDispatcher("feepaymentupdate.jsp").forward(request, response);
            
        } else if ("update".equals(action)) {
            try {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                String studentName = request.getParameter("studentName");
                String paymentDate = request.getParameter("paymentDate");
                BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                String status = request.getParameter("status");
                
                FeePayment payment = new FeePayment(0, studentName, Date.valueOf(paymentDate), amount, status);
                payment.setPaymentId(paymentId);
                
                if (dao.updateFeePayment(payment)) {
                    request.setAttribute("message", "Payment updated successfully!");
                    request.setAttribute("messageType", "success");
                } else {
                    throw new Exception("Update failed");
                }
            } catch (Exception e) {
                request.setAttribute("message", "Error: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
            response.sendRedirect("feepaymentdisplay");
            return;
        }
    }
}