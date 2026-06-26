<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Categoria" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.DettaglioCarrello" %>
<%@ page import="java.util.List" %>

<%
    Utente utenteHeader = (Utente) session.getAttribute("utente");
    List<Categoria> categorieHeader = (List<Categoria>) request.getAttribute("categorie");

    Integer carrelloCount = (Integer) request.getAttribute("carrelloCount");
    if (carrelloCount == null) {
        carrelloCount = 0;
        Carrello guestCartHeader = (Carrello) session.getAttribute("guestCart");
        if (guestCartHeader != null && guestCartHeader.getArticoli() != null) {
            for (DettaglioCarrello dettaglioHeader : guestCartHeader.getArticoli()) {
                carrelloCount += dettaglioHeader.getQuantita();
            }
        }
    }
%>
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
                <button class="hamburger-btn" type="button" onclick="toggleMobileMenu()">☰</button>

                <a href="<%= request.getContextPath() %>/">
                    <img src="<%= request.getContextPath() %>/images/Logo.png"
                         alt="CRTLMOTO Logo"
                         class="site-logo">
                </a>
            </div>

            <form class="main-search" action="<%= request.getContextPath() %>/catalogo" method="get">
                <input type="text" name="q" placeholder="Cerca prodotti, caschi, ricambi, accessori...">
                <button type="submit">Cerca</button>
            </form>

            <div class="header-icons">
                <% if (utenteHeader == null) { %>
                <a href="<%= request.getContextPath() %>/login">Login</a>
                <a href="<%= request.getContextPath() %>/register">Registrati</a>

                <a href="<%= request.getContextPath() %>/carrello" class="cart-link" aria-label="Carrello">
                    <span class="cart-icon">🛒</span>
                    <span class="cart-text">Carrello</span>
                    <% if (carrelloCount > 0) { %>
                    <span class="cart-badge"><%= carrelloCount %></span>
                    <% } %>
                </a>
                <% } else { %>
                <a href="<%= request.getContextPath() %>/profilo">Profilo</a>
                <% if (!"admin".equalsIgnoreCase(utenteHeader.getRuolo())){ %>
                <a href="<%= request.getContextPath() %>/garage">Garage</a>
                <a href="<%= request.getContextPath() %>/i-miei-ordini">Ordini</a>

                <a href="<%= request.getContextPath() %>/carrello" class="cart-link" aria-label="Carrello">
                    <span class="cart-icon">🛒</span>
                    <span class="cart-text">Carrello</span>
                    <% if (carrelloCount > 0) { %>
                    <span class="cart-badge"><%= carrelloCount %></span>
                    <% } %>
                </a>
                <% } %>
                <% if ("admin".equalsIgnoreCase(utenteHeader.getRuolo())) { %>
                <a href="<%= request.getContextPath() %>/admin/prodotti">Admin</a>
                <% } %>

                <a href="<%= request.getContextPath() %>/logout">Logout</a>
                <% } %>
            </div>
        </div>
    </div>

    <nav class="main-nav desktop-nav">
        <div class="container nav-inner">
            <a href="<%= request.getContextPath() %>/">Home</a>
            <a href="<%= request.getContextPath() %>/catalogo">Tutti i prodotti</a>

            <%
                if (categorieHeader != null) {
                    for (Categoria c : categorieHeader) {
            %>
            <a href="<%= request.getContextPath() %>/catalogo?categoria=<%= c.getIdCategoria() %>">
                <%= c.getNomeCategoria() %>
            </a>
            <%
                    }
                }
            %>

            <a href="<%= request.getContextPath() %>/catalogo">Offerte</a>
        </div>
    </nav>

    <div id="mobileMenuOverlay" class="mobile-menu-overlay" onclick="closeMobileMenu()"></div>

    <nav id="mobileMenu" class="mobile-menu">
        <div class="mobile-menu-header">
            <span>Menu</span>
            <button type="button" onclick="closeMobileMenu()">×</button>
        </div>

        <a href="<%= request.getContextPath() %>/">Home</a>
        <a href="<%= request.getContextPath() %>/catalogo">Tutti i prodotti</a>

        <%
            if (categorieHeader != null) {
                for (Categoria c : categorieHeader) {
        %>
        <a href="<%= request.getContextPath() %>/catalogo?categoria=<%= c.getIdCategoria() %>">
            <%= c.getNomeCategoria() %>
        </a>
        <%
                }
            }
        %>

        <% if (utenteHeader == null) { %>
        <a href="<%= request.getContextPath() %>/login">Login</a>
        <a href="<%= request.getContextPath() %>/register">Registrati</a>
        <a href="<%= request.getContextPath() %>/carrello">Carrello</a>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/profilo">Profilo</a>
        <% if (!"admin".equalsIgnoreCase(utenteHeader.getRuolo())) { %>
        <a href="<%= request.getContextPath() %>/garage">Garage</a>
        <a href="<%= request.getContextPath() %>/i-miei-ordini">Ordini</a>
        <a href="<%= request.getContextPath() %>/carrello">Carrello</a>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/admin/prodotti">Admin</a>
        <% } %>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
        <% } %>
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
