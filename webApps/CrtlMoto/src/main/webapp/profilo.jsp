<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Utente" %>

<%
  Utente utente = (Utente) request.getAttribute("utenteProfilo");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Profilo - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Il mio profilo</h1>

    <% if (request.getAttribute("errore") != null) { %>
    <div class="alert-error"><%= request.getAttribute("errore") %></div>
    <% } %>

    <% if (request.getAttribute("successo") != null) { %>
    <div class="alert-success"><%= request.getAttribute("successo") %></div>
    <% } %>

    <div class="product-layout">
      <div class="form-box" style="max-width:100%; margin:0;">
        <h1 style="font-size:28px;">Dati personali</h1>

        <form action="<%= request.getContextPath() %>/profilo" method="post">
          <div class="form-group">
            <label>Nome</label>
            <input type="text" name="nome" value="<%= utente != null ? utente.getNome() : "" %>" required>
          </div>

          <div class="form-group">
            <label>Cognome</label>
            <input type="text" name="cognome" value="<%= utente != null ? utente.getCognome() : "" %>" required>
          </div>

          <div class="form-group">
            <label>Telefono</label>
            <input type="text" name="telefono" value="<%= utente != null && utente.getTelefono() != null ? utente.getTelefono() : "" %>">
          </div>

          <div class="form-group">
            <label>Indirizzo</label>
            <input type="text" name="indirizzo" value="<%= utente != null && utente.getIndirizzo() != null ? utente.getIndirizzo() : "" %>">
          </div>

          <div class="form-group">
            <label>Città</label>
            <input type="text" name="citta" value="<%= utente != null && utente.getCitta() != null ? utente.getCitta() : "" %>">
          </div>

          <div class="form-group">
            <label>CAP</label>
            <input type="text" name="cap" value="<%= utente != null && utente.getCap() != null ? utente.getCap() : "" %>">
          </div>

          <button type="submit" class="btn btn-primary">Aggiorna profilo</button>
        </form>
      </div>

      <div class="form-box" style="max-width:100%; margin:0;">
        <h1 style="font-size:28px;">Cambia password</h1>

        <form action="<%= request.getContextPath() %>/profilo" method="post">
          <input type="hidden" name="action" value="updatePassword">

          <div class="form-group">
            <label>Password attuale</label>
            <input type="password" name="passwordAttuale" required>
          </div>

          <div class="form-group">
            <label>Nuova password</label>
            <input type="password" name="nuovaPassword" required>
          </div>

          <div class="form-group">
            <label>Conferma nuova password</label>
            <input type="password" name="confermaPassword" required>
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