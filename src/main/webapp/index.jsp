<%@ page language="java" contentType="text/html; charset=ISO-8859-1"

         pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Spring 4 MVC - HelloWorld Index Page</title>
    <script src="https://code.jquery.com/jquery-1.10.2.js",type="text/javascript"></script>
    <script>
        function append_item_to_list(list_id, value, value2 = -1) {
            if (value2 != -1) {
                var node = document.createElement("LI");
                var textnode = document.createTextNode(value+"                frquency: "+value2);
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
                    console.log(responseJson.words);
                    for (i=0;i<words_key.length;i++){
                        append_item_to_list("search_words_list", words_key[i],words_count[i]);
                    }
                    for (i=0;i<links.length;i++){
                        append_item_to_list("search_links_list", links[i])
                    }
                    append_item_to_id("search_page_title",title);
                    append_item_to_id("search_page_url",page_url);
                    append_item_to_id("search_page_size",size);
                    // $('#ajaxGetUserQueryServletResponse').text(responseText);
                }
            });
        }
    </script>
</head>
<body>

<center>
    <h2>Hello World</h2>
    <h3>
        <a href="hello?name=Eric">Click Here</a>
    </h3>
    <h2>Web Crawler Testing</h2>
    <h3>
        <a href="crawling">Start Crawling comp4321 Website</a>
    </h3>
    <div>
    <form>
        Enter a url to crawl: <input type="text" id="web_url" />
    </form> <br>
    <button id="submit" onclick="submit_url()">submit</button>
    </div>
    <h2>Crawling result</h2>:
    <h3>Title</h3>
    <h2 id="search_page_title"></h2>
    <h3>Page url</h3>
    <h2 id="search_page_url"></h2>
    <h3>Page Size</h3>
    <h2 id="search_page_size"></h2>
    <h3>All the words</h3>
    <ul id="search_words_list">
    </ul>
    <br>
    <h3>All the links</h3>
    <ul id="search_links_list">
    </ul>

</center>
</body>
</html>
