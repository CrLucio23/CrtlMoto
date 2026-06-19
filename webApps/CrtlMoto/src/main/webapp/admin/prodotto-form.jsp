<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Categoria" %>
<%@ page import="model.Marca" %>

<%
  Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
  List<Categoria> categorie = (List<Categoria>) request.getAttribute("categorie");
  List<Marca> marche = (List<Marca>) request.getAttribute("marche");
  boolean modifica = (prodotto != null);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><%= modifica ? "Modifica prodotto" : "Nuovo prodotto" %> - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="/header.jsp" />

  <main class="container page-section">
    <div class="form-box" style="max-width:900px;">
      <h1><%= modifica ? "Modifica prodotto" : "Nuovo prodotto" %></h1>

      <% if (request.getAttribute("errore") != null) { %>
      <div class="alert-error"><%= request.getAttribute("errore") %></div>
      <% } %>

      <form action="<%= request.getContextPath() %>/admin/prodotti" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="<%= modifica ? "update" : "save" %>">
        <% if (modifica) { %>
        <input type="hidden" name="id" value="<%= prodotto.getIdProdotto() %>">
        <% } %>

        <div class="form-group">
          <label>Nome prodotto</label>
          <input type="text" name="nomeProdotto" value="<%= modifica ? prodotto.getNomeProdotto() : "" %>" required>
        </div>

        <div class="form-group">
          <label>Descrizione</label>
          <textarea name="descrizione" rows="5"><%= modifica && prodotto.getDescrizione() != null ? prodotto.getDescrizione() : "" %></textarea>
        </div>

        <div class="form-group">
          <label>Prezzo base</label>
          <input type="text" name="prezzoBase" value="<%= modifica ? prodotto.getPrezzoBase() : "" %>" required>
        </div>

        <div class="form-group">
          <label>Sconto %</label>
          <input type="number" name="scontoPercentuale" value="<%= modifica ? prodotto.getScontoPercentuale() : 0 %>">
        </div>

        <div class="form-group">
          <label>Quantità magazzino</label>
          <input type="number" name="quantitaMagazzino" value="<%= modifica ? prodotto.getQuantitaMagazzino() : 0 %>">
        </div>

        <div class="form-group">
          <label>Taglia</label>
          <input type="text" name="taglia" value="<%= modifica && prodotto.getTaglia() != null ? prodotto.getTaglia() : "" %>">
        </div>

        <div class="form-group">
          <label>Colore</label>
          <input type="text" name="colore" value="<%= modifica && prodotto.getColore() != null ? prodotto.getColore() : "" %>">
        </div>

        <div class="form-group">
          <label>Compatibilità</label>
          <textarea name="compatibilita" rows="3"><%= modifica && prodotto.getCompatibilita() != null ? prodotto.getCompatibilita() : "" %></textarea>
        </div>

        <div class="form-group">
          <label>Foto prodotto</label>
          <input type="file" name="immagine" accept="image/png,image/jpeg,image/webp,image/gif">
        </div>

        <div class="form-group">
          <label>Categoria</label>
          <select name="idCategoria">
            <option value="">Seleziona categoria</option>
            <%
              if (categorie != null) {
                for (Categoria c : categorie) {
                  String selected = "";
                  if (modifica && prodotto.getIdCategoria() != null && prodotto.getIdCategoria() == c.getIdCategoria()) {
                    selected = "selected";
                  }
            %>
            <option value="<%= c.getIdCategoria() %>" <%= selected %>><%= c.getNomeCategoria() %></option>
            <%
                }
              }
            %>
          </select>
        </div>

        <div class="form-group">
          <label>Marca</label>
          <select name="idMarca">
            <option value="">Seleziona marca</option>
            <%
              if (marche != null) {
                for (Marca m : marche) {
                  String selected = "";
                  if (modifica && prodotto.getIdMarca() != null && prodotto.getIdMarca() == m.getIdMarca()) {
                    selected = "selected";
                  }
            %>
            <option value="<%= m.getIdMarca() %>" <%= selected %>><%= m.getNomeMarca() %></option>
            <%
                }
              }
            %>
          </select>
        </div>

        <button type="submit" class="btn btn-primary"><%= modifica ? "Aggiorna prodotto" : "Salva prodotto" %></button>
      </form>
    </div>
  </main>

  <jsp:include page="/footer.jsp" />
</div>

</body>
</html>
