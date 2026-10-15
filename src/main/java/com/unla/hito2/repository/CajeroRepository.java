package com.unla.hito2.repository;
import com.unla.hito2.entity.Cajero;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CajeroRepository  extends JpaRepository<Cajero, Long>{
}
