package web.useraction.controller;

import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HelloWorldController {
    String message = "Welcome to Spring MVC!";

    @RequestMapping("/hello")
    public ModelAndView showMessage(@RequestParam(value = "name", required = false, defaultValue = "World") String name)
    {
        ModelAndView mv = new ModelAndView("helloworld");
        mv.addObject("message", message);
        mv.addObject("name", name);
        System.out.println(mv);
        return mv;
    }
}