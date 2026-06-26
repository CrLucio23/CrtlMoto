<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header>
    <div class="top-strip">
        <div class="container top-strip-inner">
            <span>Spedizione rapida, offerte esclusive e accessori selezionati</span>
            <span>Iscriviti alla newsletter e ricevi un codice sconto</span>
        </div>
    </div>

    <div class="main-header">
        <div class="container main-header-inner">
            <div class="logo-area">
                <button class="hamburger-btn" type="button" onclick="toggleMobileMenu()" aria-label="Apri menu">☰</button>

                <a href="${pageContext.request.contextPath}/">
                    <img src="${pageContext.request.contextPath}/images/Logo.png"
                         alt="CRTLMOTO Logo"
                         class="site-logo">
                </a>
            </div>

            <form class="main-search" action="${pageContext.request.contextPath}/catalogo" method="get">
                <label class="sr-only" for="header-search">Cerca prodotti</label>
                <input id="header-search" type="text" name="q" placeholder="Cerca prodotti, caschi, ricambi, accessori...">
                <button type="submit">Cerca</button>
            </form>

            <div class="header-icons">
                <c:choose>
                    <c:when test="${empty sessionScope.utente}">
                        <a href="${pageContext.request.contextPath}/login">Login</a>
                        <a href="${pageContext.request.contextPath}/register">Registrati</a>
                        <a href="${pageContext.request.contextPath}/carrello" class="cart-link" aria-label="Carrello">
                            <span class="cart-icon" aria-hidden="true">🛒</span>
                            <span class="cart-text">Carrello</span>
                            <c:if test="${carrelloCount > 0}">
                                <span class="cart-badge"><c:out value="${carrelloCount}" /></span>
                            </c:if>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/profilo">Profilo</a>
                        <c:choose>
                            <c:when test="${sessionScope.utente.ruolo eq 'admin'}">
                                <a href="${pageContext.request.contextPath}/admin/prodotti">Admin</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/garage">Garage</a>
                                <a href="${pageContext.request.contextPath}/i-miei-ordini">Ordini</a>
                                <a href="${pageContext.request.contextPath}/carrello" class="cart-link" aria-label="Carrello">
                                    <span class="cart-icon" aria-hidden="true">🛒</span>
                                    <span class="cart-text">Carrello</span>
                                    <c:if test="${carrelloCount > 0}">
                                        <span class="cart-badge"><c:out value="${carrelloCount}" /></span>
                                    </c:if>
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <nav class="main-nav desktop-nav">
        <div class="container nav-inner">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/catalogo">Tutti i prodotti</a>

            <c:forEach var="c" items="${categorie}">
                <a href="${pageContext.request.contextPath}/catalogo?categoria=${c.idCategoria}">
                    <c:out value="${c.nomeCategoria}" />
                </a>
            </c:forEach>

            <a href="${pageContext.request.contextPath}/catalogo">Offerte</a>
        </div>
    </nav>

    <button id="mobileMenuOverlay" class="mobile-menu-overlay" type="button" onclick="closeMobileMenu()" aria-label="Chiudi menu"></button>

    <nav id="mobileMenu" class="mobile-menu" aria-label="Menu principale">
        <div class="mobile-menu-header">
            <span>Menu</span>
            <button type="button" onclick="closeMobileMenu()" aria-label="Chiudi menu">×</button>
        </div>

        <a href="${pageContext.request.contextPath}/">Home</a>
        <a href="${pageContext.request.contextPath}/catalogo">Tutti i prodotti</a>

        <c:forEach var="c" items="${categorie}">
            <a href="${pageContext.request.contextPath}/catalogo?categoria=${c.idCategoria}">
                <c:out value="${c.nomeCategoria}" />
            </a>
        </c:forEach>

        <c:choose>
            <c:when test="${empty sessionScope.utente}">
                <a href="${pageContext.request.contextPath}/login">Login</a>
                <a href="${pageContext.request.contextPath}/register">Registrati</a>
                <a href="${pageContext.request.contextPath}/carrello">Carrello</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/profilo">Profilo</a>
                <c:choose>
                    <c:when test="${sessionScope.utente.ruolo eq 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin/prodotti">Admin</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/garage">Garage</a>
                        <a href="${pageContext.request.contextPath}/i-miei-ordini">Ordini</a>
                        <a href="${pageContext.request.contextPath}/carrello">Carrello</a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<script>
    function toggleMobileMenu() {
        document.getElementById("mobileMenu").classList.add("open");
        document.getElementById("mobileMenuOverlay").classList.add("show");
        document.body.classList.add("menu-open");
    }

    function closeMobileMenu() {
        document.getElementById("mobileMenu").classList.remove("open");
        document.getElementById("mobileMenuOverlay").classList.remove("show");
        document.body.classList.remove("menu-open");
    }
</script>
