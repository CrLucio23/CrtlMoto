<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${not empty prodotto ? 'Modifica prodotto' : 'Nuovo prodotto'} - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="/header.jsp" />

  <main class="container page-section">
    <div class="form-box" style="max-width:900px;">
      <h1>${not empty prodotto ? 'Modifica prodotto' : 'Nuovo prodotto'}</h1>

      <c:if test="${not empty errore}">
      <div class="alert-error"><c:out value="${errore}" /></div>
      </c:if>

      <form action="${pageContext.request.contextPath}/admin/prodotti" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="${not empty prodotto ? 'update' : 'save'}">
        <c:if test="${not empty prodotto}">
        <input type="hidden" name="id" value="${prodotto.idProdotto}">
        </c:if>

        <div class="form-group">
          <label for="nomeProdotto">Nome prodotto</label>
          <input id="nomeProdotto" type="text" name="nomeProdotto" value="${prodotto.nomeProdotto}" required>
        </div>

        <div class="form-group">
          <label for="descrizione">Descrizione</label>
          <textarea id="descrizione" name="descrizione" rows="5"><c:out value="${prodotto.descrizione}" /></textarea>
        </div>

        <div class="form-group">
          <label for="prezzoBase">Prezzo base</label>
          <input id="prezzoBase" type="number" name="prezzoBase" min="0" step="0.01" value="${prodotto.prezzoBase}" required>
        </div>

        <div class="form-group">
          <label for="scontoPercentuale">Sconto %</label>
          <input id="scontoPercentuale" type="number" name="scontoPercentuale" min="0" max="100" value="${not empty prodotto ? prodotto.scontoPercentuale : 0}">
        </div>

        <div class="form-group">
          <label for="quantitaMagazzino">Quantita magazzino</label>
          <input id="quantitaMagazzino" type="number" name="quantitaMagazzino" min="0" value="${not empty prodotto ? prodotto.quantitaMagazzino : 0}">
        </div>

        <div class="form-group">
          <label for="taglia">Taglia</label>
          <input id="taglia" type="text" name="taglia" value="${prodotto.taglia}">
        </div>

        <div class="form-group">
          <label for="colore">Colore</label>
          <input id="colore" type="text" name="colore" value="${prodotto.colore}">
        </div>

        <div class="form-group">
          <label for="compatibilita">Compatibilita</label>
          <textarea id="compatibilita" name="compatibilita" rows="3"><c:out value="${prodotto.compatibilita}" /></textarea>
        </div>

        <div class="form-group">
          <label for="immagine">Foto prodotto</label>
          <input id="immagine" type="file" name="immagine" accept="image/png,image/jpeg,image/webp,image/gif">
        </div>

        <div class="form-group">
          <label for="idCategoria">Categoria</label>
          <select id="idCategoria" name="idCategoria">
            <option value="">Seleziona categoria</option>
            <c:forEach var="c" items="${categorie}">
            <option value="${c.idCategoria}" ${not empty prodotto and prodotto.idCategoria == c.idCategoria ? 'selected' : ''}>
              <c:out value="${c.nomeCategoria}" />
            </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label for="idMarca">Marca</label>
          <select id="idMarca" name="idMarca">
            <option value="">Seleziona marca</option>
            <c:forEach var="m" items="${marche}">
            <option value="${m.idMarca}" ${not empty prodotto and prodotto.idMarca == m.idMarca ? 'selected' : ''}>
              <c:out value="${m.nomeMarca}" />
            </option>
            </c:forEach>
          </select>
        </div>

        <button type="submit" class="btn btn-primary">${not empty prodotto ? 'Aggiorna prodotto' : 'Salva prodotto'}</button>
      </form>
    </div>
  </main>

  <jsp:include page="/footer.jsp" />
</div>

</body>
</html>
