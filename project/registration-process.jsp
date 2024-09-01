<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.sql.*" %>

<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    String course = request.getParameter("course");
    String errorMessage = null;

    // Password validation regex
    String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    
    if (!Pattern.matches(passwordPattern, password)) {
        errorMessage = "Password must be at least 8 characters long, with at least one uppercase letter, one lowercase letter, one digit, and one special character.";
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("create-registration.jsp").forward(request, response);
        return;
    }

    try {
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            // Check if the email already exists
            String checkEmailSql = "SELECT email FROM tutors WHERE email = ?";
            try (PreparedStatement checkStmt = con.prepareStatement(checkEmailSql)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    errorMessage = "Email already registered. Please use a different email.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("create-registration.jsp").forward(request, response);
                    return;
                }
            }

            // Check if the phone number already exists
            String checkPhoneSql = "SELECT phone FROM tutors WHERE phone = ?";
            try (PreparedStatement checkStmt = con.prepareStatement(checkPhoneSql)) {
                checkStmt.setString(1, phone);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    errorMessage = "Phone number already registered. Please use a different phone number.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("create-registration.jsp").forward(request, response);
                    return;
                }
            }

            String sql = "INSERT INTO tutors (name, email, phone, password, course, role) VALUES (?, ?, ?, ?, ?, 'tutor')";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, phone);
                stmt.setString(4, password);
                stmt.setString(5, course);

                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    response.sendRedirect("login.html?success=true");
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.getRequestDispatcher("create-registration.jsp").forward(request, response);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "SQL Error: " + e.getMessage());
        request.getRequestDispatcher("create-registration.jsp").forward(request, response);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Error: MySQL Driver not found.");
        request.getRequestDispatcher("create-registration.jsp").forward(request, response);
    }
%>

