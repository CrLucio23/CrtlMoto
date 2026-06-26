<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Il mio garage - CRTLMOTO</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
    <jsp:include page="header.jsp" />

    <main class="container page-section">
        <h1 class="section-title">Il mio garage</h1>

        <c:if test="${not empty errore}">
        <div class="alert-error"><c:out value="${errore}" /></div>
        </c:if>

        <div class="product-layout">
            <div class="form-box" style="max-width:100%; margin:0;">
                <h1 style="font-size:28px;">${not empty veicolo ? 'Modifica veicolo' : 'Aggiungi veicolo'}</h1>

                <form action="${pageContext.request.contextPath}/garage" method="post">
                    <input type="hidden" name="action" value="${not empty veicolo ? 'update' : 'add'}">
                    <c:if test="${not empty veicolo}">
                    <input type="hidden" name="id" value="${veicolo.idVeicolo}">
                    </c:if>

                    <div class="form-group">
                        <label for="marca">Marca</label>
                        <input id="marca" type="text" name="marca" value="${veicolo.marca}" required>
                    </div>

                    <div class="form-group">
                        <label for="modello">Modello</label>
                        <input id="modello" type="text" name="modello" value="${veicolo.modello}" required>
                    </div>

                    <div class="form-group">
                        <label for="anno">Anno</label>
                        <input id="anno" type="number" name="anno" min="1900" max="2100" value="${veicolo.anno}">
                    </div>

                    <div class="form-group">
                        <label for="cilindrata">Cilindrata</label>
                        <input id="cilindrata" type="text" name="cilindrata" value="${veicolo.cilindrata}">
                    </div>

                    <button type="submit" class="btn btn-primary">${not empty veicolo ? 'Aggiorna veicolo' : 'Aggiungi veicolo'}</button>
                </form>
            </div>

            <div class="form-box" style="max-width:100%; margin:0;">
                <h1 style="font-size:28px;">I miei veicoli</h1>

                <c:choose>
                    <c:when test="${not empty veicoli}">
                        <c:forEach var="v" items="${veicoli}">
                        <div style="padding:14px 0; border-bottom:1px solid #eee;">
                            <strong><c:out value="${v.marca}" /> <c:out value="${v.modello}" /></strong><br>
                            Anno: <c:out value="${empty v.anno ? '-' : v.anno}" /><br>
                            Cilindrata: <c:out value="${empty v.cilindrata ? '-' : v.cilindrata}" />

                            <div style="margin-top:10px; display:flex; gap:10px; flex-wrap:wrap;">
                                <a class="btn btn-dark" href="${pageContext.request.contextPath}/garage?action=edit&id=${v.idVeicolo}">Modifica</a>

                                <form action="${pageContext.request.contextPath}/garage" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${v.idVeicolo}">
                                    <button type="submit"
                                            class="btn btn-primary"
                                            onclick="return confirm('Vuoi eliminare questo veicolo dal garage?')">
                                        Elimina
                                    </button>
                                </form>
                            </div>
                        </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="alert-error">Nessun veicolo presente nel garage.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
</div>

</body>
</html>
