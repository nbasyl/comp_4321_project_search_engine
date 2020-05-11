<%@ page language="java" contentType="text/html; charset=ISO-8859-1"

         pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Spring 4 MVC - HelloWorld Index Page</title>
    <style type="text/css">
        .flex {
            display: flex;
            padding: 15px;
            background-color: white;
            /*row | row-reverse | column | column-reverse;*/
            flex-direction: row;
        }
        h5{
            padding: 0px;
            margin: 0px;
        }


        .item {
            background-color: white;
            margin: 20px;
            display: flex;
            justify-content: flex-start;
            align-items: flex-start;
        }
        .item_score {
            padding: 15px;
            background-color: white;
            /*row | row-reverse | column | column-reverse;*/
            flex-direction: column;
        }

        .content_flex {
            display: flex;
            padding: 15px;
            background-color: white;
            /*row | row-reverse | column | column-reverse;*/
            flex-direction: column;
        }
        .item_links{
            display: flex;
            padding: 15px;
            background-color: white;
            /*row | row-reverse | column | column-reverse;*/
            flex-direction: column;
        }

        .item_overflow{
            height: 300px;/*..very important if you want scroll bar...*/
            overflow:auto; /*..will introduce scroll bar when needed..*/
            padding: 20px;
            width: 400px;
            margin-right: 20px;
            display: inline-block;
            background-color: aliceblue;
        }
        .search_result_div{
            display: flex;
            padding: 15px;
            background-color: white;
            /*row | row-reverse | column | column-reverse;*/
            flex-direction: row;
        }
        .current_search_result_div{
            flex: 1;
            display: inline-block;
            width: 50%;
        }
        .previous_search_result_div{
            flex: 1;
            display: inline-block;
            width: 50%;
        }
    </style>
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
                    var page_title = responseJson.pageTitle;
                    var page_url = responseJson.pageUrl;
                    var modified_time = responseJson.modTime;
                    var page_size = responseJson.pageSize;
                    var parentLink = responseJson.parentLinks;
                    var childLink = responseJson.childLinks;
                    var words = responseJson.words;
                    var freqs = responseJson.freqs;
                    var docs_id = responseJson.docs_id;
                    console.log(docs_id);
                    var docs_score = responseJson.docs_score;
                    var queries_used = "Query used for the search:";
                    clean_search_result();

                    for(i=0;i<docs_id.length;i++){
                        var node = document.createElement("LI");

                        var container = document.createElement("div");
                        container.setAttribute("class","flex");

                        var button = document.createElement("button");
                        button.textContent = "get similar pages";
                        button.addEventListener("click", submit_similar_page_query);
                        button.setAttribute("id",docs_id[i]);

                        var score_div = document.createElement("div");
                        score_div.setAttribute("class","item_score");
                        var score = document.createTextNode("score: " + docs_score[i]+" ");
                        var score_node = document.createElement("h5");
                        var score_sub_div = document.createElement("div");
                        score_sub_div.setAttribute("class","item");
                        score_node.appendChild(score);
                        score_sub_div.appendChild(score_node);
                        score_div.appendChild(score_sub_div);

                        var content_div = document.createElement("div");
                        content_div.setAttribute("class","content_flex");

                        // big box
                        container.appendChild(score_div);
                        container.appendChild(content_div);
                        // title content div
                        var title_div = document.createElement("div");
                        title_div.setAttribute("class","item_score");
                        var title_node = document.createElement("h5");
                        var texttitle = document.createTextNode("Page title: "+page_title[i]);
                        title_node.appendChild(texttitle);
                        title_div.appendChild(title_node);
                        title_div.appendChild(button);
                        content_div.appendChild(title_div);
                        // url div
                        var url_div = document.createElement("div");
                        url_div.setAttribute("class","item");
                        var pageUrl = document.createElement('a');
                        var texturl = document.createTextNode(page_url[i])
                        pageUrl.appendChild(texturl);
                        pageUrl.href = page_url[i];
                        pageUrl.setAttribute("target","_blank");
                        url_div.appendChild(pageUrl);
                        content_div.appendChild(url_div);

                        // modified_time_div
                        var modtime_div = document.createElement("div");
                        modtime_div.setAttribute("class","item");
                        var modtime = document.createTextNode("Modified time: "+modified_time[i]+" Page size: "+page_size[i]);
                        var modtime_node = document.createElement("h5");
                        modtime_node.appendChild(modtime);
                        modtime_div.appendChild(modtime_node);
                        content_div.appendChild(modtime_div);

                        var words_div = document.createElement("div");
                        words_div.setAttribute("class","item_links");
                        var indexed_words = document.createElement("h5");
                        indexed_words.appendChild(document.createTextNode("Index Keywords"));
                        words_div.appendChild(indexed_words);
                        var words_div_div = document.createElement("div");
                        words_div_div.setAttribute("class","item_overflow");
                        for(j = 0; j < words[i].length; j++){
                            var curWord = document.createTextNode(words[i][j] + " " + freqs[i][j] + ";")
                            var curWord_node = document.createElement("h6");
                            curWord_node.appendChild(curWord);
                            var br = document.createElement("br");
                            words_div_div.appendChild(curWord);
                            words_div_div.appendChild(br);
                        }
                        words_div.appendChild(words_div_div);
                        content_div.appendChild(words_div);

                        var parentLinks_div = document.createElement("div");
                        parentLinks_div.setAttribute("class","item_links");
                        var parent = document.createElement("h5");
                        parent.appendChild(document.createTextNode("Parent Links"));
                        parentLinks_div.appendChild(parent);
                        var parentLinks_div_div = document.createElement("div");
                        parentLinks_div_div.setAttribute("class","item_overflow");
                        for(j = 0; j < parentLink[i].length; j++){
                            var curLink = document.createTextNode(parentLink[i][j]);
                            var parentUrl = document.createElement('a');
                            parentUrl.appendChild(curLink);
                            parentUrl.href = parentLink[i][j];
                            parentUrl.setAttribute("target","_blank");
                            var br = document.createElement("br");
                            parentLinks_div_div.appendChild(parentUrl);
                            parentLinks_div_div.appendChild(br);
                        }
                        parentLinks_div.appendChild(parentLinks_div_div);
                        content_div.appendChild(parentLinks_div);


                        var childLinks_div = document.createElement("div");
                        childLinks_div.setAttribute("class","item_links");
                        var child = document.createElement("h5");
                        child.appendChild(document.createTextNode("Child Links"));
                        childLinks_div.appendChild(child);
                        var childLinks_div_div = document.createElement("div");
                        childLinks_div_div.setAttribute("class","item_overflow");
                        for(j = 0; j < childLink[i].length; j++){
                            var curLink = document.createTextNode(childLink[i][j]);
                            var childUrl = document.createElement('a');
                            childUrl.appendChild(curLink);
                            childUrl.href = childLink[i][j];
                            childUrl.setAttribute("target","_blank");
                            var br = document.createElement("br");
                            childLinks_div_div.appendChild(childUrl);
                            childLinks_div_div.appendChild(br);
                        }
                        childLinks_div.appendChild(childLinks_div_div);
                        content_div.appendChild(childLinks_div);

                        node.appendChild(container);
                        node.setAttribute("class","current_search_item");
                        document.getElementById("search_current_docs_list").appendChild(node);
                    }


                    for(i=0;i<queries.length;i++){
                        queries_used = queries_used+" "+""+"["+queries[i]+"]";
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
                    var page_title = responseJson.pageTitle;
                    var page_url = responseJson.pageUrl;
                    var modified_time = responseJson.modTime;
                    var page_size = responseJson.pageSize;
                    var parentLink = responseJson.parentLinks;
                    var childLink = responseJson.childLinks;
                    var words = responseJson.words;
                    var freqs = responseJson.freqs;
                    var docs_id = responseJson.docs_id;
                    console.log(docs_id);
                    var docs_score = responseJson.docs_score;
                    var queries_used = "Query used for the search:";
                    clean_search_result();

                    for(i=0;i<docs_id.length;i++){
                        var node = document.createElement("LI");

                        var container = document.createElement("div");
                        container.setAttribute("class","flex");

                        var button = document.createElement("button");
                        button.textContent = "get similar pages";
                        button.addEventListener("click", submit_similar_page_query);
                        button.setAttribute("id",docs_id[i]);

                        var score_div = document.createElement("div");
                        score_div.setAttribute("class","item_score");
                        var score = document.createTextNode("score: " + docs_score[i]+" ");
                        var score_node = document.createElement("h5");
                        var score_sub_div = document.createElement("div");
                        score_sub_div.setAttribute("class","item");
                        score_node.appendChild(score);
                        score_sub_div.appendChild(score_node);
                        score_div.appendChild(score_sub_div);

                        var content_div = document.createElement("div");
                        content_div.setAttribute("class","content_flex");

                        // big box
                        container.appendChild(score_div);
                        container.appendChild(content_div);
                        // title content div
                        var title_div = document.createElement("div");
                        title_div.setAttribute("class","item_score");
                        var title_node = document.createElement("h5");
                        var texttitle = document.createTextNode("Page title: "+page_title[i]);
                        title_node.appendChild(texttitle);
                        title_div.appendChild(title_node);
                        title_div.appendChild(button);
                        content_div.appendChild(title_div);
                        // url div
                        var url_div = document.createElement("div");
                        url_div.setAttribute("class","item");
                        var pageUrl = document.createElement('a');
                        var texturl = document.createTextNode(page_url[i])
                        pageUrl.appendChild(texturl);
                        pageUrl.href = page_url[i];
                        pageUrl.setAttribute("target","_blank");
                        url_div.appendChild(pageUrl);
                        content_div.appendChild(url_div);

                        // modified_time_div
                        var modtime_div = document.createElement("div");
                        modtime_div.setAttribute("class","item");
                        var modtime = document.createTextNode("Modified time: "+modified_time[i]+" Page size: "+page_size[i]);
                        var modtime_node = document.createElement("h5");
                        modtime_node.appendChild(modtime);
                        modtime_div.appendChild(modtime_node);
                        content_div.appendChild(modtime_div);

                        var words_div = document.createElement("div");
                        words_div.setAttribute("class","item_links");
                        var indexed_words = document.createElement("h5");
                        indexed_words.appendChild(document.createTextNode("Index Keywords"));
                        words_div.appendChild(indexed_words);
                        var words_div_div = document.createElement("div");
                        words_div_div.setAttribute("class","item_overflow");
                        for(j = 0; j < words[i].length; j++){
                            var curWord = document.createTextNode(words[i][j] + " " + freqs[i][j] + ";")
                            var curWord_node = document.createElement("h6");
                            curWord_node.appendChild(curWord);
                            var br = document.createElement("br");
                            words_div_div.appendChild(curWord);
                            words_div_div.appendChild(br);
                        }
                        words_div.appendChild(words_div_div);
                        content_div.appendChild(words_div);

                        var parentLinks_div = document.createElement("div");
                        parentLinks_div.setAttribute("class","item_links");
                        var parent = document.createElement("h5");
                        parent.appendChild(document.createTextNode("Parent Links"));
                        parentLinks_div.appendChild(parent);
                        var parentLinks_div_div = document.createElement("div");
                        parentLinks_div_div.setAttribute("class","item_overflow");
                        for(j = 0; j < parentLink[i].length; j++){
                            var curLink = document.createTextNode(parentLink[i][j]);
                            var parentUrl = document.createElement('a');
                            parentUrl.appendChild(curLink);
                            parentUrl.href = parentLink[i][j];
                            parentUrl.setAttribute("target","_blank");
                            var br = document.createElement("br");
                            parentLinks_div_div.appendChild(parentUrl);
                            parentLinks_div_div.appendChild(br);
                        }
                        parentLinks_div.appendChild(parentLinks_div_div);
                        content_div.appendChild(parentLinks_div);


                        var childLinks_div = document.createElement("div");
                        childLinks_div.setAttribute("class","item_links");
                        var child = document.createElement("h5");
                        child.appendChild(document.createTextNode("Child Links"));
                        childLinks_div.appendChild(child);
                        var childLinks_div_div = document.createElement("div");
                        childLinks_div_div.setAttribute("class","item_overflow");
                        for(j = 0; j < childLink[i].length; j++){
                            var curLink = document.createTextNode(childLink[i][j]);
                            var childUrl = document.createElement('a');
                            childUrl.appendChild(curLink);
                            childUrl.href = childLink[i][j];
                            childUrl.setAttribute("target","_blank");
                            var br = document.createElement("br");
                            childLinks_div_div.appendChild(childUrl);
                            childLinks_div_div.appendChild(br);
                        }
                        childLinks_div.appendChild(childLinks_div_div);
                        content_div.appendChild(childLinks_div);

                        node.appendChild(container);
                        node.setAttribute("class","current_search_item");
                        document.getElementById("search_current_docs_list").appendChild(node);
                    }


                    for(i=0;i<queries.length;i++){
                        queries_used = queries_used+" "+""+"["+queries[i]+"]";
                    }
                    document.getElementById("current_search_query").innerText = queries_used;
                }
            });
        }
    </script>
</head>
<body>

    <div>
        <br>
    <form>
        Enter a url to crawl and index: <input type="text" id="web_url" />
    </form> <br>
    <button id="submit" onclick="submit_url()">submit</button>
    </div>

    <div>
        <br>
        <center>
        <form>
            Enter a search query to search through the index web page: <input type="text" id="search_query" />
        </form> <br>
        <button id="search" onclick="submit_query()">search</button>
        </center>

        <div class="search_result_div">
            <div class="current_search_result_div">
                <center>
                <h3>Current Search Result</h3>
                <h4 id="current_search_query"></h4>
                </center>
                <ul id="search_current_docs_list">
                </ul>
            </div>
            <div class="previous_search_result_div">
                <center>
                <h3>Previous Search Result</h3>
                <h4 id="previous_search_query"></h4>
                </center>
                <ul id="search_previous_docs_list">
                </ul>
            </div>
        </div>
    </div>
</body>
</html>
