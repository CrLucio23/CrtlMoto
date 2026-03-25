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
    <title>Admin Ordini - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/images/favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Admin - Ordini</h1>

        <div class="form-box" style="max-width:100%;">
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                <tr style="text-align:left; border-bottom:1px solid #ddd;">
                    <th style="padding:12px;">ID</th>
                    <th style="padding:12px;">Utente</th>
                    <th style="padding:12px;">Data</th>
                    <th style="padding:12px;">Totale</th>
                    <th style="padding:12px;">Stato</th>
                    <th style="padding:12px;">Aggiorna</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (ordini != null) {
                        for (Ordine o : ordini) {
                %>
                <tr style="border-bottom:1px solid #eee;">
                    <td style="padding:12px;"><%= o.getIdOrdine() %></td>
                    <td style="padding:12px;"><%= o.getIdUtente() %></td>
                    <td style="padding:12px;"><%= o.getDataOrdine() %></td>
                    <td style="padding:12px;">€ <%= o.getTotaleOrdine() %></td>
                    <td style="padding:12px;"><%= o.getStatoOrdine() %></td>
                    <td style="padding:12px;">
                        <form action="<%= request.getContextPath() %>/admin/ordini" method="post" style="display:flex; gap:8px; flex-wrap:wrap;">
                            <input type="hidden" name="idOrdine" value="<%= o.getIdOrdine() %>">

                            <select name="statoOrdine">
                                <option value="in_elaborazione" <%= "in_elaborazione".equals(o.getStatoOrdine()) ? "selected" : "" %>>In elaborazione</option>
                                <option value="spedito" <%= "spedito".equals(o.getStatoOrdine()) ? "selected" : "" %>>Spedito</option>
                                <option value="consegnato" <%= "consegnato".equals(o.getStatoOrdine()) ? "selected" : "" %>>Consegnato</option>
                                <option value="annullato" <%= "annullato".equals(o.getStatoOrdine()) ? "selected" : "" %>>Annullato</option>
                            </select>

                            <button type="submit" class="btn btn-primary">Salva</button>
                        </form>
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