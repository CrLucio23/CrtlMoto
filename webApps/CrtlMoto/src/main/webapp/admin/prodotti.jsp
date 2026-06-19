<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>

<%
    List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Prodotti - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Admin - Prodotti</h1>

        <div style="margin-bottom:20px;">
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/admin/prodotti?action=new">Nuovo prodotto</a>
            <a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/ordini">Gestisci ordini</a>
        </div>

        <div class="form-box" style="max-width:100%;">
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                <tr style="text-align:left; border-bottom:1px solid #ddd;">
                    <th style="padding:12px;">ID</th>
                    <th style="padding:12px;">Nome</th>
                    <th style="padding:12px;">Prezzo</th>
                    <th style="padding:12px;">Sconto</th>
                    <th style="padding:12px;">Magazzino</th>
                    <th style="padding:12px;">Azioni</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (prodotti != null) {
                        for (Prodotto p : prodotti) {
                %>
                <tr style="border-bottom:1px solid #eee;">
                    <td style="padding:12px;"><%= p.getIdProdotto() %></td>
                    <td style="padding:12px;"><%= p.getNomeProdotto() %></td>
                    <td style="padding:12px;">€ <%= p.getPrezzoBase() %></td>
                    <td style="padding:12px;"><%= p.getScontoPercentuale() %>%</td>
                    <td style="padding:12px;"><%= p.getQuantitaMagazzino() %></td>
                    <td style="padding:12px; display:flex; gap:8px; flex-wrap:wrap;">
                        <a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/prodotti?action=edit&id=<%= p.getIdProdotto() %>">Modifica</a>
                        <a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/immagini-prodotto?idProdotto=<%= p.getIdProdotto() %>">Immagini</a>

                        <form action="<%= request.getContextPath() %>/admin/prodotti" method="post">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                            <button type="submit"
                                    class="btn btn-primary"
                                    onclick="return confirm('ATTENZIONE: elimini definitivamente il prodotto. Continuare?')">
                                Elimina
                            </button>                        </form>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

</body>
</html>