package com.dao;

import com.model.FeePayment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class FeePaymentDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/CollegeFeeDB?useSSL=false&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "sachin@18";
    
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Connecting to database: " + URL);
        System.out.println("Username: " + USERNAME);
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    // Get next Payment ID - Next number after the last entered payment
    public int getNextPaymentId() {
        System.out.println("=== getNextPaymentId() called ===");
        String sql = "SELECT MAX(PaymentID) as max_id FROM FeePayments";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                System.out.println("MAX PaymentID from database: " + maxId);
                int nextId = maxId + 1;
                System.out.println("Next Payment ID will be: " + nextId);
                return nextId;
            }
        } catch (SQLException e) {
            System.out.println("Error getting next Payment ID: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Returning default Payment ID: 1");
        return 1;
    }
    
    // Get next Student ID - Next number after the last entered student
    public int getNextStudentId() {
        System.out.println("=== getNextStudentId() called ===");
        String sql = "SELECT MAX(StudentID) as max_id FROM FeePayments";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                System.out.println("MAX StudentID from database: " + maxId);
                int nextId = maxId + 1;
                System.out.println("Next Student ID will be: " + nextId);
                return nextId;
            }
        } catch (SQLException e) {
            System.out.println("Error getting next Student ID: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Returning default Student ID: 1001");
        return 1001;
    }
    
    // Add payment
    public FeePayment addFeePayment(FeePayment payment) {
        String sql = "INSERT INTO FeePayments (StudentID, StudentName, PaymentDate, Amount, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, payment.getStudentId());
            pstmt.setString(2, payment.getStudentName());
            pstmt.setDate(3, payment.getPaymentDate());
            pstmt.setBigDecimal(4, payment.getAmount());
            pstmt.setString(5, payment.getStatus());
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int paymentId = rs.getInt(1);
                    payment.setPaymentId(paymentId);
                    return payment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update payment
    public boolean updateFeePayment(FeePayment payment) {
        String sql = "UPDATE FeePayments SET StudentName=?, PaymentDate=?, Amount=?, Status=? WHERE PaymentID=?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, payment.getStudentName());
            pstmt.setDate(2, payment.getPaymentDate());
            pstmt.setBigDecimal(3, payment.getAmount());
            pstmt.setString(4, payment.getStatus());
            pstmt.setInt(5, payment.getPaymentId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete payment
    public boolean deleteFeePayment(int paymentId) {
        String sql = "DELETE FROM FeePayments WHERE PaymentID=?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, paymentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all payments
    public List<FeePayment> getAllPayments() {
        List<FeePayment> list = new ArrayList<>();
        String sql = "SELECT * FROM FeePayments ORDER BY PaymentDate DESC";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extract(rs));
            }
            System.out.println("Retrieved " + list.size() + " payment records");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get payment by ID
    public FeePayment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM FeePayments WHERE PaymentID=?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, paymentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extract(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get payments by Student ID
    public List<FeePayment> getPaymentsByStudentId(int studentId) {
        List<FeePayment> list = new ArrayList<>();
        String sql = "SELECT * FROM FeePayments WHERE StudentID=? ORDER BY PaymentDate DESC";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extract(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get overdue payments
    public List<FeePayment> getOverduePayments() {
        List<FeePayment> list = new ArrayList<>();
        String sql = "SELECT * FROM FeePayments WHERE Status='Overdue'";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extract(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get paid payments
    public List<FeePayment> getPaidPayments() {
        List<FeePayment> list = new ArrayList<>();
        String sql = "SELECT * FROM FeePayments WHERE Status='Paid' ORDER BY PaymentDate DESC";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extract(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get payments by date range
    public List<FeePayment> getPaymentsByDateRange(String startDate, String endDate) {
        List<FeePayment> list = new ArrayList<>();
        String sql = "SELECT * FROM FeePayments WHERE PaymentDate BETWEEN ? AND ? ORDER BY PaymentDate DESC";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extract(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get total collection by date range
    public BigDecimal getTotalCollection(String startDate, String endDate) {
        String sql = "SELECT COALESCE(SUM(Amount), 0) as Total FROM FeePayments WHERE PaymentDate BETWEEN ? AND ? AND Status='Paid'";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("Total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    private FeePayment extract(ResultSet rs) throws SQLException {
        FeePayment p = new FeePayment();
        p.setPaymentId(rs.getInt("PaymentID"));
        p.setStudentId(rs.getInt("StudentID"));
        p.setStudentName(rs.getString("StudentName"));
        p.setPaymentDate(rs.getDate("PaymentDate"));
        p.setAmount(rs.getBigDecimal("Amount"));
        p.setStatus(rs.getString("Status"));
        return p;
    }
}