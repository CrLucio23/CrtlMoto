<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>I miei ordini - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">I miei ordini</h1>

        <div class="form-box" style="max-width:100%;">
            <c:choose>
                <c:when test="${not empty ordini}">
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
                        <c:forEach var="o" items="${ordini}">
                            <tr style="border-bottom:1px solid #eee;">
                                <td style="padding:12px;">${o.idOrdine}</td>
                                <td style="padding:12px;">${o.dataOrdine}</td>
                                <td style="padding:12px;">&euro; ${o.totaleOrdine}</td>
                                <td style="padding:12px;"><c:out value="${o.statoOrdine}" /></td>
                                <td style="padding:12px;">
                                    <a class="btn btn-dark" href="${pageContext.request.contextPath}/ordine-confermato?id=${o.idOrdine}">
                                        Apri
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="alert-error">Non hai ancora effettuato ordini.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/footer.jsp" />
</div>

</body>
</html>
