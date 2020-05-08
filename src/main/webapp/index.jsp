<%@ page language="java" contentType="text/html; charset=ISO-8859-1"

         pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Spring 4 MVC - HelloWorld Index Page</title>
    <script src="https://code.jquery.com/jquery-1.10.2.js",type="text/javascript"></script>
    <script>
        function clean_append_item() {
            document.getElementById("index_page_title").innerText="";
            document.getElementById("index_page_url").innerText="";
            document.getElementById("index_page_size").innerText="";
            document.getElementById("index_links_list").innerText="";
            document.getElementById("index_words_list").innerText="";
            document.getElementById("index_page_modified_time").innerText="";
        }
        function clean_search_result() {
            console.log("in cleaning search result");
            var previous_search_query = document.getElementById("previous_search_query")
            var current_search_query = document.getElementById("current_search_query")
            previous_search_query.innerText = current_search_query.innerText;
            current_search_query.innerText="";
            var previous_serach_result = document.getElementById("search_previous_docs_list");
            previous_serach_result.innerText="";
            var current_search_result = document.getElementsByClassName("current_search_item");
            if (current_search_result != null){
                while (current_search_result.length) {
                    console.log(current_search_result[0]);
                    var node = current_search_result[0];
                    node.classList.remove('current_search_item');
                    previous_serach_result.appendChild(node);
                }
                document.getElementById("search_current_docs_list").innerText="";
            }
        }
        function append_item_to_list(list_id, value, value2 = -1) {
            if (value2 != -1) {
                var node = document.createElement("LI");
                var textnode = document.createTextNode(value+" frquency: "+value2);
                node.appendChild(textnode);
                document.getElementById(list_id).appendChild(node);
            }else{
                var node = document.createElement("LI");
                var textnode = document.createTextNode(value);
                node.appendChild(textnode);
                document.getElementById(list_id).appendChild(node);
            }
        }
        function append_item_to_id(id, value) {
            var textnode = document.createTextNode(value);
            document.getElementById(id).appendChild(textnode);
        }
        function submit_url(){
            $.ajax({
                url : 'GetUserQueryServlet',
                data : {
                    web_url : $('#web_url').val()
                },
                success : function(responseJson) {
                    var words_key = responseJson.words_key;
                    var words_count = responseJson.words_count;
                    var links = responseJson.links_list;
                    var title = responseJson.page_title;
                    var size  = responseJson.page_size;
                    var page_url = responseJson.page_url;
                    var page_last_modified_time = responseJson.page_last_modified_time;
                    clean_append_item();
                    for (i=0;i<words_key.length;i++){
                        append_item_to_list("index_words_list", words_key[i],words_count[i]);
                    }
                    for (i=0;i<links.length;i++){
                        append_item_to_list("index_links_list", links[i])
                    }
                    append_item_to_id("index_page_title",title);
                    append_item_to_id("index_page_url",page_url);
                    append_item_to_id("index_page_size",size);
                    append_item_to_id("index_page_modified_time",page_last_modified_time);
                    // $('#ajaxGetUserQueryServletResponse').text(responseText);
                }
            });
        }
        function submit_query(){
            $.ajax({
                url : 'GetUserSearchQueryServlet',
                data : {
                    search_query : $('#search_query').val()
                },
                success : function(responseJson) {
                    var success = responseJson.success_message;
                    var queries = responseJson.clean_words;
                    console.log(queries);
                    var docs_id = responseJson.docs_id;
                    console.log(docs_id);
                    var docs_score = responseJson.docs_score;
                    var queries_used = "Query used for the search:";
                    clean_search_result();
                    for(i=0;i<docs_id.length;i++){
                        var node = document.createElement("LI");
                        var button = document.createElement("button");
                        button.textContent = "get similar pages";
                        button.addEventListener("click", submit_similar_page_query);
                        button.setAttribute("id",docs_id[i]);
                        var textnode = document.createTextNode(docs_id[i]+" score: "+docs_score[i]);
                        node.appendChild(textnode);
                        node.appendChild(button);
                        node.setAttribute("class","current_search_item");
                        document.getElementById("search_current_docs_list").appendChild(node);
                    }
                    for(i=0;i<queries.length;i++){
                        queries_used = queries_used+" "+queries[i];
                    }
                    document.getElementById("current_search_query").innerText = queries_used;
                }
            });
        }
        function submit_similar_page_query(){
            $.ajax({
                url : 'GetUserSearchQueryServlet',
                data : {
                    page_id: this.id,
                    search_query : $('#search_query').val()
                },
                success : function(responseJson) {
                    var success = responseJson.success_message;
                    var queries = responseJson.clean_words;
                    console.log(queries);
                    var docs_id = responseJson.docs_id;
                    console.log(docs_id);
                    var docs_score = responseJson.docs_score;
                    var queries_used = "Query used for the search:";
                    clean_search_result();
                    for(i=0;i<docs_id.length;i++) {
                        var node = document.createElement("LI");
                        var button = document.createElement("button");
                        button.textContent = "get similar pages";
                        button.addEventListener("click", submit_similar_page_query);
                        button.setAttribute("id", docs_id[i]);
                        var textnode = document.createTextNode(docs_id[i] + " score: " + docs_score[i]);
                        node.appendChild(textnode);
                        node.appendChild(button);
                        node.setAttribute("class","current_search_item");
                        document.getElementById("search_current_docs_list").appendChild(node);
                    }
                    for(i=0;i<queries.length;i++){
                        queries_used = queries_used+" "+queries[i];
                    }
                    document.getElementById("current_search_query").innerText = queries_used;
                }
            });
        }
    </script>
</head>
<body>

<center>
    <div>
        <br>
    <form>
        Enter a url to crawl and index: <input type="text" id="web_url" />
    </form> <br>
    <button id="submit" onclick="submit_url()">submit</button>
    </div>
    <h2>Crawling result of the root page</h2>
    <h3>Title</h3>
    <h2 id="index_page_title"></h2>
    <h3>Page url</h3>
    <h2 id="index_page_url"></h2>
    <h3>Page last modified time</h3>
    <h2 id="index_page_modified_time"></h2>
    <h3>Page Size</h3>
    <h2 id="index_page_size"></h2>
    <h3>All the words</h3>
    <ul id="index_words_list">
    </ul>
    <br>
    <h3>All the links</h3>
    <ul id="index_links_list">
    </ul>
    <div>
        <br>
        <form>
            Enter a search query to search through the index web page: <input type="text" id="search_query" />
        </form> <br>
        <button id="search" onclick="submit_query()">search</button>
        <h2 id="search_result_https">
        </h2>
        <h3>Current Search Result</h3>
        <h4 id="current_search_query"></h4>
        <ul id="search_current_docs_list">
        </ul>
        <h3>Previous Search Result</h3>
        <h4 id="previous_search_query"></h4>
        <ul id="search_previous_docs_list">
        </ul>
    </div>

</center>
</body>
</html>
