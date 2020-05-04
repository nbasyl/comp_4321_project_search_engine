package web.useraction.controller;

import db.operation.StopStem;
import db.operation.InvertedIndex;
import org.rocksdb.RocksDB;
import org.rocksdb.RocksDBException;
import org.htmlparser.util.ParserException;
import java.util.Set;

import java.io.FileWriter;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.json.JSONObject;
import webCrawler.Crawler;

import static java.lang.Integer.parseInt;

@WebServlet(urlPatterns = {"/GetUserSearchQueryServlet"})
public class GetUserSearchQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected Vector<String> returnWords(StopStem stopStem,Vector<String> words) throws ServletException, IOException{
        for(int i = 0; i< words.size(); i++){
            String current_word = words.get(i).toLowerCase();
            words.set(i,current_word);
            if (current_word.equals("")){
                System.out.println("empty string");
                words.remove(i);
                i--;
                continue;
            }
            if (stopStem.isStopWord(current_word)) {
                words.remove(i);
                i--;
            }else{
                String new_word = stopStem.stem(current_word);
                words.set(i,new_word);
            }
        }
        return words;
    }
    protected int check_decimal (int number){
        int i = 1;
        while(number/10>0){
            number = number/10;
            i++;
        }
        return i;
    }
    protected Vector<Integer> process_docs_id(String db_string) throws ServletException, IOException{
        Vector<Integer> docs_id = new Vector<Integer>();
        int i = 0;
        String current_doc_id = "doc"+Integer.toString(i);
        try{
            while(db_string.indexOf("doc")>=0){
                if(db_string.indexOf(current_doc_id)>=0){
                    try {
                        System.out.println(current_doc_id);
                        db_string = db_string.substring(db_string.indexOf(current_doc_id) + (3+check_decimal(i)));
                        System.out.println(db_string);
                        current_doc_id = current_doc_id.substring(current_doc_id.indexOf("doc")+3);
                        docs_id.addElement(Integer.parseInt(current_doc_id));
                    } catch (Exception e){
                        System.out.println(e);
                    }
                }
                i++;
                current_doc_id = "doc"+Integer.toString(i);
            }} catch (Exception e){
            System.out.println(e);
        }
        return docs_id;
    }
    protected Map<String, Vector<Integer>> cluster_key_words_docs_id(Vector<String> clean_words, InvertedIndex wordIndex) throws ServletException, IOException, RocksDBException {
        Map<String ,Vector<Integer>> key_word_docs_id = new HashMap<String, Vector<Integer>>();
        for(int i = 0; i < clean_words.size(); i ++){
            try {
                byte[] key_word = clean_words.get(i).getBytes();
                String index_word_string = new String(wordIndex.getDB().get(key_word));
                Vector<Integer> docs_id = new Vector<Integer>();
                docs_id = process_docs_id(index_word_string);
                key_word_docs_id.put(clean_words.get(i), docs_id);
            }catch (Exception e){
                System.out.println("Bang ah");
            }
        }
        return  key_word_docs_id;
    }
    protected int get_document_frequency(String word){
        int i = 0;
        int document_frequency = 0;
        while(word.indexOf("doc")!=-1){
            if(word.indexOf("doc"+i)!=-1){
                try {
                    word = word.substring(word.indexOf("doc" + i) + 4, word.length() - 1);
                    document_frequency++;
                } catch (Exception e){
                    System.out.println("System broken");
                }
            }
            i++;
            document_frequency++;
        }
        return document_frequency;
    }
//    protected int[] terms_weight_calculation(int doc_id, InvertedIndex wordIndexDocs) throws RocksDBException {
//        String currentDoc = new String(wordIndexDocs.getDB().get(String.valueOf(doc_id).getBytes()));
//        String words = currentDoc.substring(currentDoc.indexOf("words") + 6, currentDoc.indexOf("frequencies") - 2);
//        String freq = currentDoc.substring(currentDoc.indexOf("frequencies") + 12, currentDoc.length() - 1);
//        String[] arrWords = words.split(",");
//        String[] arrFreq = freq.split(",");
//    }
//    protected int[][] docs_terms_matrix(){
//
//    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("in user search controller");
        StopStem stopStem = new StopStem();
        Vector<String> words = new Vector<String>(Arrays.asList(request.getParameter("search_query").split(" ")));    ;
        Vector<String> clean_words = returnWords(stopStem, words);

        try{
            //Open RocksDB library
            RocksDB.loadLibrary();

//            String path = "/Users/tayingcheng/Desktop/2019-2020Spring/Comp4321/project/comp_4321_project_search_engine/src/main/java/db/data/docs";
//            String path2 = "/Users/tayingcheng/Desktop/2019-2020Spring/Comp4321/project/comp_4321_project_search_engine/src/main/java/db/data/words";

            String path = "/Users/seanliu/Desktop/comp_4321_project/src/main/java/db/data/words";
            String path2 = "/Users/seanliu/Desktop/comp_4321_project/src/main/java/db/data/docs";
            InvertedIndex wordIndex = new InvertedIndex(path);
            InvertedIndex wordIndexDocs = new InvertedIndex(path2);
            Map<String ,Vector<Integer>> search_query_docs_result = cluster_key_words_docs_id(clean_words, wordIndex);
            Iterator map_iterator = search_query_docs_result.entrySet().iterator();
            Set<Integer> docs_id_set = new TreeSet<Integer>();
            while (map_iterator.hasNext()){
                try {
                    Map.Entry mapDocsId = (Map.Entry) map_iterator.next();
                    System.out.println(mapDocsId.getKey());
                    System.out.println(mapDocsId.getValue());
                    docs_id_set.addAll((Collection<? extends Integer>) mapDocsId.getValue());
                }catch (Exception e){
                    System.out.println("oooops");
                }
            }
            System.out.println(docs_id_set);
//            System.out.println(search_query_docs_result.get(clean_words.get(0)));
//            System.out.println(new String(wordIndexDocs.getDB().get("0".getBytes())));

        }
        catch(RocksDBException e){
            System.out.println("pull up! stooooooopid");
        }
        //test comment
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");
        /* construct your json */
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success_message", "success");
        /* send to the client the JSON string */
        response.getWriter().write(jsonResponse.toString());
    }
}
