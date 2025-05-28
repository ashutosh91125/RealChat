package com.example.chat.controller;

import com.example.chat.repository.ChatMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("messages", chatMessageRepository.findTop50ByOrderByTimestampDesc());
        return "chat";
    }
}
