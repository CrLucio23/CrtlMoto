<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Registrazione - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <div class="form-box">
      <h1>Registrati</h1>

      <% if (request.getAttribute("errore") != null) { %>
      <div class="alert-error"><%= request.getAttribute("errore") %></div>
      <% } %>

      <form action="<%= request.getContextPath() %>/register" method="post">
        <div class="form-group">
          <label for="nome">Nome</label>
          <input type="text" id="nome" name="nome"
                 value="<%= request.getAttribute("nome") != null ? request.getAttribute("nome") : "" %>"
                 required>
        </div>

        <div class="form-group">
          <label for="cognome">Cognome</label>
          <input type="text" id="cognome" name="cognome"
                 value="<%= request.getAttribute("cognome") != null ? request.getAttribute("cognome") : "" %>"
                 required>
        </div>

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

        <button type="submit" class="btn btn-primary">Crea account</button>
      </form>

      <div style="margin-top: 18px;">
        <p>Hai già un account?
          <a href="<%= request.getContextPath() %>/login" style="color:#A52A2A; font-weight:bold;">Accedi</a>
        </p>
      </div>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>