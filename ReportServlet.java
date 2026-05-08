package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {
    private FeePaymentDAO dao = new FeePaymentDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        
        try {
            if ("overdue".equals(reportType)) {
                List<FeePayment> overdue = dao.getOverduePayments();
                request.setAttribute("reportData", overdue);
                request.setAttribute("reportTitle", "Overdue Payments");
                request.setAttribute("showAmount", true);
                
            } else if ("paid".equals(reportType)) {
                List<FeePayment> paid = dao.getPaidPayments();
                request.setAttribute("reportData", paid);
                request.setAttribute("reportTitle", "Paid Payments");
                request.setAttribute("showAmount", true);
                
            } else if ("dateRange".equals(reportType)) {
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");
                
                if (startDate == null || endDate == null) {
                    throw new Exception("Please select both dates");
                }
                
                List<FeePayment> payments = dao.getPaymentsByDateRange(startDate, endDate);
                BigDecimal total = dao.getTotalCollection(startDate, endDate);
                
                request.setAttribute("reportData", payments);
                request.setAttribute("totalCollection", total);
                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("reportTitle", "Date Range Report");
                request.setAttribute("showAmount", true);
                request.setAttribute("showTotal", true);
            }
            
            request.getRequestDispatcher("report_result.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }
}