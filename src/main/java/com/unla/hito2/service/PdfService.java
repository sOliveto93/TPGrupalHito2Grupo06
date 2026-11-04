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
import com.unla.hito2.entity.Cajero;
import com.unla.hito2.entity.Cocinero;
import com.unla.hito2.entity.DetallePedido;
import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.entity.Pedido;
import com.unla.hito2.entity.Staff;

import org.hibernate.Hibernate;
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
                String nombreCompleto = (liquidacion.getEmpleado().getName() != null
                        ? liquidacion.getEmpleado().getName()
                        : "") +
                        " " + (liquidacion.getEmpleado().getApellido() != null ? liquidacion.getEmpleado().getApellido()
                                : "");
                document.add(new Paragraph("Empleado: " + nombreCompleto.trim(), infoFont));
                document.add(new Paragraph("DNI: "
                        + (liquidacion.getEmpleado().getDni() != null ? liquidacion.getEmpleado().getDni() : "-"),
                        infoFont));
                String rol = "STAFF";
                String categoria = "-";

                System.out.println(" ---------------------------------  Clase del empleado: " +
                        liquidacion.getEmpleado().getClass().getName());

                Staff empleado = liquidacion.getEmpleado();

                if (empleado != null) {
                    empleado = (Staff) Hibernate.unproxy(empleado);

                    if (empleado instanceof Cajero) {
                        rol = "STAFF";
                        categoria = "CAJERO";
                    } else if (empleado instanceof Cocinero cocinero) {
                        rol = "STAFF";
                        categoria = cocinero.getCategoria() != null
                                ? cocinero.getCategoria().name().replace("_", " ")
                                : "COCINERO";
                    } else {
                        rol = "STAFF";
                        categoria = "RESPONSABLE";
                    }
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

    public ByteArrayInputStream generarTicket(Pedido pedido) {
        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, out);
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font infoFont = FontFactory.getFont(FontFactory.HELVETICA, 11);
            Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11);

            Paragraph title = new Paragraph("COMPROBANTE DE PEDIDO", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            document.add(new Paragraph("Pedido N°: " + pedido.getId(), infoFont));
            document.add(new Paragraph("Fecha: " + pedido.getFechaHora(), infoFont));

            document.add(new Paragraph(
                    "Unidad de venta: " + pedido.getUnidadDeVenta().getNombreComercial(),
                    infoFont));

            document.add(new Paragraph(
                    "Código: " + pedido.getUnidadDeVenta().getCodigo(),
                    infoFont));

            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.setSpacingBefore(15);
            table.setSpacingAfter(15);

            addCell(table, "Plato", boldFont);
            addCell(table, "Cantidad", boldFont);
            addCell(table, "Precio unitario", boldFont);
            addCell(table, "Subtotal", boldFont);

            java.math.BigDecimal total = java.math.BigDecimal.ZERO;

            for (DetallePedido detalle : pedido.getDetalles()) {
                addCell(table, detalle.getPlato().getNombre(), infoFont);
                addCell(table, String.valueOf(detalle.getCantidad()), infoFont);
                addCell(table, "$ " + detalle.getPrecioUnitario(), infoFont);
                addCell(table, "$ " + detalle.getSubtotal(), infoFont);

                total = total.add(detalle.getSubtotal());
            }

            document.add(table);

            Paragraph totalParagraph = new Paragraph(
                    "TOTAL: $ " + total,
                    boldFont);
            totalParagraph.setAlignment(Element.ALIGN_RIGHT);
            document.add(totalParagraph);

            document.close();

        } catch (DocumentException e) {
            throw new RuntimeException("Error al generar el ticket del pedido", e);
        }

        return new ByteArrayInputStream(out.toByteArray());
    }
    
}
