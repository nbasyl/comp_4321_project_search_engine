package db.operation;

import org.rocksdb.RocksDB;
import org.rocksdb.Options;
import org.rocksdb.RocksDBException;
import org.rocksdb.RocksIterator;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Vector;

import static java.lang.Integer.parseInt;


public class InvertedIndex
{
    private RocksDB db;
    private Options options;
    public  RocksDB getDB() throws  RocksDBException{
        return db;
    }
    public InvertedIndex(String dbPath) throws RocksDBException
    {
        // the Options class contains a set of configurable DB options
        // that determines the behaviour of the database.
        this.options = new Options();
        this.options.setCreateIfMissing(true);

        // creat and open the database
        this.db = RocksDB.open(options, dbPath);
    }
    protected int check_decimal (int number){
        int i = 1;
        while(number/10>0){
            number = number/10;
            i++;
        }
        return i;
    }
    protected int get_document_frequency(String word){
        System.out.println(word);
        int term_freq = 0;
        while(word.indexOf("doc")>=0){
            try {
                String current_doc_id_test = word.substring(word.indexOf("doc"),word.indexOf(" "));
                System.out.println("Doc exist: "+current_doc_id_test);
                word = word.substring(word.indexOf(current_doc_id_test) + current_doc_id_test.length());
                if(word.indexOf("doc")>=0){
                    word = word.substring(word.indexOf("doc"));
                }
                term_freq++;
//                        System.out.println(db_string_test);
            } catch (Exception e){
                System.out.println(e);
            }
        }
//        Vector<Integer> docs_id = new Vector<Integer>();
//        String current_doc_id = "doc"+Integer.toString(i);
//        try{
//        while(word.indexOf("doc")>=0){
//            if(word.indexOf(current_doc_id)>=0){
//                try {
//                    System.out.println(current_doc_id);
//                    word = word.substring(word.indexOf(current_doc_id) + (3+check_decimal(i)));
//                    System.out.println(word);
//                    term_freq++;
//                } catch (Exception e){
//                    System.out.println(e);
//                }
//            }
//            i++;
//            current_doc_id = "doc"+Integer.toString(i);
//        }} catch (Exception e){
//            System.out.println(e);
//        }
        System.out.println(term_freq);
        return term_freq;
    }
    public void addDocumentFreq(String word, InvertedIndex word_index) throws RocksDBException{
        try {
            byte[] content = String.valueOf(get_document_frequency(new String(word_index.getDB().get(word.getBytes())))).getBytes();
            db.put(word.getBytes(), content);
        }catch (RocksDBException r){
            System.out.println(r);
        }
    }

    public void addEntry(String word, int x, int freq, String y) throws RocksDBException
    {
        // Add a "docX Y" entry for the key "word" into hashtable
        // ADD YOUR CODES HERE
        byte[] content = db.get(word.getBytes());
        if (content == null) {
            content = ("doc" + x + " freq" + freq + " pos" + y).getBytes();
        } else {
            content = (new String(content) + " doc" + x + " freq" + freq + " pos" + y).getBytes();
        }
        db.put(word.getBytes(), content);
    }
//
    public void addEntryDocs(String docID, String PageTitle, String Modified_time, String cururl, int PageSize, String childLink, String words, String freq) throws RocksDBException{
        byte[] content = db.get(docID.getBytes());
        content = ("pageTitle" + PageTitle + " url" + cururl +" LastModifiedTime"+ Modified_time +" pageSize" + PageSize + " childLink" + childLink
        + " words" + words + " frequencies" + freq).getBytes();
        db.put(docID.getBytes(), content);
    }

    public void addTitleDocs(String docID, String words, String freq) throws RocksDBException{
//        byte[] content = db.get(docID.getBytes());
        byte[] content = ("words" + words + " frequencies" + freq).getBytes();
        db.put(docID.getBytes(), content);
    }
    public void delEntry(String word) throws RocksDBException
    {
        // Delete the word and its list from the hashtable
        // ADD YOUR CODES HERE
        db.remove(word.getBytes());
    }
    public void delDoc(String docID) throws RocksDBException{
        db.remove(docID.getBytes());
    }
    public void printAll() throws RocksDBException
    {
        // Print all the data in the hashtable
        // ADD YOUR CODES HERE
        RocksIterator iter = db.newIterator();

        for(iter.seekToFirst(); iter.isValid(); iter.next()) {
            System.out.println(new String(iter.key()) + "=" + new String(iter.value()));
        }
    }
    public void writeToText() throws RocksDBException, IOException {
//        FileWriter writer = new FileWriter("/Users/tayingcheng/Desktop/2019-2020Spring/Comp4321/project/comp_4321_project_search_engine/src/txtFile/spider_result.txt", true);
        FileWriter writer = new FileWriter("/Users/seanliu/Desktop/comp_4321_project/src/txtFile/spider_result.txt", true);
        RocksIterator iter = db.newIterator();
        int flag = 0;
        for(iter.seekToFirst(); iter.isValid(); iter.next()) {
            if(flag == 1){
                writer.write("-------------------------------------------------------------------------------------------\n");
            }
            flag = 1;
            String currentDoc = new String(iter.value());
            String pageTitle = currentDoc.substring(currentDoc.indexOf("pageTitle") + 9, currentDoc.indexOf("url") - 1);
            String pageURL = currentDoc.substring(currentDoc.indexOf("url") + 3, currentDoc.indexOf("LastModifiedTime") - 1);
            String modifiedTime = currentDoc.substring(currentDoc.indexOf("LastModifiedTime") + 16, currentDoc.indexOf("pageSize") - 1);
            String pageSize = currentDoc.substring(currentDoc.indexOf("pageSize") + 8, currentDoc.indexOf("childLink") - 1);
            String childLink = currentDoc.substring(currentDoc.indexOf("childLink") + 10, currentDoc.indexOf("words") - 2);
            String words = currentDoc.substring(currentDoc.indexOf("words") + 6, currentDoc.indexOf("frequencies") - 2);
            String freq = currentDoc.substring(currentDoc.indexOf("frequencies") + 12, currentDoc.length() - 1);
            //System.out.println(freq);
            String[] arrChildLink = childLink.split(", ");
            String[] arrWords = words.split(",");
            String[] arrFreq = freq.split(",");
            writer.write(pageTitle + "\n");
            writer.write(pageURL + "\n");
            writer.write(modifiedTime+ ", " + pageSize + "\n");
            for(int i = 0; i < arrWords.length; i ++){
                writer.write(arrWords[i] + " " + arrFreq[i] + ";");
            }
            writer.write("\n");
            for(int i = 0; i < arrChildLink.length; i ++){
                writer.write(arrChildLink[i] + "\n");
            }
        }
        writer.close();
        System.out.println("Done!\n");
    }
}