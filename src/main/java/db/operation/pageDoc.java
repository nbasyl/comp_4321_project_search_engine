package db.operation;

import java.util.Vector;

public class pageDoc {

    public String title;
    public String url;
    public String modifiedTime;
    public String pageSize;
    public Vector<String> parentLinks;
    public Vector<String>  childLinks;
    public Vector<String>  words;
    public Vector<String>  frequencies;

    public pageDoc(String title, String url, String modifiedTime, String pageSize, Vector<String> parentLinks,
                   Vector<String> childLinks, Vector<String> words, Vector<String> frequencies){
        this.title = title;
        this.url = url;
        this.modifiedTime = modifiedTime;
        this.pageSize = pageSize;
        this.parentLinks = parentLinks;
        this.childLinks = childLinks;
        this.words = words;
        this.frequencies = frequencies;
    }


}
