package web.useraction.controller;

import db.operation.StopStem;
import org.htmlparser.util.ParserException;
import webCrawler.Crawler;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(urlPatterns = {"/GetUserQueryServlet"})
public class GetUserQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("in user crawling controller");
        StopStem stopStem = new StopStem();

        String web_url = request.getParameter("web_url");
        Crawler crawler = new Crawler(web_url);
        Vector<String> words = new Vector<String>();
        Vector<String> links = new Vector<String>();
        try {
            words = crawler.extractWords();
            for(int i = 0; i< words.size(); i++){
                String current_word = words.get(i).toLowerCase();
//                System.out.println(current_word);
                words.set(i,current_word);
                if (stopStem.isStopWord(current_word)) {
//                    System.out.println(words.get(i) +"It is a stop word, remove it");
                    words.remove(i);
                    i--;
                }else {
                    String new_word = stopStem.stem(current_word);
//                    System.out.println(new_word);
                    words.set(i,new_word);
//                    System.out.println("Replace original word with its stem");
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
        /* COUNT KEYWORD FREQUENCY
         */
        Map<String ,String> key_words_freq= new HashMap<String, String>();
        for(int i = 0; i<words.size();i++){
            String current_word = words.get(i);
            if(key_words_freq.get(current_word)==null){
                key_words_freq.put(current_word,"1");
            }else{
                String to_update = key_words_freq.get(current_word);
                Integer count = Integer.parseInt(to_update)+1;
                key_words_freq.put(current_word, String.valueOf(count));
            }
        }
        Vector<String> words_key = new Vector<String>();
        Vector<String> words_count = new Vector<String>();
        Iterator hmIterator = key_words_freq.entrySet().iterator();
        while (hmIterator.hasNext()){
            Map.Entry mapElement = (Map.Entry)hmIterator.next();
            words_key.addElement((String) mapElement.getKey());
            words_count.addElement((String) mapElement.getValue());
        }
        String page_title = crawler.getPageTitle();
        Integer page_size = crawler.page_size();
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");

        /* construct your json */
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("words_key", words_key);
        jsonResponse.put("words_count", words_count);
        jsonResponse.put("links_list", links);
        jsonResponse.put("page_url", web_url);
        jsonResponse.put("page_title", page_title );
        jsonResponse.put("page_size",page_size);


        /* send to the client the JSON string */
        response.getWriter().write(jsonResponse.toString());
//        response.setContentType("text/plain");
//        response.getWriter().write(String.valueOf(words));
//        response.getWriter().write(String.valueOf(links));
    }
}