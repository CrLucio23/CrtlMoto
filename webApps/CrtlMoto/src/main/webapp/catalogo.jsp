<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="img" uri="http://crtlmoto.it/tags/images" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Catalogo - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Catalogo</h1>
    <p class="section-subtitle">Scopri accessori, ricambi e abbigliamento per la tua moto.</p>

    <div class="form-box" style="max-width:100%; margin-bottom:30px;">
      <form action="${pageContext.request.contextPath}/catalogo" method="get">
        <div class="form-group">
          <label for="q">Cerca prodotto</label>
          <input type="text" id="q" name="q"
                 value="${ricerca}"
                 placeholder="Es. casco, freni, guanti...">
        </div>

        <div class="form-group">
          <label for="categoria">Categoria</label>
          <select id="categoria" name="categoria">
            <option value="">Tutte le categorie</option>
            <c:forEach var="c" items="${categorie}">
            <option value="${c.idCategoria}" ${categoriaSelezionata == c.idCategoria ? 'selected' : ''}>
              <c:out value="${c.nomeCategoria}" />
            </option>
            </c:forEach>
          </select>
        </div>

        <button type="submit" class="btn btn-primary">Filtra</button>
      </form>
    </div>
    <div class="grid-products">
      <c:choose>
        <c:when test="${not empty prodotti}">
          <c:forEach var="p" items="${prodotti}">
          <div class="product-card">
            <div class="product-card-image">
              <img src="${img:resolve(pageContext.request, empty p.immagini ? '' : p.immagini[0].urlImmagine)}" alt="${p.nomeProdotto}">

              <c:choose>
                <c:when test="${p.scontoPercentuale > 0}">
                  <span class="product-badge product-badge-sale">-${p.scontoPercentuale}%</span>
                </c:when>
                <c:otherwise>
                  <span class="product-badge product-badge-new">TOP</span>
                </c:otherwise>
              </c:choose>

              <c:if test="${p.quantitaMagazzino > 0 and p.quantitaMagazzino <= 5}">
              <span class="product-badge product-badge-stock">Solo ${p.quantitaMagazzino}</span>
              </c:if>
            </div>

            <div class="product-card-body">
              <h3><c:out value="${p.nomeProdotto}" /></h3>
              <p><c:out value="${p.descrizione}" /></p>

              <div class="price-box">
                <c:if test="${p.scontoPercentuale > 0}">
                <span class="old-price">&euro; ${p.prezzoBase}</span>
                </c:if>
                <span class="new-price">&euro; ${p.prezzoScontato}</span>
              </div>

              <div class="product-card-actions">
                <a class="btn btn-dark" href="${pageContext.request.contextPath}/prodotto?id=${p.idProdotto}">
                  Vedi prodotto
                </a>
              </div>
            </div>
          </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="alert-error" style="grid-column:1/-1;">Nessun prodotto trovato.</div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
