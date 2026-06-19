<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ordine" %>

<%
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("ordini");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>I miei ordini - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">I miei ordini</h1>

        <div class="form-box" style="max-width:100%;">
            <%
                if (ordini != null && !ordini.isEmpty()) {
            %>
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                <tr style="text-align:left; border-bottom:1px solid #ddd;">
                    <th style="padding:12px;">ID</th>
                    <th style="padding:12px;">Data</th>
                    <th style="padding:12px;">Totale</th>
                    <th style="padding:12px;">Stato</th>
                    <th style="padding:12px;">Dettagli</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (Ordine o : ordini) {
                %>
                <tr style="border-bottom:1px solid #eee;">
                    <td style="padding:12px;"><%= o.getIdOrdine() %></td>
                    <td style="padding:12px;"><%= o.getDataOrdine() %></td>
                    <td style="padding:12px;">€ <%= o.getTotaleOrdine() %></td>
                    <td style="padding:12px;"><%= o.getStatoOrdine() %></td>
                    <td style="padding:12px;">
                        <a class="btn btn-dark" href="<%= request.getContextPath() %>/ordine-confermato?id=<%= o.getIdOrdine() %>">
                            Apri
                        </a>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <%
            } else {
            %>
            <div class="alert-error">Non hai ancora effettuato ordini.</div>
            <%
                }
            %>
        </div>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

</body>
</html>