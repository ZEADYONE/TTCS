package com.example.flc.service;

import org.springframework.stereotype.Service;

import com.example.flc.domain.GameRes;
import com.example.flc.repository.GameResRepository;

@Service
public class GameResService {

    private final GameResRepository gameResRepository;

    public GameResService(GameResRepository gameResRepository) {
        this.gameResRepository = gameResRepository;
    }

    public void handleSaveGame(GameRes gameRes) {
        this.gameResRepository.save(gameRes);
    }
}
