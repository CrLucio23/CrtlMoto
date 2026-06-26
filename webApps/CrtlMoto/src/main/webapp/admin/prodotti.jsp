<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Prodotti - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="/header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Admin - Prodotti</h1>

        <div style="margin-bottom:20px;">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/prodotti?action=new">Nuovo prodotto</a>
            <a class="btn btn-dark" href="${pageContext.request.contextPath}/admin/ordini">Gestisci ordini</a>
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
                    <th style="padding:12px;">Stato</th>
                    <th style="padding:12px;">Azioni</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${prodotti}">
                    <tr style="border-bottom:1px solid #eee;">
                        <td style="padding:12px;"><c:out value="${p.idProdotto}" /></td>
                        <td style="padding:12px;"><c:out value="${p.nomeProdotto}" /></td>
                        <td style="padding:12px;">&euro; <c:out value="${p.prezzoBase}" /></td>
                        <td style="padding:12px;"><c:out value="${p.scontoPercentuale}" />%</td>
                        <td style="padding:12px;"><c:out value="${p.quantitaMagazzino}" /></td>
                        <td style="padding:12px;">
                            <c:choose>
                                <c:when test="${p.attivo}">Attivo</c:when>
                                <c:otherwise>Disattivato</c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding:12px; display:flex; gap:8px; flex-wrap:wrap;">
                            <a class="btn btn-dark" href="${pageContext.request.contextPath}/admin/prodotti?action=edit&id=${p.idProdotto}">Modifica</a>
                            <a class="btn btn-dark" href="${pageContext.request.contextPath}/admin/immagini-prodotto?idProdotto=${p.idProdotto}">Immagini</a>

                            <c:if test="${p.attivo}">
                                <form action="${pageContext.request.contextPath}/admin/prodotti" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${p.idProdotto}">
                                    <button type="submit"
                                            class="btn btn-primary"
                                            onclick="return confirm('Il prodotto verra disattivato e nascosto dal catalogo. Continuare?')">
                                        Disattiva
                                    </button>
                                </form>
                            </c:if>
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
