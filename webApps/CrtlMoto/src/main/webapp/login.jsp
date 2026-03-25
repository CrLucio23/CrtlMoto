<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/ images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <div class="form-box">
            <h1>Login</h1>

            <% if (request.getAttribute("errore") != null) { %>
            <div class="alert-error"><%= request.getAttribute("errore") %></div>
            <% } %>

            <% if (request.getAttribute("successo") != null) { %>
            <div class="alert-success"><%= request.getAttribute("successo") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <button type="submit" class="btn btn-primary">Accedi</button>
            </form>

            <div style="margin-top: 18px;">
                <p>Non hai un account?
                    <a href="<%= request.getContextPath() %>/register" style="color:#A52A2A; font-weight:bold;">Registrati</a>
                </p>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
</div>

</body>
</html>