package web.useraction.controller;

import org.htmlparser.util.ParserException;
import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import webCrawler.Crawler;
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
            Vector<String> links = crawler.extractLinks();
            mv.addObject("words", words);
            mv.addObject("links", links);
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
