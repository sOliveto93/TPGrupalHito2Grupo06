package com.unla.hito2.service;

import jakarta.mail.internet.MimeMessage;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
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

    public void enviarLiquidacionPorMail(String emailDestino, String nombreEmpleado, byte[] pdfBytes, Long liquidacionId) throws Exception {
        MimeMessage mensaje = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mensaje, true);

        helper.setTo(emailDestino);
        helper.setSubject("Tu liquidación de haberes - Epicentro Gourmet");
        helper.setText("Hola " + nombreEmpleado + ",\n\n" +
                "Te enviamos adjunta tu liquidación de haberes correspondiente.\n\n" +
                "Saludos cordiales,\n" +
                "Equipo Epicentro Gourmet");

        ByteArrayResource resource = new ByteArrayResource(pdfBytes);
        helper.addAttachment("Liquidacion-" + liquidacionId + ".pdf", resource);

        javaMailSender.send(mensaje);
    }


}
