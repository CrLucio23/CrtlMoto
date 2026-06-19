<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Categoria" %>
<%@ page import="utils.ImageUtils" %>

<%
  List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");
  List<Categoria> categorie = (List<Categoria>) request.getAttribute("categorie");
  Object ricerca = request.getAttribute("ricerca");
  Object categoriaSelezionata = request.getAttribute("categoriaSelezionata");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Catalogo - CRTLMOTO</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/favicon.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/base.css">
</head>
<body>

<div class="page-blur-wrapper">
  <jsp:include page="header.jsp" />

  <main class="container page-section">
    <h1 class="section-title">Catalogo</h1>
    <p class="section-subtitle">Scopri accessori, ricambi e abbigliamento per la tua moto.</p>

    <div class="form-box" style="max-width:100%; margin-bottom:30px;">
      <form action="<%= request.getContextPath() %>/catalogo" method="get">
        <div class="form-group">
          <label for="q">Cerca prodotto</label>
          <input type="text" id="q" name="q"
                 value="<%= ricerca != null ? ricerca : "" %>"
                 placeholder="Es. casco, freni, guanti...">
        </div>

        <div class="form-group">
          <label for="categoria">Categoria</label>
          <select id="categoria" name="categoria">
            <option value="">Tutte le categorie</option>
            <%
              if (categorie != null) {
                for (Categoria c : categorie) {
                  String selected = "";
                  if (categoriaSelezionata != null &&
                          categoriaSelezionata.toString().equals(String.valueOf(c.getIdCategoria()))) {
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

        <button type="submit" class="btn btn-primary">Filtra</button>
      </form>
    </div>
    <div class="grid-products">
      <%
        if (prodotti != null && !prodotti.isEmpty()) {
          for (Prodotto p : prodotti) {
            String img = request.getContextPath() + "/images/no-image.png";
            if (p.getImmagini() != null && !p.getImmagini().isEmpty()) {
              img = ImageUtils.resolve(request, p.getImmagini().get(0).getUrlImmagine());
            }
      %>
      <div class="product-card">
        <div class="product-card-image">
          <img src="<%= img %>" alt="<%= p.getNomeProdotto() %>">

          <% if (p.getScontoPercentuale() > 0) { %>
          <span class="product-badge product-badge-sale">-<%= p.getScontoPercentuale() %>%</span>
          <% } else { %>
          <span class="product-badge product-badge-new">TOP</span>
          <% } %>

          <% if (p.getQuantitaMagazzino() > 0 && p.getQuantitaMagazzino() <= 5) { %>
          <span class="product-badge product-badge-stock">Solo <%= p.getQuantitaMagazzino() %></span>
          <% } %>
        </div>

        <div class="product-card-body">
          <h3><%= p.getNomeProdotto() %></h3>
          <p><%= p.getDescrizione() != null ? p.getDescrizione() : "" %></p>

          <div class="price-box">
            <% if (p.getScontoPercentuale() > 0) { %>
            <span class="old-price">€ <%= p.getPrezzoBase() %></span>
            <% } %>
            <span class="new-price">€ <%= p.getPrezzoScontato() %></span>
          </div>

          <div class="product-card-actions">
            <a class="btn btn-dark" href="<%= request.getContextPath() %>/prodotto?id=<%= p.getIdProdotto() %>">
              Vedi prodotto
            </a>
          </div>
        </div>
      </div>
      <%
        }
      } else {
      %>
      <div class="alert-error" style="grid-column:1/-1;">Nessun prodotto trovato.</div>
      <%
        }
      %>
    </div>
  </main>

  <jsp:include page="footer.jsp" />
</div>

</body>
</html>
