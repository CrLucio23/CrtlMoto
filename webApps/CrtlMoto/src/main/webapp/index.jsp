<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="img" uri="http://crtlmoto.it/tags/images" %>

<c:if test="${empty ultimiProdotti and empty prodottiScontati and empty categorie}">
    <c:redirect url="/home" />
</c:if>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRTLMOTO - Accessori e ricambi moto</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>

<body class="${mostraNewsletter ? 'modal-open' : ''}">

<c:if test="${mostraNewsletter}">
<div id="newsletterModal" class="newsletter-modal-overlay">
    <div class="newsletter-modal">
        <div class="newsletter-modal-left">
            <h2>Entra nel mondo CRTLMOTO</h2>
            <p>Ricevi novita, promo e un codice sconto esclusivo per il tuo primo acquisto.</p>
        </div>

        <div class="newsletter-modal-right">
            <button class="modal-close" type="button" onclick="closeNewsletterModal()">&times;</button>
            <h3>Newsletter</h3>
            <p>Inserisci la tua email e resta aggiornato sulle migliori offerte del mondo moto.</p>

            <form action="${pageContext.request.contextPath}/newsletter" method="post">
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
</c:if>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <section class="hero-xl hero-moto">
            <div class="hero-content">
                <span class="hero-kicker">Performance &bull; stile &bull; strada</span>
                <h1>Equipaggia la tua moto come si deve</h1>
                <p>
                    Ricambi, accessori, protezioni e abbigliamento selezionati
                    per chi vuole qualita vera e look aggressivo.
                </p>

                <div class="hero-actions">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/catalogo">Shop now</a>
                    <a class="btn btn-light" href="${pageContext.request.contextPath}/garage">Il mio garage</a>
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
            <p class="section-subtitle">Entra subito nelle sezioni piu cercate.</p>

            <div class="category-grid">
                <c:forEach var="c" items="${categorie}">
                    <c:set var="nomeCategoriaLower" value="${fn:toLowerCase(c.nomeCategoria)}" />
                    <c:set var="categoryClass" value="category-default" />
                    <c:if test="${fn:contains(nomeCategoriaLower, 'casc')}">
                        <c:set var="categoryClass" value="category-helmet" />
                    </c:if>
                    <c:if test="${fn:contains(nomeCategoriaLower, 'giacc')}">
                        <c:set var="categoryClass" value="category-jacket" />
                    </c:if>
                    <c:if test="${fn:contains(nomeCategoriaLower, 'guant')}">
                        <c:set var="categoryClass" value="category-gloves" />
                    </c:if>
                    <c:if test="${fn:contains(nomeCategoriaLower, 'fren')}">
                        <c:set var="categoryClass" value="category-brakes" />
                    </c:if>
                    <c:if test="${fn:contains(nomeCategoriaLower, 'access')}">
                        <c:set var="categoryClass" value="category-accessories" />
                    </c:if>

                    <a class="category-card ${categoryClass}" href="${pageContext.request.contextPath}/catalogo?categoria=${c.idCategoria}">
                        <div class="category-card-overlay"></div>
                        <div class="category-card-content">
                            <h3><c:out value="${c.nomeCategoria}" /></h3>
                            <span>Scopri ora</span>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </section>

        <section>
            <h2 class="section-title">Nuovi arrivi</h2>
            <p class="section-subtitle">Le ultime novita disponibili nello store.</p>

            <div class="grid-products">
                <c:forEach var="p" items="${ultimiProdotti}">
                <div class="product-card">
                    <div class="product-card-image">
                        <img src="${img:resolve(pageContext.request, empty p.immagini ? '' : p.immagini[0].urlImmagine)}" alt="${p.nomeProdotto}">
                        <span class="product-badge product-badge-new">NEW</span>
                        <c:if test="${p.quantitaMagazzino > 0 and p.quantitaMagazzino <= 5}">
                        <span class="product-badge product-badge-stock">Solo ${p.quantitaMagazzino}</span>
                        </c:if>
                    </div>

                    <div class="product-card-body">
                        <h3><c:out value="${p.nomeProdotto}" /></h3>
                        <p><c:out value="${p.descrizione}" /></p>

                        <div class="price-box">
                            <span class="new-price">&euro; ${p.prezzoScontato}</span>
                        </div>

                        <div class="product-card-actions">
                            <a class="btn btn-dark" href="${pageContext.request.contextPath}/prodotto?id=${p.idProdotto}">Scopri</a>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
        </section>

        <section class="banner-split">
            <div class="banner-split-card banner-left">
                <div class="banner-inner">
                    <span class="banner-tag">Promo</span>
                    <h3>Accessori essenziali per ogni uscita</h3>
                    <p>Preparati alla prossima strada con una selezione aggressiva di prodotti.</p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/catalogo">Esplora</a>
                </div>
            </div>

            <div class="banner-split-card banner-right">
                <div class="banner-inner">
                    <span class="banner-tag">Garage</span>
                    <h3>Salva la tua moto nel garage</h3>
                    <p>Gestisci i tuoi veicoli e trova prodotti piu adatti al tuo setup.</p>
                    <a class="btn btn-light" href="${pageContext.request.contextPath}/garage">Vai al garage</a>
                </div>
            </div>
        </section>

        <section>
            <h2 class="section-title">Offerte del momento</h2>
            <p class="section-subtitle">Sconti attivi su prodotti selezionati.</p>

            <div class="grid-products">
                <c:forEach var="p" items="${prodottiScontati}">
                <div class="product-card">
                    <div class="product-card-image">
                        <img src="${img:resolve(pageContext.request, empty p.immagini ? '' : p.immagini[0].urlImmagine)}" alt="${p.nomeProdotto}">
                        <span class="product-badge product-badge-sale">-${p.scontoPercentuale}%</span>
                    </div>

                    <div class="product-card-body">
                        <h3><c:out value="${p.nomeProdotto}" /></h3>
                        <p><c:out value="${p.descrizione}" /></p>

                        <div class="price-box">
                            <span class="old-price">&euro; ${p.prezzoBase}</span>
                            <span class="new-price">&euro; ${p.prezzoScontato}</span>
                        </div>

                        <div class="product-card-actions">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/prodotto?id=${p.idProdotto}">Approfitta ora</a>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
        </section>

        <section class="newsletter-inline">
            <h2>Newsletter CRTLMOTO</h2>
            <p>Ricevi offerte, novita e codici sconto direttamente via email.</p>
            <form action="${pageContext.request.contextPath}/newsletter" method="post">
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
