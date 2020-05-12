# COMP4321-Search Engine 
# 87YungLive-search engine

One Paragraph of project description goes here

## Getting Started

The search engine was built using Java Maven project with spring framework

* Java ([Maven](https://maven.apache.org/))
* Tomcat server
* Spring framework
* Javascript
* Jsp
* CSS

### Installing

Follow a concise article written by SeanThePlug to set up the environment:
[links to article](https://medium.com/@seanliu_90343/how-to-set-up-a-tomcat-server-under-maven-project-structure-using-intellij-idea-macos-1475a975abf0)

Please also change the following value inside GetUserQueryServlet.java
```
    String path = "ABSOLUTE_PATH/comp_4321_project_search_engine/src/main/java/db/data/words";
    String path2 = "ABSOLUTE_PATH/comp_4321_project_search_engine/src/main/java/db/data/docs";
```

![Alt text](readme_image/read_me_image.png?raw=true "Title")

Also change the following path inside InvertedIndex.java 
```
FileWriter writer = new FileWriter("ABSOLUTE_PATH/comp_4321_project_search_engine/src/txtFile/spider_result.txt", true);
```
![Alt text](readme_image/read_me_image_2.png?raw=true "Title")

## Running the tests for phase 1

* Before starting the test, you have to manually delete the content within the db/data/words and db/data/docs
* Run the server and type in (https://www.cse.ust.hk/) to the textbox. 
* Click submit and wait for the text file to generate.
* find the spider_result.txt in the src/txtFile folder

## Running the tests for phase 2(please check the final report)
