<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.DettaglioCarrello" %>
<%@ page import="java.math.BigDecimal" %>

<%
  Carrello carrello = (Carrello) request.getAttribute("carrello");
  BigDecimal totale = BigDecimal.ZERO;

  if (carrello != null && carrello.getArticoli() != null) {
    for (DettaglioCarrello d : carrello.getArticoli()) {
      totale = totale.add(d.getSubtotale());
    }
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Carrello - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Il tuo carrello</h1>

    <%
      if (carrello == null || carrello.getArticoli() == null || carrello.getArticoli().isEmpty()) {
    %>
    <div class="alert-error">Il carrello è vuoto.</div>
    <a class="btn btn-primary" href="<%= request.getContextPath() %>/catalogo">Vai al catalogo</a>
    <%
    } else {
    %>
    <div class="form-box" style="max-width:100%;">
      <table style="width:100%; border-collapse:collapse;">
        <thead>
        <tr style="text-align:left; border-bottom:1px solid #ddd;">
          <th style="padding:12px;">Prodotto</th>
          <th style="padding:12px;">Prezzo</th>
          <th style="padding:12px;">Quantità</th>
          <th style="padding:12px;">Subtotale</th>
          <th style="padding:12px;">Azioni</th>
        </tr>
        </thead>
        <tbody>
        <%
          for (DettaglioCarrello d : carrello.getArticoli()) {
        %>
        <tr style="border-bottom:1px solid #eee;">
          <td style="padding:12px;"><%= d.getProdotto().getNomeProdotto() %></td>
          <td style="padding:12px;">€ <%= d.getProdotto().getPrezzoScontato() %></td>
          <td style="padding:12px;">
            <form action="<%= request.getContextPath() %>/carrello" method="post" style="display:flex; gap:8px; align-items:center;">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="idProdotto" value="<%= d.getIdProdotto() %>">
              <input type="number" name="quantita" min="1" value="<%= d.getQuantita() %>" style="width:80px; padding:8px;">
              <button type="submit" class="btn btn-dark">Aggiorna</button>
            </form>
          </td>
          <td style="padding:12px;">€ <%= d.getSubtotale() %></td>
          <td style="padding:12px;">
            <form action="<%= request.getContextPath() %>/carrello" method="post">
              <input type="hidden" name="action" value="remove">
              <input type="hidden" name="idProdotto" value="<%= d.getIdProdotto() %>">
              <button type="submit"
                      class="btn btn-primary"
                      onclick="return confirm('Vuoi rimuovere questo prodotto dal carrello?')">
                Rimuovi
              </button>
            </form>
          </td>
        </tr>
        <%
          }
        %>
        </tbody>
      </table>

      <div style="margin-top:24px; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px;">
        <div class="new-price">Totale: € <%= totale %></div>
        <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">
          <form action="<%= request.getContextPath() %>/carrello" method="post">
            <input type="hidden" name="action" value="clear">
            <button type="submit"
                    class="btn btn-dark"
                    onclick="return confirm('Vuoi svuotare tutto il carrello?')">
              Svuota carrello
            </button>
          </form>
          <a class="btn btn-primary" href="<%= request.getContextPath() %>/checkout">Procedi al checkout</a>
        </div>
      </div>
    </div>
    <%
      }
    %>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
