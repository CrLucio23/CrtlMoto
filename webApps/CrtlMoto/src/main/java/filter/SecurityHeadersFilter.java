package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("X-Frame-Options", "DENY");
        resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        resp.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");

        if (req.isSecure()) {
            resp.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        }

        chain.doFilter(request, response);

        HttpSession session = req.getSession(false);
        if (session != null) {
            StringBuilder cookie = new StringBuilder("JSESSIONID=")
                    .append(session.getId())
                    .append("; Path=")
                    .append(req.getContextPath().isEmpty() ? "/" : req.getContextPath())
                    .append("; HttpOnly; SameSite=Lax");

            if (req.isSecure()) {
                cookie.append("; Secure");
            }

            resp.setHeader("Set-Cookie", cookie.toString());
        }
    }
}
