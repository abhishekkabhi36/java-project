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

@WebServlet("/reportCriteria")
public class ReportCriteriaServlet extends HttpServlet {
    private FeePaymentDAO dao = new FeePaymentDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        
        try {
            if ("overdue".equals(reportType)) {
                generateOverdueReport(request, response);
            } else if ("paid".equals(reportType)) {
                generatePaidReport(request, response);
            } else if ("dateRange".equals(reportType)) {
                generateDateRangeReport(request, response);
            } else {
                request.setAttribute("error", "Invalid report type selected");
                request.getRequestDispatcher("report_form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("report_form.jsp").forward(request, response);
        }
    }
    
    private void generateOverdueReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<FeePayment> overduePayments = dao.getOverduePayments();
        
        // Calculate statistics
        BigDecimal totalOverdueAmount = BigDecimal.ZERO;
        for(FeePayment p : overduePayments) {
            totalOverdueAmount = totalOverdueAmount.add(p.getAmount());
        }
        
        request.setAttribute("reportTitle", "Overdue Payments Report");
        request.setAttribute("reportData", overduePayments);
        request.setAttribute("totalAmount", totalOverdueAmount);
        request.setAttribute("recordCount", overduePayments.size());
        request.setAttribute("showAmount", true);
        request.setAttribute("reportType", "overdue");
        
        request.getRequestDispatcher("report_result.jsp").forward(request, response);
    }
    
    private void generatePaidReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<FeePayment> paidPayments = dao.getPaidPayments();
        
        // Calculate statistics
        BigDecimal totalPaidAmount = BigDecimal.ZERO;
        for(FeePayment p : paidPayments) {
            totalPaidAmount = totalPaidAmount.add(p.getAmount());
        }
        
        request.setAttribute("reportTitle", "Paid Payments Report");
        request.setAttribute("reportData", paidPayments);
        request.setAttribute("totalAmount", totalPaidAmount);
        request.setAttribute("recordCount", paidPayments.size());
        request.setAttribute("showAmount", true);
        request.setAttribute("reportType", "paid");
        
        request.getRequestDispatcher("report_result.jsp").forward(request, response);
    }
    
    private void generateDateRangeReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        // Validate dates
        if (startDate == null || startDate.trim().isEmpty()) {
            throw new IllegalArgumentException("Start date is required");
        }
        if (endDate == null || endDate.trim().isEmpty()) {
            throw new IllegalArgumentException("End date is required");
        }
        
        if (startDate.compareTo(endDate) > 0) {
            throw new IllegalArgumentException("Start date must be before or equal to end date");
        }
        
        // Get payments in date range
        List<FeePayment> payments = dao.getPaymentsByDateRange(startDate, endDate);
        BigDecimal totalCollection = dao.getTotalCollection(startDate, endDate);
        
        request.setAttribute("reportTitle", "Date Range Collection Report");
        request.setAttribute("reportData", payments);
        request.setAttribute("totalCollection", totalCollection);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("recordCount", payments.size());
        request.setAttribute("showAmount", true);
        request.setAttribute("showTotal", true);
        request.setAttribute("reportType", "dateRange");
        
        request.getRequestDispatcher("report_result.jsp").forward(request, response);
    }
}