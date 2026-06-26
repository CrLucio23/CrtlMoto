<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Veicolo" %>

<%
    List<Veicolo> veicoli = (List<Veicolo>) request.getAttribute("veicoli");
    Veicolo veicolo = (Veicolo) request.getAttribute("veicolo");
    boolean modifica = (veicolo != null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Il mio garage - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Il mio garage</h1>

        <% if (request.getAttribute("errore") != null) { %>
        <div class="alert-error"><%= request.getAttribute("errore") %></div>
        <% } %>

        <div class="product-layout">
            <div class="form-box" style="max-width:100%; margin:0;">
                <h1 style="font-size:28px;"><%= modifica ? "Modifica veicolo" : "Aggiungi veicolo" %></h1>

                <form action="<%= request.getContextPath() %>/garage" method="post">
                    <input type="hidden" name="action" value="<%= modifica ? "update" : "add" %>">
                    <% if (modifica) { %>
                    <input type="hidden" name="id" value="<%= veicolo.getIdVeicolo() %>">
                    <% } %>

                    <div class="form-group">
                        <label for="marca">Marca</label>
                        <input id="marca" type="text" name="marca" value="<%= modifica ? veicolo.getMarca() : "" %>" required>
                    </div>

                    <div class="form-group">
                        <label for="modello">Modello</label>
                        <input id="modello" type="text" name="modello" value="<%= modifica ? veicolo.getModello() : "" %>" required>
                    </div>

                    <div class="form-group">
                        <label for="anno">Anno</label>
                        <input id="anno" type="number" name="anno" min="1900" max="2100" value="<%= modifica && veicolo.getAnno() != null ? veicolo.getAnno() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="cilindrata">Cilindrata</label>
                        <input id="cilindrata" type="text" name="cilindrata" value="<%= modifica && veicolo.getCilindrata() != null ? veicolo.getCilindrata() : "" %>">
                    </div>

                    <button type="submit" class="btn btn-primary"><%= modifica ? "Aggiorna veicolo" : "Aggiungi veicolo" %></button>
                </form>
            </div>

            <div class="form-box" style="max-width:100%; margin:0;">
                <h1 style="font-size:28px;">I miei veicoli</h1>

                <%
                    if (veicoli != null && !veicoli.isEmpty()) {
                        for (Veicolo v : veicoli) {
                %>
                <div style="padding:14px 0; border-bottom:1px solid #eee;">
                    <strong><%= v.getMarca() %> <%= v.getModello() %></strong><br>
                    Anno: <%= v.getAnno() != null ? v.getAnno() : "-" %><br>
                    Cilindrata: <%= v.getCilindrata() != null ? v.getCilindrata() : "-" %>

                    <div style="margin-top:10px; display:flex; gap:10px; flex-wrap:wrap;">
                        <a class="btn btn-dark" href="<%= request.getContextPath() %>/garage?action=edit&id=<%= v.getIdVeicolo() %>">Modifica</a>

                        <form action="<%= request.getContextPath() %>/garage" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= v.getIdVeicolo() %>">
                            <button type="submit"
                                    class="btn btn-primary"
                                    onclick="return confirm('Vuoi eliminare questo veicolo dal garage?')">
                                Elimina
                            </button>                        </form>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="alert-error">Nessun veicolo presente nel garage.</div>
                <%
                    }
                %>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
</div>

</body>
</html>
