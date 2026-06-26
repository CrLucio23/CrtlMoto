<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Profilo - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Il mio profilo</h1>

    <c:if test="${not empty errore}">
    <div class="alert-error"><c:out value="${errore}" /></div>
    </c:if>

    <c:if test="${not empty successo}">
    <div class="alert-success"><c:out value="${successo}" /></div>
    </c:if>

    <div class="product-layout">
      <div class="form-box" style="max-width:100%; margin:0;">
        <h1 style="font-size:28px;">Dati personali</h1>

        <form action="${pageContext.request.contextPath}/profilo" method="post">
          <div class="form-group">
            <label for="nome">Nome</label>
            <input id="nome" type="text" name="nome" value="${utenteProfilo.nome}" required>
          </div>

          <div class="form-group">
            <label for="cognome">Cognome</label>
            <input id="cognome" type="text" name="cognome" value="${utenteProfilo.cognome}" required>
          </div>

          <div class="form-group">
            <label for="telefono">Telefono</label>
            <input id="telefono" type="text" name="telefono" value="${utenteProfilo.telefono}">
          </div>

          <div class="form-group">
            <label for="indirizzo">Indirizzo</label>
            <input id="indirizzo" type="text" name="indirizzo" value="${utenteProfilo.indirizzo}">
          </div>

          <div class="form-group">
            <label for="citta">Città</label>
            <input id="citta" type="text" name="citta" value="${utenteProfilo.citta}">
          </div>

          <div class="form-group">
            <label for="cap">CAP</label>
            <input id="cap" type="text" name="cap" value="${utenteProfilo.cap}">
          </div>

          <button type="submit" class="btn btn-primary">Aggiorna profilo</button>
        </form>
      </div>

      <div class="form-box" style="max-width:100%; margin:0;">
        <h1 style="font-size:28px;">Cambia password</h1>

        <form action="${pageContext.request.contextPath}/profilo" method="post">
          <input type="hidden" name="action" value="updatePassword">

          <div class="form-group">
            <label for="passwordAttuale">Password attuale</label>
            <input id="passwordAttuale" type="password" name="passwordAttuale" required>
          </div>

          <div class="form-group">
            <label for="nuovaPassword">Nuova password</label>
            <input id="nuovaPassword" type="password" name="nuovaPassword" required>
          </div>

          <div class="form-group">
            <label for="confermaPassword">Conferma nuova password</label>
            <input id="confermaPassword" type="password" name="confermaPassword" required>
          </div>

          <button type="submit" class="btn btn-dark">Aggiorna password</button>
        </form>
      </div>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
