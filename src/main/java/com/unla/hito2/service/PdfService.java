package com.unla.hito2.service;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.unla.hito2.entity.LiquidacionHaberes;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

@Service
public class PdfService {

    public ByteArrayInputStream generarReciboLiquidacion(LiquidacionHaberes liquidacion) {
        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, out);
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Paragraph title = new Paragraph("RECIBO DE LIQUIDACION DE HABERES", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            Font infoFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
            Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);

            if (liquidacion.getEmpleado() != null) {
                String nombreCompleto = (liquidacion.getEmpleado().getName() != null ? liquidacion.getEmpleado().getName() : "") + 
                                        " " + (liquidacion.getEmpleado().getApellido() != null ? liquidacion.getEmpleado().getApellido() : "");
                document.add(new Paragraph("Empleado: " + nombreCompleto.trim(), infoFont));
                document.add(new Paragraph("DNI: " + (liquidacion.getEmpleado().getDni() != null ? liquidacion.getEmpleado().getDni() : "-"), infoFont));
                String rol = "STAFF";
                String categoria = "-";
                if (liquidacion.getEmpleado() instanceof com.unla.hito2.entity.Cajero) {
                    rol = "CAJERO";
                    categoria = "CAJERO";
                } else if (liquidacion.getEmpleado() instanceof com.unla.hito2.entity.Cocinero cocinero) {
                    rol = "COCINERO";
                    if (cocinero.getCategoria() != null) {
                        categoria = cocinero.getCategoria().name().replace("_", " ");
                    } else {
                        categoria = "COCINERO";
                    }
                } else {
                    rol = "STAFF";
                    categoria = "RESPONSABLE";
                }
                document.add(new Paragraph("Rol: " + rol, infoFont));
                document.add(new Paragraph("Categoria: " + categoria, infoFont));
            }
            if (liquidacion.getFestival() != null) {
                document.add(new Paragraph("Festival: " + liquidacion.getFestival().getNombre(), infoFont));
            }
            document.add(new Paragraph("Fecha de Liquidacion: " + liquidacion.getFecha(), infoFont));
            document.add(new Paragraph("Dias Trabajados: " + liquidacion.getDiasFestival(), infoFont));
            document.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10);
            table.setSpacingAfter(10);

            addCell(table, "Concepto", boldFont);
            addCell(table, "Importe", boldFont);

            addCell(table, "Sueldo Base", infoFont);
            addCell(table, "$ " + liquidacion.getSueldo(), infoFont);

            addCell(table, "Adicional Aplicado", infoFont);
            addCell(table, "$ " + liquidacion.getAdicionalAplicado(), infoFont);

            addCell(table, "Factor Aplicado", infoFont);
            addCell(table, String.valueOf(liquidacion.getFactorAplicado()), infoFont);

            addCell(table, "TOTAL NETO", boldFont);
            addCell(table, "$ " + liquidacion.getTotal(), boldFont);

            document.add(table);

            Paragraph footer = new Paragraph("Firma y Sello", infoFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(40);
            document.add(footer);

            document.close();

        } catch (DocumentException e) {
            e.printStackTrace();
        }

        return new ByteArrayInputStream(out.toByteArray());
    }

    private void addCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(5);
        table.addCell(cell);
    }
}
