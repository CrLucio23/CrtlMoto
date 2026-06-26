<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="img" uri="http://crtlmoto.it/tags/images" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Immagini prodotto - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Immagini prodotto</h1>
        <p class="section-subtitle">
            <strong>Prodotto:</strong> <c:out value="${empty prodotto ? '-' : prodotto.nomeProdotto}" />
        </p>

        <div class="form-box" style="max-width:900px;">
            <h1 style="font-size:28px;">Aggiungi immagine</h1>

            <form action="${pageContext.request.contextPath}/admin/immagini-prodotto" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">

                <div class="form-group">
                    <label for="immagine">Immagine</label>
                    <input id="immagine" type="file" name="immagine" accept="image/png,image/jpeg,image/webp,image/gif" required>
                </div>

                <div class="form-group" style="display:flex; align-items:center; gap:14px; padding: 12px 0;">
                    <label class="toggle-switch">
                        <input type="checkbox" name="principale" value="true" aria-label="Imposta come immagine principale" title="Imposta come immagine principale">
                        <span class="toogle-slider"> </span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary">Aggiungi immagine</button>
            </form>
        </div>

        <div class="grid-products">
            <c:choose>
                <c:when test="${not empty immagini}">
                    <c:forEach var="immagine" items="${immagini}">
                    <div class="product-card">
                        <div class="product-card-image">
                            <img src="${img:resolve(pageContext.request, immagine.urlImmagine)}" alt="Immagine prodotto">
                        </div>

                        <div class="product-card-body">
                            <c:if test="${immagine.principale}">
                            <span class="badge-discount">Principale</span>
                            </c:if>

                            <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                <form action="${pageContext.request.contextPath}/admin/immagini-prodotto" method="post">
                                    <input type="hidden" name="action" value="setMain">
                                    <input type="hidden" name="idImmagine" value="${immagine.idImmagine}">
                                    <input type="hidden" name="idProdotto" value="${immagine.idProdotto}">
                                    <button type="submit" class="btn btn-dark">Rendi principale</button>
                                </form>

                                <form action="${pageContext.request.contextPath}/admin/immagini-prodotto" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="idImmagine" value="${immagine.idImmagine}">
                                    <input type="hidden" name="idProdotto" value="${immagine.idProdotto}">
                                    <button type="submit"
                                            class="btn btn-primary"
                                            onclick="return confirm('Eliminare questa immagine?')">
                                        Elimina
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="alert-error" style="grid-column:1/-1;">Nessuna immagine associata al prodotto.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

</body>
</html>
