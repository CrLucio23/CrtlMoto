<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Categoria" %>

<%
    List<Prodotto> ultimiProdotti = (List<Prodotto>) request.getAttribute("ultimiProdotti");
    List<Prodotto> prodottiScontati = (List<Prodotto>) request.getAttribute("prodottiScontati");
    List<Categoria> categorie = (List<Categoria>) request.getAttribute("categorie");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRTLMOTO - Accessori e ricambi moto</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body class="modal-open">
<%
    Boolean mostraNewsletter = (Boolean) request.getAttribute("mostraNewsletter");
    if(Boolean.TRUE.equals(mostraNewsletter)){

%>
<div id="newsletterModal" class="newsletter-modal-overlay">
    <div class="newsletter-modal">
        <div class="newsletter-modal-left">
            <h2>Entra nel mondo CRTLMOTO</h2>
            <p>Ricevi novità, promo e un codice sconto esclusivo per il tuo primo acquisto.</p>
        </div>

        <div class="newsletter-modal-right">
            <button class="modal-close" type="button" onclick="closeNewsletterModal()">&times;</button>
            <h3>Newsletter</h3>
            <p>Inserisci la tua email e resta aggiornato sulle migliori offerte del mondo moto.</p>

            <form action="<%= request.getContextPath() %>/newsletter" method="post">
                <input type="email" name="email" placeholder="Inserisci la tua email" required>
                <div class="modal-actions">
                    <button type="submit" class="btn btn-primary">Iscrivimi</button>
                    <button type="button" class="btn btn-dark" onclick="closeNewsletterModal()">No grazie</button>
                </div>
            </form>

            <div class="small-note">Potrai disiscriverti quando vuoi.</div>
        </div>
    </div>
</div>
<% } %>
<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <section class="hero-xl hero-moto">
            <div class="hero-content">
                <span class="hero-kicker">Performance • stile • strada</span>
                <h1>Equipaggia la tua moto come si deve</h1>
                <p>
                    Ricambi, accessori, protezioni e abbigliamento selezionati
                    per chi vuole qualità vera e look aggressivo.
                </p>

                <div class="hero-actions">
                    <a class="btn btn-primary" href="<%= request.getContextPath() %>/catalogo">Shop now</a>
                    <a class="btn btn-light" href="<%= request.getContextPath() %>/garage">Il mio garage</a>
                </div>
            </div>
        </section>

        <section class="promo-strip-grid">
            <div class="promo-strip-card">
                <strong>Spedizione rapida</strong>
                <span>Ordini veloci e gestione semplice</span>
            </div>
            <div class="promo-strip-card">
                <strong>Codici sconto</strong>
                <span>Newsletter con promo dedicate</span>
            </div>
            <div class="promo-strip-card">
                <strong>Catalogo selezionato</strong>
                <span>Prodotti pensati per veri rider</span>
            </div>
        </section>

        <section>
            <h2 class="section-title">Categorie top</h2>
            <p class="section-subtitle">Entra subito nelle sezioni più cercate.</p>

            <div class="category-grid">
                <%
                    if (categorie != null) {
                        for (Categoria c : categorie) {
                            String categoryClass = "category-default";
                            String nome = c.getNomeCategoria() != null ? c.getNomeCategoria().toLowerCase() : "";

                            if (nome.contains("casc")) categoryClass = "category-helmet";
                            else if (nome.contains("giacc")) categoryClass = "category-jacket";
                            else if (nome.contains("guant")) categoryClass = "category-gloves";
                            else if (nome.contains("fren")) categoryClass = "category-brakes";
                            else if (nome.contains("access")) categoryClass = "category-accessories";
                %>
                <a class="category-card <%= categoryClass %>" href="<%= request.getContextPath() %>/catalogo?categoria=<%= c.getIdCategoria() %>">
                    <div class="category-card-overlay"></div>
                    <div class="category-card-content">
                        <h3><%= c.getNomeCategoria() %></h3>
                        <span>Scopri ora</span>
                    </div>
                </a>
                <%
                        }
                    }
                %>
            </div>
        </section>

        <section>
            <h2 class="section-title">Nuovi arrivi</h2>
            <p class="section-subtitle">Le ultime novità disponibili nello store.</p>

            <div class="grid-products">
                <%
                    if (ultimiProdotti != null) {
                        for (Prodotto p : ultimiProdotti) {
                            String img = request.getContextPath() + "/images/no-image.png";
                            if (p.getImmagini() != null && !p.getImmagini().isEmpty()) {
                                img = p.getImmagini().get(0).getUrlImmagine();
                            }
                %>
                <div class="product-card">
                    <div class="product-card-image">
                        <img src="<%= img %>" alt="<%= p.getNomeProdotto() %>">
                        <span class="product-badge product-badge-new">NEW</span>
                        <%
                            if (p.getQuantitaMagazzino() > 0 && p.getQuantitaMagazzino() <= 5) {
                        %>
                        <span class="product-badge product-badge-stock">Solo <%= p.getQuantitaMagazzino() %></span>
                        <%
                            }
                        %>
                    </div>

                    <div class="product-card-body">
                        <h3><%= p.getNomeProdotto() %></h3>
                        <p><%= p.getDescrizione() != null ? p.getDescrizione() : "" %></p>

                        <div class="price-box">
                            <span class="new-price">€ <%= p.getPrezzoScontato() %></span>
                        </div>

                        <div class="product-card-actions">
                            <a class="btn btn-dark" href="<%= request.getContextPath() %>/prodotto?id=<%= p.getIdProdotto() %>">Scopri</a>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </section>

        <section class="banner-split">
            <div class="banner-split-card banner-left">
                <div class="banner-inner">
                    <span class="banner-tag">Promo</span>
                    <h3>Accessori essenziali per ogni uscita</h3>
                    <p>Preparati alla prossima strada con una selezione aggressiva di prodotti.</p>
                    <a class="btn btn-primary" href="<%= request.getContextPath() %>/catalogo">Esplora</a>
                </div>
            </div>

            <div class="banner-split-card banner-right">
                <div class="banner-inner">
                    <span class="banner-tag">Garage</span>
                    <h3>Salva la tua moto nel garage</h3>
                    <p>Gestisci i tuoi veicoli e trova prodotti più adatti al tuo setup.</p>
                    <a class="btn btn-light" href="<%= request.getContextPath() %>/garage">Vai al garage</a>
                </div>
            </div>
        </section>

        <section>
            <h2 class="section-title">Offerte del momento</h2>
            <p class="section-subtitle">Sconti attivi su prodotti selezionati.</p>

            <div class="grid-products">
                <%
                    if (prodottiScontati != null) {
                        for (Prodotto p : prodottiScontati) {
                            String img = request.getContextPath() + "/images/no-image.png";
                            if (p.getImmagini() != null && !p.getImmagini().isEmpty()) {
                                img = p.getImmagini().get(0).getUrlImmagine();
                            }
                %>
                <div class="product-card">
                    <div class="product-card-image">
                        <img src="<%= img %>" alt="<%= p.getNomeProdotto() %>">
                        <span class="product-badge product-badge-sale">-<%= p.getScontoPercentuale() %>%</span>
                    </div>

                    <div class="product-card-body">
                        <h3><%= p.getNomeProdotto() %></h3>
                        <p><%= p.getDescrizione() != null ? p.getDescrizione() : "" %></p>

                        <div class="price-box">
                            <span class="old-price">€ <%= p.getPrezzoBase() %></span>
                            <span class="new-price">€ <%= p.getPrezzoScontato() %></span>
                        </div>

                        <div class="product-card-actions">
                            <a class="btn btn-primary" href="<%= request.getContextPath() %>/prodotto?id=<%= p.getIdProdotto() %>">Approfitta ora</a>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </section>

        <section class="newsletter-inline">
            <h2>Newsletter CRTLMOTO</h2>
            <p>Ricevi offerte, novità e codici sconto direttamente via email.</p>
            <form action="<%= request.getContextPath() %>/newsletter" method="post">
                <input type="email" name="email" placeholder="Inserisci la tua email" required>
                <button type="submit" class="btn btn-primary">Iscrivimi ora</button>
            </form>
        </section>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

<script>
    function closeNewsletterModal() {
        const modal = document.getElementById("newsletterModal");
        if (modal) {
            modal.style.display = "none";
            document.body.classList.remove("modal-open");
        }
    }
</script>

</body>
</html>