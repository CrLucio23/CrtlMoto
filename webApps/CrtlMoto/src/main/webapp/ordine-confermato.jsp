<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ordine confermato - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>
<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <div class="form-box" style="max-width:900px;">
            <c:choose>
                <c:when test="${empty ordine}">
                    <div class="alert-error">Ordine non trovato.</div>
                </c:when>
                <c:otherwise>
                    <h1>Ordine confermato</h1>
                    <p><strong>ID Ordine:</strong> <c:out value="${ordine.idOrdine}" /></p>
                    <p><strong>Data:</strong> <c:out value="${ordine.dataOrdine}" /></p>
                    <p><strong>Totale:</strong> &euro; <c:out value="${ordine.totaleOrdine}" /></p>
                    <p><strong>Stato:</strong> <c:out value="${ordine.statoOrdine}" /></p>
                    <p><strong>Indirizzo spedizione:</strong> <c:out value="${ordine.indirizzoSpedizione}" /></p>

                    <h2 style="margin-top:24px;">Prodotti acquistati</h2>
                    <c:choose>
                        <c:when test="${empty ordine.dettagli}">
                            <p>Nessun dettaglio disponibile.</p>
                        </c:when>
                        <c:otherwise>
                            <table style="width:100%; border-collapse:collapse; margin-top:12px;">
                                <thead>
                                <tr>
                                    <th style="padding:12px; text-align:left;">Prodotto</th>
                                    <th style="padding:12px; text-align:left;">Quantita</th>
                                    <th style="padding:12px; text-align:left;">Prezzo acquisto</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="d" items="${ordine.dettagli}">
                                    <tr>
                                        <td style="padding:12px;"><c:out value="${d.nomeProdottoStorico}" /></td>
                                        <td style="padding:12px;"><c:out value="${d.quantita}" /></td>
                                        <td style="padding:12px;">&euro; <c:out value="${d.prezzoAcquisto}" /></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>

                    <div style="margin-top:20px; display:flex; gap:12px; flex-wrap:wrap;">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/catalogo">Continua lo shopping</a>
                        <a class="btn btn-dark" href="${pageContext.request.contextPath}/i-miei-ordini">Vai ai miei ordini</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
</div>
</body>
</html>
