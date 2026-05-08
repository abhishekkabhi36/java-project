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

@WebServlet("/feepaymentdisplay")
public class DisplayFeePaymentsServlet extends HttpServlet {
    private FeePaymentDAO dao = new FeePaymentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DisplayFeePaymentsServlet called"); // Debug
        
        try {
            List<FeePayment> payments = dao.getAllPayments();
            System.out.println("Number of payments retrieved: " + payments.size()); // Debug
            
            // Print each payment for debugging
            for(FeePayment p : payments) {
                System.out.println("Payment ID: " + p.getPaymentId() + 
                                 ", Student: " + p.getStudentName() + 
                                 ", Amount: " + p.getAmount());
            }
            
            request.setAttribute("payments", payments);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("feepaymentdisplay.jsp").forward(request, response);
    }
}