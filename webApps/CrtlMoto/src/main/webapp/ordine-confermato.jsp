<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Ordine" %>

<%
    Ordine ordine = (Ordine) request.getAttribute("ordine");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ordine confermato - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <div class="form-box">
            <h1>Ordine confermato</h1>

            <% if (ordine == null) { %>
            <div class="alert-error">Ordine non trovato.</div>
            <% } else { %>
            <div class="alert-success">Il tuo ordine è stato completato con successo.</div>

            <p><strong>ID Ordine:</strong> <%= ordine.getIdOrdine() %></p>
            <p><strong>Data:</strong> <%= ordine.getDataOrdine() %></p>
            <p><strong>Totale:</strong> € <%= ordine.getTotaleOrdine() %></p>
            <p><strong>Stato:</strong> <%= ordine.getStatoOrdine() %></p>
            <p><strong>Indirizzo spedizione:</strong> <%= ordine.getIndirizzoSpedizione() %></p>

            <div style="margin-top:20px; display:flex; gap:12px; flex-wrap:wrap;">
                <a class="btn btn-primary" href="<%= request.getContextPath() %>/catalogo">Continua lo shopping</a>
                <a class="btn btn-dark" href="<%= request.getContextPath() %>/i-miei-ordini">Vai ai miei ordini</a>
            </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
</div>

</body>
</html>