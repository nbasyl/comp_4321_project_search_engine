package webCrawler;

import java.io.IOException;
import java.util.Vector;
import org.htmlparser.beans.StringBean;
import org.htmlparser.util.ParserException;
import java.util.StringTokenizer;
import org.htmlparser.beans.LinkBean;
import java.net.URL;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.util.HashMap;

public class Crawler
{
    private String url;
    public Crawler(String _url)
    {
        url = _url;
    }
    public String getUrl()
    {
        return url;
    }
    public String getPageTitle() throws IOException {
    Document doc = Jsoup.connect(getUrl()).get();
    Elements title = doc.select("title");
    return title.text();
    }
    public String get_last_modified_time() throws IOException {
        Document doc = Jsoup.connect(getUrl()).get();
        Elements modified_time = doc.select("span.pull-right");
        if (modified_time.text().isEmpty()){
            return "N/A";
        }
        return modified_time.text();
    }
    public int page_size()throws IOException {
        Document doc = Jsoup.connect(getUrl()).get();
        return doc.text().length();
    }
    public Vector<String> extractWords() throws ParserException
    {
        // extract words in url and return them
        // use StringTokenizer to tokenize the result from StringBean
        // ADD YOUR CODES HERE
        Vector<String> result = new Vector<String>();
        StringBean bean = new StringBean();
        bean.setURL(url);
        bean.setLinks(false);
        String contents = bean.getStrings();
        StringTokenizer st = new StringTokenizer(contents);
        while (st.hasMoreTokens()) {
            result.add(st.nextToken());
        }
        return result;

    }
    public Vector<String> extractLinks() throws ParserException

    {
        // extract links in url and return them
        // ADD YOUR CODES HERE
        Vector<String> result = new Vector<String>();
        LinkBean bean = new LinkBean();
        bean.setURL(url);
        URL[] urls = bean.getLinks();
        for (URL s : urls) {
            result.add(s.toString());
        }
        return result;

    }
}