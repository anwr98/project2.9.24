<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tutor Registration</title>
    <link rel="stylesheet" href="/styles/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script>
        function validatePassword() {
            const password = document.getElementById('password').value;
            const errorMessage = document.getElementById('password-error');
            
            const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

            if (!regex.test(password)) {
                errorMessage.textContent = "Password must be at least 8 characters long, with at least one uppercase letter, one lowercase letter, one digit, and one special character.";
                return false;
            } else {
                errorMessage.textContent = ""; // Clear error message
                return true;
            }
        }
    </script>
</head>
<body>
    <header>
        <div id="logo-container">
            <img src="images/logo.png" alt="Courses Online" id="logo" onclick="location.href='index.jsp';">
        </div>
        <nav>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="index.jsp#about">About Us</a></li>
                <li><a href="index.jsp#courses">Our Courses</a></li>
                <li><a href="index.jsp#contact">Contact Us</a></li>
                <li><a href="login.jsp">Login</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <h1>Tutor Registration</h1>

        <%-- Display error message if present --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <p class="error-message" style="color: red;"><%= errorMessage %></p>
        <% } %>

        <form action="registration-process.jsp" method="post" onsubmit="return validatePassword();">
            <label for="name">Full Name:</label>
            <input type="text" id="name" name="name" required>
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <p id="password-error" style="color: red;"></p>

            <label for="course">Course to Teach:</label>
            <select id="course" name="course" required>
                <%
                    // Fetch courses from the database
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");

                        String sql = "SELECT course_name FROM courses";
                        PreparedStatement stmt = con.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();

                        while (rs.next()) {
                            String courseName = rs.getString("course_name");
                %>
                            <option value="<%= courseName %>"><%= courseName %></option>
                <%
                        }

                        rs.close();
                        stmt.close();
                        con.close();

                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("SQL Error: " + e.getMessage());
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                        out.println("Error: MySQL Driver not found.");
                    }
                %>
            </select>
            
            <button type="submit">Register</button>
        </form>
    </main>

    <footer>
        <div class="footer-content">
            <p>Follow us:</p>
            <a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i></a>
            <a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i></a>
        </div>
    </footer>
    
    <script src="/scripts/script.js"></script>
</body>
</html>
