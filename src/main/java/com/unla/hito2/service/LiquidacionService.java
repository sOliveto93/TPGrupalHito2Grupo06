package com.unla.hito2.service;

import com.unla.hito2.repository.LiquidacionRepository;
import org.springframework.stereotype.Service;

@Service
public class LiquidacionService {

    private final LiquidacionRepository liquidacionRepository;

    public LiquidacionService(LiquidacionRepository liquidacionRepository){
        this.liquidacionRepository = liquidacionRepository;
    }

}
