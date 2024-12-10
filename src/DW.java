package src;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class DW {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=DT";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String EMAIL_FROM = "21130377@st.hcmuaf.edu.com";
    private static final String EMAIL_TO = "huynguyen7013@gmail.com";
    private static final String EMAIL_SUBJECT_SUCCESS = "Data Transformation Success";
    private static final String EMAIL_SUBJECT_FAILURE = "Data Transformation Failure";

    private Connection conn; // Kết nối toàn cục

    public DW() throws SQLException {
        // Khởi tạo kết nối khi tạo lớp
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    public static void main(String[] args) {
        try {
            // Tạo kết nối
            DW dw = new DW();

            // 3. Transform dữ liệu
            System.out.println("=== Bắt đầu quá trình transform dữ liệu ===");
            dw.transformData();
            // 4. Load dữ liệu đã transform lên warehouse
            System.out.println("=== Bắt đầu quá trình load dữ liệu lên Data Warehouse ===");
            dw.loadDataToWarehouse();

            // Đóng kết nối
            dw.closeConnection();

        } catch (Exception e) {
            logErrorAndSendEmail("Kết nối hoặc xử lý lỗi: " + e.getMessage(), true);
        }
    }

    /**
     * Hàm thực hiện quy trình transform dữ liệu
     */
    public void transformData() {
        Statement stmt = null;
        try {
            // Command 3.1: Kiểm tra kết nối
            if (conn != null) {// 3.1.2 kết nối thành công
                // Command 3.2: Gọi procedure transform
                stmt = conn.createStatement();
                String sql = "CALL transform_phim_data();";  // Tên procedure
                stmt.executeUpdate(sql);

                // Command 3.2.1: Ghi log thành công và gửi email
                logSuccessAndSendEmail("Quá trình transform dữ liệu thành công.");
            }
        } catch (SQLException e) {
            // Command 3.2.2: Ghi log thất bại và gửi email
            logErrorAndSendEmail("Lỗi khi thực thi procedure transform: " + e.getMessage(), false);
        } finally {
            // Command 3.3: Đóng statement
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                logErrorAndSendEmail("Lỗi khi đóng Statement: " + e.getMessage(), false);
            }
        }
    }

    /**
     * Hàm thực hiện quy trình upload dữ liệu lên Data Warehouse
     */
    public void loadDataToWarehouse() {
        Statement stmt = null;
        try {
            // Command 4.1: Kiểm tra kết nối
            if (conn != null) { // 4.1.2 kết nối thành công
                // Command 4.2: Gọi procedure load_fact_phim_data
                stmt = conn.createStatement();
                String sql = "CALL load_fact_phim_data();"; // Tên procedure
                stmt.executeUpdate(sql);

                // Command 4.2.1: Ghi log thành công và gửi email
                logSuccessAndSendEmail("Dữ liệu đã được tải lên Data Warehouse thành công.");
            }
        } catch (SQLException e) {
            // Command 4.2.2: Ghi log thất bại và gửi email
            logErrorAndSendEmail("Lỗi khi thực thi procedure load_fact_phim_data: " + e.getMessage(), false);
        } finally {
            // Command 4.3: Đóng statement
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                logErrorAndSendEmail("Lỗi khi đóng Statement: " + e.getMessage(), false);
            }
        }
    }

    /**
     * Hàm ghi log thành công và gửi email thông báo
     */
    public static void logSuccessAndSendEmail(String message) {
        // Command: Ghi log thành công
        System.out.println(message);

        // Command: Gửi email thông báo thành công
        sendEmail(EMAIL_SUBJECT_SUCCESS, message);
    }

    /**
     * Hàm ghi log lỗi và gửi email thông báo lỗi 3.1.1 và 4.1.1
     */
    public static void logErrorAndSendEmail(String errorMessage, boolean isError) {
        // Command: Ghi log lỗi
        System.err.println(errorMessage);

        // Command: Gửi email thông báo lỗi
        sendEmail(isError ? EMAIL_SUBJECT_FAILURE : EMAIL_SUBJECT_SUCCESS, errorMessage);
    }

    /**
     * Hàm gửi email thông báo
     */
    public static void sendEmail(String subject, String body) {
        try {
            Properties properties = System.getProperties();
            properties.put("mail.smtp.host", SMTP_HOST);
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.port", "587");

            // Xác thực email
            Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, "your-email-password");
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(EMAIL_TO));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
        } catch (MessagingException e) {
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
        }
    }

    /**
     * Hàm đóng kết nối
     */
    public void closeConnection() {
        try {
            if (conn != null) {
                conn.close();
                System.out.println("Kết nối đã được đóng.");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
        }
    }
}
