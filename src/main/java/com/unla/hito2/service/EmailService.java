package com.unla.hito2.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;


@Service
public class EmailService {

    private final JavaMailSender javaMailSender;
    public EmailService(JavaMailSender javaMailSender){
        this.javaMailSender = javaMailSender;
    }

    public void enviarCredenciales(String emailDestino, String passwordPlana){
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(emailDestino);
        mensaje.setSubject("Tus credenciales de acceso para Epicentro Gourmet");
        mensaje.setText("Te damos la bienvenida a Epicentro Gourmet. Tu cuenta ha sido creada con éxito. A continuación, te compartimos tus datos de acceso para que puedas ingresar a la aplicación:\n" +
                "• Usuario / Email: " + emailDestino +
                "\n• Contraseña temporal: " + passwordPlana +
                "\nPor tu seguridad: Esta contraseña es provisional. Te recomendamos iniciar sesión de inmediato y cambiar tu contraseña.\n");
        this.javaMailSender.send(mensaje);
    }


}
