<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Ordini - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
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
                <c:forEach var="o" items="${ordini}">
                    <tr style="border-bottom:1px solid #eee;">
                        <td style="padding:12px;">${o.idOrdine}</td>
                        <td style="padding:12px;">${o.idUtente}</td>
                        <td style="padding:12px;">${o.dataOrdine}</td>
                        <td style="padding:12px;">&euro; ${o.totaleOrdine}</td>
                        <td style="padding:12px;"><c:out value="${o.statoOrdine}" /></td>
                        <td style="padding:12px;">
                            <form action="${pageContext.request.contextPath}/admin/ordini" method="post" style="display:flex; gap:8px; flex-wrap:wrap;">
                                <input type="hidden" name="idOrdine" value="${o.idOrdine}">

                                <select name="statoOrdine">
                                    <option value="in_elaborazione" ${o.statoOrdine == 'in_elaborazione' ? 'selected' : ''}>In elaborazione</option>
                                    <option value="spedito" ${o.statoOrdine == 'spedito' ? 'selected' : ''}>Spedito</option>
                                    <option value="consegnato" ${o.statoOrdine == 'consegnato' ? 'selected' : ''}>Consegnato</option>
                                    <option value="annullato" ${o.statoOrdine == 'annullato' ? 'selected' : ''}>Annullato</option>
                                </select>

                                <button type="submit" class="btn btn-primary">Salva</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

</body>
</html>
