<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.ImmagineProdotto" %>

<%
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    List<ImmagineProdotto> immagini = (List<ImmagineProdotto>) request.getAttribute("immagini");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Immagini prodotto - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Immagini prodotto</h1>
        <p class="section-subtitle">
            <strong>Prodotto:</strong> <%= prodotto != null ? prodotto.getNomeProdotto() : "-" %>
        </p>

        <div class="form-box" style="max-width:900px;">
            <h1 style="font-size:28px;">Aggiungi immagine</h1>

            <form action="<%= request.getContextPath() %>/admin/immagini-prodotto" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="idProdotto" value="<%= prodotto != null ? prodotto.getIdProdotto() : "" %>">

                <div class="form-group">
                    <label>URL immagine</label>
                    <input type="text" name="urlImmagine" required>
                </div>

                <div class="form-group">
                    <label>
                        <input type="checkbox" name="principale" value="true">
                        Imposta come immagine principale
                    </label>
                </div>

                <button type="submit" class="btn btn-primary">Aggiungi immagine</button>
            </form>
        </div>

        <div class="grid-products">
            <%
                if (immagini != null && !immagini.isEmpty()) {
                    for (ImmagineProdotto img : immagini) {
            %>
            <div class="product-card">
                <div class="product-card-image">
                    <img src="<%= img.getUrlImmagine() %>" alt="Immagine prodotto">
                </div>

                <div class="product-card-body">
                    <% if (img.isPrincipale()) { %>
                    <span class="badge-discount">Principale</span>
                    <% } %>

                    <div style="display:flex; gap:8px; flex-wrap:wrap;">
                        <form action="<%= request.getContextPath() %>/admin/immagini-prodotto" method="post">
                            <input type="hidden" name="action" value="setMain">
                            <input type="hidden" name="idImmagine" value="<%= img.getIdImmagine() %>">
                            <input type="hidden" name="idProdotto" value="<%= img.getIdProdotto() %>">
                            <button type="submit" class="btn btn-dark">Rendi principale</button>
                        </form>

                        <form action="<%= request.getContextPath() %>/admin/immagini-prodotto" method="post">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="idImmagine" value="<%= img.getIdImmagine() %>">
                            <input type="hidden" name="idProdotto" value="<%= img.getIdProdotto() %>">
                            <button type="submit"
                                    class="btn btn-primary"
                                    onclick="return confirm('Eliminare questa immagine?')">
                                Elimina
                            </button>                        </form>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="alert-error" style="grid-column:1/-1;">Nessuna immagine associata al prodotto.</div>
            <%
                }
            %>
        </div>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

</body>
</html>