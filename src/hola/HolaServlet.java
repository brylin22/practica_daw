package hola;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet básico de prueba para despliegue en Tomcat 10
 */
@WebServlet("/hola")
public class HolaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        out.println("<html>");
        out.println("<head><title>Hola Servlet</title></head>");
        out.println("<body>");
        out.println("<h1>¡Despliegue automatizado funcionando correctamente!</h1>");
        out.println("</body>");
        out.println("</html>");
    }
}

