package web.useraction.controller;

import db.operation.StopStem;
import org.htmlparser.util.ParserException;
import webCrawler.Crawler;
import java.io.IOException;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(urlPatterns = {"/GetUserQueryServlet"})
public class GetUserQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("in user crawling controller");
        StopStem stopStem = new StopStem();

        String web_url = request.getParameter("web_url");
        Crawler crawler = new Crawler(web_url);
        Vector<String> words = null;
        Vector<String> links = null;
        try {
            words = crawler.extractWords();
            for(int i = 0; i<words.size();i++){
                if (stopStem.isStopWord(words.get(i))) {
                    System.out.println("It is a stop word, remove it");
                    words.remove(i);
                }else {
                    words.set(i,stopStem.stem(words.get(i)));
                    System.out.println("Replace original word with its stem");
                }
            }
        } catch (ParserException e) {
            e.printStackTrace();
        }
        try {
            links = crawler.extractLinks();
        } catch (ParserException e) {
            e.printStackTrace();
        }
        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(words));
        response.getWriter().write(String.valueOf(links));
    }
}