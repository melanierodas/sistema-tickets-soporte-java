<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="BACKEND.clsReclamos"%>

<%
    String mensaje = "";
    String claseAlerta = "d-none";
    String tipoAlerta = "alert-success";

    if (clsReclamos.colaTickets.isEmpty()) {
        clsReclamos.cargarColaDesdeBD();
    }

    String accion = request.getParameter("pAccion");
    if (accion != null && accion.equals("Atender")) {
        String telefono = request.getParameter("pTelefono");
        String solucion = request.getParameter("pSolucion");

        if (solucion != null && !solucion.trim().isEmpty()) {
            clsReclamos control = new clsReclamos();
            int resultado = control.fncAtenderTicketBD(telefono, solucion);
            
            if (resultado == 1) {
                clsReclamos.atenderTicket();
                mensaje = "¡Ticket atendido con éxito y retirado de la cola FIFO!";
                claseAlerta = "d-block";
                tipoAlerta = "alert-success";
            } else {
                mensaje = "Error al actualizar el estado del ticket en la base de datos.";
                claseAlerta = "d-block";
                tipoAlerta = "alert-danger";
            }
        }
    }

    clsReclamos primerTicket = clsReclamos.colaTickets.peek();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mesa de Ayuda - Atención de Tickets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f4f8; }
        .bg-tigo { background: linear-gradient(135deg, #002b66 0%, #004494 100%); }
        .card-ticket { border-radius: 12px; border: none; box-shadow: 0 8px 24px rgba(0,0,0,0.06); }
        .fifo-header { background-color: #fff9e6; border-left: 5px solid #f59e0b; }
        .badge-cola { background-color: #f59e0b; color: #1e293b; font-weight: 700; }
        .btn-action { background-color: #004494; border: none; }
        .btn-action:hover { background-color: #002b66; }
    </style>
</head>
<body>

<div class="container py-5" style="max-width: 820px;">

    <!-- Barra de Navegación Superior -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="index.jsp" class="btn btn-outline-primary px-3 fw-semibold">
            ← Registro de Casos
        </a>
        <span class="badge bg-white text-dark border p-2 px-3 shadow-sm">
            Tickets en Espera: <strong class="text-primary"><%= clsReclamos.colaTickets.size() %></strong>
        </span>
    </div>

    <% if (!mensaje.isEmpty()) { %>
        <div class="alert <%= tipoAlerta %> text-center fw-semibold shadow-sm mb-4" role="alert">
            <%= mensaje %>
        </div>
    <% } %>

    <div class="card card-ticket">
        <div class="card-header bg-tigo text-white text-center py-4 rounded-top-4">
            <h4 class="mb-1 fw-bold text-uppercase tracking-wide">Centro de Atención Técnica</h4>
            <p class="mb-0 small text-white-50">Despacho de incidentes bajo estructura de cola lineal (FIFO)</p>
        </div>
        
        <div class="card-body p-4 p-md-5">
            <% if (primerTicket != null) { %>
                
                <div class="card mb-4 border-0 fifo-header p-3 rounded-3 shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="fw-bold text-dark">📌 TICKET EN TURNO</span>
                        <span class="badge bg-danger">ESTADO: <%= primerTicket.getEstado() %></span>
                    </div>
                    
                    <div class="row g-3 text-secondary small">
                        <div class="col-sm-6">
                            <span class="text-muted d-block">Cliente:</span>
                            <strong class="text-dark fs-6"><%= primerTicket.getNombre() %></strong>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block">Teléfono / Contrato:</span>
                            <strong class="text-dark fs-6"><%= primerTicket.getTelefono() %></strong>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block">Servicio:</span>
                            <span class="text-dark fw-semibold"><%= primerTicket.getTipo_Reclamo() %></span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted d-block">Fecha de Ingreso:</span>
                            <span class="text-dark"><%= primerTicket.getFecha_Ingreso() %></span>
                        </div>
                        <div class="col-12">
                            <span class="text-muted d-block">Ubicación:</span>
                            <span class="text-dark"><%= primerTicket.getDireccion() %></span>
                        </div>
                        <div class="col-12 pt-2 border-top">
                            <span class="text-muted d-block">Falla técnica reportada:</span>
                            <p class="text-dark mb-0 fst-italic"><%= primerTicket.getDescripcion() %></p>
                        </div>
                    </div>
                </div>

                <form method="post" action="atencion.jsp">
                    <input type="hidden" name="pTelefono" value="<%= primerTicket.getTelefono() %>">
                    
                    <div class="mb-4">
                        <label class="form-label fw-bold text-dark">Acción / Procedimiento técnico aplicado:</label>
                        <select name="pSolucion" class="form-select form-select-lg" required>
                            <option value="">-- Seleccionar resolución --</option>
                            <option value="Reinicio del equipo remoto">Reinicio del equipo remoto / Provisión de señal</option>
                            <option value="Activación de plan">Activación y sincronización de plan</option>
                            <option value="Programación de visita">Programación de visita técnica en sitio</option>
                        </select>
                    </div>

                    <div class="d-grid">
                        <button type="submit" name="pAccion" value="Atender" class="btn btn-action btn-lg text-white fw-bold py-3">
                            Confirmar Solución y Despachar Siguiente Ticket
                        </button>
                    </div>
                </form>

            <% } else { %>
                <div class="text-center py-5">
                    <div class="display-4 text-success mb-3">✓</div>
                    <h5 class="fw-bold text-dark">Todos los tickets han sido atendidos</h5>
                    <p class="text-muted small">No hay reclamos pendientes en la cola FIFO en este momento.</p>
                    <a href="atencion.jsp" class="btn btn-outline-secondary btn-sm mt-2">Sincronizar con Base de Datos</a>
                </div>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>