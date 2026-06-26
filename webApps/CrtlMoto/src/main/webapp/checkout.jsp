<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Checkout - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Checkout</h1>

    <c:if test="${not empty sessionScope.erroreCheckout}">
    <div class="alert-error"><c:out value="${sessionScope.erroreCheckout}" /></div>
    </c:if>

    <c:if test="${not empty sessionScope.messaggioCheckout}">
    <div class="alert-success"><c:out value="${sessionScope.messaggioCheckout}" /></div>
    </c:if>

    <c:remove var="erroreCheckout" scope="session" />
    <c:remove var="messaggioCheckout" scope="session" />

    <c:if test="${not empty errore}">
    <div class="alert-error"><c:out value="${errore}" /></div>
    </c:if>

    <div class="product-layout">
      <div>
        <div class="form-box" style="max-width:100%; margin:0;">
          <h1 style="font-size:28px;">Dati ordine</h1>

          <form action="${pageContext.request.contextPath}/checkout" method="post">
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

          <form action="${pageContext.request.contextPath}/applica-codice" method="post">
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

          <c:forEach var="d" items="${carrello.articoli}">
          <div style="padding:12px 0; border-bottom:1px solid #eee;">
            <strong><c:out value="${d.prodotto.nomeProdotto}" /></strong><br>
            Quantita: ${d.quantita}<br>
            Subtotale: &euro; ${d.subtotale}
          </div>
          </c:forEach>

          <div style="margin-top:18px;">
            <p><strong>Totale:</strong> &euro; ${empty totale ? '0.00' : totale}</p>

            <c:choose>
              <c:when test="${not empty coupon}">
                <p><strong>Coupon applicato:</strong> <c:out value="${coupon.codice}" /> (-${coupon.percentualeSconto}%)</p>
                <p class="new-price">Totale finale: &euro; ${totaleFinale}</p>
              </c:when>
              <c:otherwise>
                <p class="new-price">Totale finale: &euro; ${empty totale ? '0.00' : totale}</p>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
