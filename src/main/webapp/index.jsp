<%@ page language="java" contentType="text/html; charset=ISO-8859-1"

         pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Spring 4 MVC - HelloWorld Index Page</title>
    <script src="https://code.jquery.com/jquery-1.10.2.js",type="text/javascript"></script>
    <script>
        function submit_url(){
            console.log("??");
            $.ajax({
                url : 'GetUserQueryServlet',
                data : {
                    web_url : $('#web_url').val()
                },
                success : function(responseText) {
                    $('#ajaxGetUserQueryServletResponse').text(responseText);
                }
            });
        }
        console.log("87??");
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
    <br>
    <br>
    <strong>Crawling result</strong>:
    <div id="ajaxGetUserQueryServletResponse">
    </div>
</center>
</body>
</html>
