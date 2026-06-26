<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${empty prodotto ? 'Prodotto' : prodotto.nomeProdotto}" /> - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <c:choose>
            <c:when test="${empty prodotto}">
                <div class="alert-error">Prodotto non trovato.</div>
            </c:when>
            <c:otherwise>
                <div class="product-layout">
                    <div>
                        <div class="product-gallery-main">
                            <button type="button" onclick="prevImage()" class="gallery-arrow" aria-label="Immagine precedente">&lsaquo;</button>
                            <img id="mainProductImage" src="${mainImage}" alt="${prodotto.nomeProdotto}">
                            <button type="button" onclick="nextImage()" class="gallery-arrow" aria-label="Immagine successiva">&rsaquo;</button>
                        </div>

                        <c:if test="${not empty galleryImages}">
                            <div class="product-thumb-row">
                                <c:forEach var="image" items="${galleryImages}" varStatus="status">
                                    <div class="product-thumb">
                                        <button type="button"
                                                class="product-thumb-button"
                                                onclick="setImage(${status.index})"
                                                aria-label="Mostra immagine ${status.count}">
                                            <img src="${image}" alt="">
                                        </button>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <div class="product-meta">
                        <c:choose>
                            <c:when test="${prodotto.scontoPercentuale > 0}">
                                <span class="product-badge product-badge-sale static-badge">-${prodotto.scontoPercentuale}%</span>
                            </c:when>
                            <c:otherwise>
                                <span class="product-badge product-badge-new static-badge">TOP PICK</span>
                            </c:otherwise>
                        </c:choose>

                        <h1><c:out value="${prodotto.nomeProdotto}" /></h1>

                        <p><strong>Descrizione:</strong> <c:out value="${empty prodotto.descrizione ? '-' : prodotto.descrizione}" /></p>
                        <p><strong>Colore:</strong> <c:out value="${empty prodotto.colore ? '-' : prodotto.colore}" /></p>
                        <p><strong>Taglia:</strong> <c:out value="${empty prodotto.taglia ? '-' : prodotto.taglia}" /></p>
                        <p><strong>Compatibilita:</strong> <c:out value="${empty prodotto.compatibilita ? '-' : prodotto.compatibilita}" /></p>

                        <p><strong>Disponibilita:</strong> <span id="availabilityText"><c:out value="${availabilityText}" /></span></p>
                        <p id="stockMessage" class="stock-message" aria-live="polite"></p>

                        <div class="price-box">
                            <c:if test="${prodotto.scontoPercentuale > 0}">
                                <span class="old-price">&euro; ${prodotto.prezzoBase}</span>
                            </c:if>
                            <span class="new-price">&euro; ${prodotto.prezzoScontato}</span>
                        </div>

                        <c:choose>
                            <c:when test="${admin}">
                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/prodotti?action=edit&id=${prodotto.idProdotto}">Modifica prodotto</a>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/carrello" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">

                                    <div class="form-group">
                                        <label for="quantita">Quantita</label>
                                        <input type="number"
                                               id="quantita"
                                               name="quantita"
                                               min="1"
                                               max="${prodotto.quantitaMagazzino}"
                                               value="1"
                                               required>
                                    </div>

                                    <button type="submit" class="btn btn-primary">Aggiungi al carrello</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="footer.jsp" />
</div>

<script>
    const images = [
        <c:forEach var="image" items="${galleryImages}" varStatus="status">
        "${image}"<c:if test="${not status.last}">,</c:if>
        </c:forEach>
    ];

    let currentIndex = 0;

    function setImage(index) {
        if (images.length === 0) return;
        currentIndex = index;
        document.getElementById("mainProductImage").src = images[currentIndex];
    }

    function nextImage() {
        if (images.length === 0) return;
        currentIndex = (currentIndex + 1) % images.length;
        setImage(currentIndex);
    }

    function prevImage() {
        if (images.length === 0) return;
        currentIndex = (currentIndex - 1 + images.length) % images.length;
        setImage(currentIndex);
    }

    const quantityInput = document.getElementById("quantita");
    const stockMessage = document.getElementById("stockMessage");

    if (quantityInput && stockMessage) {
        quantityInput.addEventListener("input", checkAvailability);
        checkAvailability();
    }

    function checkAvailability() {
        const params = new URLSearchParams({
            id: "${prodotto.idProdotto}",
            quantita: quantityInput.value
        });

        fetch("${pageContext.request.contextPath}/api/prodotto-disponibilita?" + params.toString())
            .then(response => response.json())
            .then(data => {
                stockMessage.textContent = data.messaggio;
                stockMessage.className = data.disponibile ? "stock-message alert-success" : "stock-message alert-error";
            })
            .catch(() => {
                stockMessage.textContent = "";
                stockMessage.className = "stock-message";
            });
    }
</script>
</body>
</html>
