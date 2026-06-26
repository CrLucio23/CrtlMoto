<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Carrello - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Il tuo carrello</h1>

    <c:if test="${guestCart}">
      <div class="alert-success">Stai usando il carrello come ospite. Accedi prima del checkout per salvare l'ordine.</div>
    </c:if>

    <c:choose>
      <c:when test="${empty carrello or empty carrello.articoli}">
        <div class="alert-error">Il carrello &egrave; vuoto.</div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/catalogo">Vai al catalogo</a>
      </c:when>
      <c:otherwise>
        <div class="form-box" style="max-width:100%;">
          <table style="width:100%; border-collapse:collapse;">
            <thead>
            <tr style="text-align:left; border-bottom:1px solid #ddd;">
              <th style="padding:12px;">Prodotto</th>
              <th style="padding:12px;">Prezzo</th>
              <th style="padding:12px;">Quantita</th>
              <th style="padding:12px;">Subtotale</th>
              <th style="padding:12px;">Azioni</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="d" items="${carrello.articoli}">
              <tr style="border-bottom:1px solid #eee;">
                <td style="padding:12px;"><c:out value="${d.prodotto.nomeProdotto}" /></td>
                <td style="padding:12px;">&euro; ${d.prodotto.prezzoScontato}</td>
                <td style="padding:12px;">
                  <form action="${pageContext.request.contextPath}/carrello" method="post" style="display:flex; gap:8px; align-items:center;">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="idProdotto" value="${d.idProdotto}">
                    <label class="sr-only" for="quantita-${d.idProdotto}">Quantita per ${d.prodotto.nomeProdotto}</label>
                    <input id="quantita-${d.idProdotto}" type="number" name="quantita" min="1" value="${d.quantita}" style="width:80px; padding:8px;">
                    <button type="submit" class="btn btn-dark">Aggiorna</button>
                  </form>
                </td>
                <td style="padding:12px;">&euro; ${d.subtotale}</td>
                <td style="padding:12px;">
                  <form action="${pageContext.request.contextPath}/carrello" method="post">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="idProdotto" value="${d.idProdotto}">
                    <button type="submit"
                            class="btn btn-primary"
                            onclick="return confirm('Vuoi rimuovere questo prodotto dal carrello?')">
                      Rimuovi
                    </button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>

          <div style="margin-top:24px; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px;">
            <div class="new-price">Totale: &euro; ${totale}</div>
            <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">
              <form action="${pageContext.request.contextPath}/carrello" method="post">
                <input type="hidden" name="action" value="clear">
                <button type="submit"
                        class="btn btn-dark"
                        onclick="return confirm('Vuoi svuotare tutto il carrello?')">
                  Svuota carrello
                </button>
              </form>
              <a class="btn btn-primary" href="${pageContext.request.contextPath}/checkout">Procedi al checkout</a>
            </div>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
