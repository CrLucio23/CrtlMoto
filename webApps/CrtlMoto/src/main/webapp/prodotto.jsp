<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.ImmagineProdotto" %>

<%
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    String img = request.getContextPath() + "/images/no-image.png";

    if (prodotto != null && prodotto.getImmagini() != null && !prodotto.getImmagini().isEmpty()) {
        img = prodotto.getImmagini().get(0).getUrlImmagine();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= prodotto != null ? prodotto.getNomeProdotto() : "Prodotto" %> - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <% if (prodotto == null) { %>
        <div class="alert-error">Prodotto non trovato.</div>
        <% } else { %>
        <div class="product-layout">
            <%
                java.util.List<ImmagineProdotto> immagini = prodotto.getImmagini();
            %>
            <div>
                <div class="product-gallery-main">
                    <button type="button" onclick="prevImage()" class="gallery-arrow">‹</button>
                    <img id="mainProductImage" src="<%= img %>" alt="<%= prodotto.getNomeProdotto() %>">
                    <button type="button" onclick="nextImage()" class="gallery-arrow">›</button>
                </div>

                <% if (immagini != null && !immagini.isEmpty()) { %>
                <div class="product-thumb-row">
                    <% for (int k = 0; k < immagini.size(); k++) { %>
                    <div class="product-thumb">
                        <img
                                src="<%= immagini.get(k).getUrlImmagine() %>"
                                alt="thumb"
                                onclick="setImage(<%= k %>)">
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>

            <div class="product-meta">
                <% if (prodotto.getScontoPercentuale() > 0) { %>
                <span class="product-badge product-badge-sale">-<%= prodotto.getScontoPercentuale() %>%</span>
                <% } else { %>
                <span class="product-badge product-badge-new">TOP PICK</span>
                <% } %>

                <h1><%= prodotto.getNomeProdotto() %></h1>

                <p><strong>Descrizione:</strong> <%= prodotto.getDescrizione() != null ? prodotto.getDescrizione() : "-" %></p>
                <p><strong>Colore:</strong> <%= prodotto.getColore() != null ? prodotto.getColore() : "-" %></p>
                <p><strong>Taglia:</strong> <%= prodotto.getTaglia() != null ? prodotto.getTaglia() : "-" %></p>
                <p><strong>Compatibilità:</strong> <%= prodotto.getCompatibilita() != null ? prodotto.getCompatibilita() : "-" %></p>

                <p>
                    <strong>Disponibilità:</strong>
                    <% if (prodotto.getQuantitaMagazzino() > 5) { %>
                    Disponibile
                    <% } else if (prodotto.getQuantitaMagazzino() > 0) { %>
                    Ultimi pezzi
                    <% } else { %>
                    Esaurito
                    <% } %>
                </p>

                <div class="price-box">
                    <% if (prodotto.getScontoPercentuale() > 0) { %>
                    <span class="old-price">€ <%= prodotto.getPrezzoBase() %></span>
                    <% } %>
                    <span class="new-price">€ <%= prodotto.getPrezzoScontato() %></span>
                </div>

                <form action="<%= request.getContextPath() %>/carrello" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="idProdotto" value="<%= prodotto.getIdProdotto() %>">

                    <div class="form-group">
                        <label for="quantita">Quantità</label>
                        <input type="number" id="quantita" name="quantita" min="1" value="1" required>
                    </div>

                    <button type="submit" class="btn btn-primary">Aggiungi al carrello</button>
                </form>
            </div>
        </div>
        <% } %>
    </main>

    <jsp:include page="footer.jsp" />
</div>
<script>
    const images = [
        <% if (prodotto != null && prodotto.getImmagini() != null) {
            for (int k = 0; k < prodotto.getImmagini().size(); k++) {
                ImmagineProdotto im = prodotto.getImmagini().get(k);
        %>
        "<%= im.getUrlImmagine() %>"<%= k < prodotto.getImmagini().size() - 1 ? "," : "" %>
        <%  }
        } %>
    ];

    let currentIndex = 0;

    function setImage(index) {
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
</script>
</body>
</html>