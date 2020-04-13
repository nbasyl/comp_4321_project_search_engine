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

Please also change
```
    String path = "ABSOLUTE_PATH/comp_4321_project/src/main/java/db/data/words";
    String path2 = "ABSOLUTE_PATH/comp_4321_project/src/main/java/db/data/docs";
```

![Alt text](readme_image/read_me_image.png?raw=true "Title")

Also change
```
FileWriter writer = new FileWriter("ABSOLUTE_PATH/comp_4321_project/src/txtFile/spider_result.txt", true);
```
![Alt text](readme_image/read_me_image_2.png?raw=true "Title")

## Running the tests

* Run the server and type in (https://www.cse.ust.hk/) to the textbox. 
* Click submit and wait for the text file to generate.
* find the spider_result.txt in the txt
