<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.DettaglioCarrello" %>
<%@ page import="model.CodiceSconto" %>
<%@ page import="java.math.BigDecimal" %>

<%
  Carrello carrello = (Carrello) request.getAttribute("carrello");
  BigDecimal totale = (BigDecimal) request.getAttribute("totale");
  BigDecimal totaleFinale = (BigDecimal) request.getAttribute("totaleFinale");
  CodiceSconto coupon = (CodiceSconto) request.getAttribute("coupon");
  String erroreCheckout = (String) session.getAttribute("erroreCheckout");
  String messaggioCheckout = (String) session.getAttribute("messaggioCheckout");

  session.removeAttribute("erroreCheckout");
  session.removeAttribute("messaggioCheckout");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Checkout - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Checkout</h1>

    <% if (erroreCheckout != null) { %>
    <div class="alert-error"><%= erroreCheckout %></div>
    <% } %>

    <% if (messaggioCheckout != null) { %>
    <div class="alert-success"><%= messaggioCheckout %></div>
    <% } %>

    <% if (request.getAttribute("errore") != null) { %>
    <div class="alert-error"><%= request.getAttribute("errore") %></div>
    <% } %>

    <div class="product-layout">
      <div>
        <div class="form-box" style="max-width:100%; margin:0;">
          <h1 style="font-size:28px;">Dati ordine</h1>

          <form action="<%= request.getContextPath() %>/checkout" method="post">
            <div class="form-group">
              <label for="indirizzoSpedizione">Indirizzo di spedizione</label>
              <input type="text" id="indirizzoSpedizione" name="indirizzoSpedizione" required>
            </div>

            <div class="form-group">
              <label for="metodoPagamento">Metodo di pagamento</label>
              <select id="metodoPagamento" name="metodoPagamento" required>
                <option value="">Seleziona</option>
                <option value="carta">Carta</option>
                <option value="paypal">PayPal</option>
                <option value="bonifico">Bonifico</option>
                <option value="contrassegno">Contrassegno</option>
              </select>
            </div>

            <button type="submit" class="btn btn-primary">Conferma ordine</button>
          </form>
        </div>

        <div class="form-box" style="max-width:100%;">
          <h1 style="font-size:28px;">Codice sconto</h1>

          <form action="<%= request.getContextPath() %>/applica-codice" method="post">
            <div class="form-group">
              <label for="codice">Inserisci codice</label>
              <input type="text" id="codice" name="codice" placeholder="Inserisci coupon">
            </div>

            <button type="submit" class="btn btn-dark">Applica codice</button>
          </form>
        </div>
      </div>

      <div>
        <div class="form-box" style="max-width:100%; margin:0;">
          <h1 style="font-size:28px;">Riepilogo ordine</h1>

          <%
            if (carrello != null && carrello.getArticoli() != null) {
              for (DettaglioCarrello d : carrello.getArticoli()) {
          %>
          <div style="padding:12px 0; border-bottom:1px solid #eee;">
            <strong><%= d.getProdotto().getNomeProdotto() %></strong><br>
            Quantità: <%= d.getQuantita() %><br>
            Subtotale: € <%= d.getSubtotale() %>
          </div>
          <%
              }
            }
          %>

          <div style="margin-top:18px;">
            <p><strong>Totale:</strong> € <%= totale != null ? totale : "0.00" %></p>

            <% if (coupon != null) { %>
            <p><strong>Coupon applicato:</strong> <%= coupon.getCodice() %> (-<%= coupon.getPercentualeSconto() %>%)</p>
            <p class="new-price">Totale finale: € <%= totaleFinale %></p>
            <% } else { %>
            <p class="new-price">Totale finale: € <%= totale != null ? totale : "0.00" %></p>
            <% } %>
          </div>
        </div>
      </div>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>