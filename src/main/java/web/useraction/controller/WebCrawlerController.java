package web.useraction.controller;

import org.htmlparser.util.ParserException;
import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import web.useraction.Crawler.Crawler;
import java.util.Vector;


@Controller
public class WebCrawlerController {
    String message = "start crawling from HKUST CSE Department website";

    @RequestMapping("/crawling")
    public ModelAndView crawlWeb()
    {
        ModelAndView mv = new ModelAndView("webcrawler");
        try
        {
            Crawler crawler = new Crawler("http://www.cs.ust.hk/~dlee/4321/");


            Vector<String> words = crawler.extractWords();

//            System.out.println("Words in "+crawler.getUrl()+":");
//            for(int i = 0; i < words.size(); i++)
//                System.out.print(words.get(i)+" ");
//            System.out.println("\n\n");


            Vector<String> links = crawler.extractLinks();
//            System.out.println("Links in "+crawler.getUrl()+":");
//            for(int i = 0; i < links.size(); i++)
//                System.out.println(links.get(i));
//            System.out.println("");
            mv.addObject("words", words);
            mv.addObject("links", links);
            System.out.println(mv);
            return mv;

        }
        catch (ParserException e) {
            e.printStackTrace();
            mv.addObject("Words","Errors");
            System.out.println(mv);
            return mv;
        }
    }
}
