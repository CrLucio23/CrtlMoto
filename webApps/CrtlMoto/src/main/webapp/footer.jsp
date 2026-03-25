<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="site-footer">
    <div class="container footer-inner">
        <div>
            <h3>CRTLMOTO</h3>
            <p>Il tuo shop online per accessori, ricambi e abbigliamento moto.</p>
        </div>

        <div>
            <h4>Link utili</h4>
            <ul>
                <li><a href="<%= request.getContextPath() %>/catalogo">Catalogo</a></li>
                <li><a href="<%= request.getContextPath() %>/profilo">Profilo</a></li>
                <li><a href="<%= request.getContextPath() %>/garage">Il mio garage</a></li>
                <li><a href="<%= request.getContextPath() %>/i-miei-ordini">Ordini</a></li>
            </ul>
        </div>

        <div>
            <h4>Newsletter</h4>
            <p>Ricevi offerte e codici sconto esclusivi.</p>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="container">
            <p>&copy; 2026 CRTLMOTO - Tutti i diritti riservati</p>
        </div>
    </div>
</footer>