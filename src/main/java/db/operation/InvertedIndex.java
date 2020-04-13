package db.operation;

import org.rocksdb.RocksDB;
import org.rocksdb.Options;
import org.rocksdb.RocksDBException;
import org.rocksdb.RocksIterator;


public class InvertedIndex
{
    private RocksDB db;
    private Options options;

    public InvertedIndex(String dbPath) throws RocksDBException
    {
        // the Options class contains a set of configurable DB options
        // that determines the behaviour of the database.
        this.options = new Options();
        this.options.setCreateIfMissing(true);

        // creat and open the database
        this.db = RocksDB.open(options, dbPath);
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
        content = ("pageTitle" + PageTitle + " url" + cururl +"Last Modified time"+ Modified_time +" pageSize" + PageSize + " childLink" + childLink
        + " words" + words + " frequencies" + freq).getBytes();
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
}