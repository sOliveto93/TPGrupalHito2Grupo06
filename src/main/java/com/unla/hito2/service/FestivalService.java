package com.unla.hito2.service;

import com.unla.hito2.entity.Festival;
import com.unla.hito2.repository.FestivalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service

public class FestivalService {

    @Autowired
    private FestivalRepository festivalRepository;

    public List<Festival> traerTodos(){
        return festivalRepository.findAll();
    }
}
