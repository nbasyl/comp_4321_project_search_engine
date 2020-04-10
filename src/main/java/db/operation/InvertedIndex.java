package db.operation;

import org.rocksdb.RocksDB;
import org.rocksdb.Options;
import org.rocksdb.RocksDBException;
import org.rocksdb.RocksIterator;


public class InvertedIndex
{
    private RocksDB db;
    private Options options;

    InvertedIndex(String dbPath) throws RocksDBException
    {
        // the Options class contains a set of configurable DB options
        // that determines the behaviour of the database.
        this.options = new Options();
        this.options.setCreateIfMissing(true);

        // creat and open the database
        this.db = RocksDB.open(options, dbPath);
    }

    public void addEntry(String word, int x, int y) throws RocksDBException
    {
        // Add a "docX Y" entry for the key "word" into hashtable
        // ADD YOUR CODES HERE
        byte[] content = db.get(word.getBytes());
        if (content == null) {
            content = ("doc" + x + " " + y).getBytes();
        } else {
            content = (new String(content) + " doc" + x + " " + y).getBytes();
        }
        db.put(word.getBytes(), content);
    }
    public void delEntry(String word) throws RocksDBException
    {
        // Delete the word and its list from the hashtable
        // ADD YOUR CODES HERE
        db.remove(word.getBytes());
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