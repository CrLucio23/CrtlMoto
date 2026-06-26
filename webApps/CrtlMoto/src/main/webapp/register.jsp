<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Registrazione - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <div class="form-box">
      <h1>Registrati</h1>

      <c:if test="${not empty errore}">
      <div class="alert-error"><c:out value="${errore}" /></div>
      </c:if>

      <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
          <label for="nome">Nome</label>
          <input type="text" id="nome" name="nome"
                 value="${nome}"
                 required>
        </div>

        <div class="form-group">
          <label for="cognome">Cognome</label>
          <input type="text" id="cognome" name="cognome"
                 value="${cognome}"
                 required>
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email"
                 value="${email}"
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
          <a href="${pageContext.request.contextPath}/login" style="color:#A52A2A; font-weight:bold;">Accedi</a>
        </p>
      </div>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
