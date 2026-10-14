/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BACKEND;


import java.sql.Connection; 
import java.sql.PreparedStatement; 
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.LinkedList;
import java.util.Queue;



public class clsReclamos {
    private String Nombre; 
    private String Telefono; 
    private String Direccion; 
    private String Tipo_Reclamo; 
    private String Descripcion; 
    private String Fecha_Ingreso; 
    private String Estado; 
    public static Queue<clsReclamos> colaTickets = new LinkedList<>();

    public clsReclamos() {
    }

    public clsReclamos(String Nombre, String Telefono, String Direccion, String Tipo_Reclamo, String Descripcion, String Fecha_Ingreso, String Estado) {
        this.Nombre = Nombre;
        this.Telefono = Telefono;
        this.Direccion = Direccion;
        this.Tipo_Reclamo = Tipo_Reclamo;
        this.Descripcion = Descripcion;
        this.Fecha_Ingreso = Fecha_Ingreso;
        this.Estado = Estado;
    }

    public String getNombre() {
        return Nombre;
    }

    public void setNombre(String Nombre) {
        this.Nombre = Nombre;
    }

    public String getTelefono() {
        return Telefono;
    }

    public void setTelefono(String Telefono) {
        this.Telefono = Telefono;
    }

    public String getDireccion() {
        return Direccion;
    }

    public void setDireccion(String Direccion) {
        this.Direccion = Direccion;
    }

    public String getTipo_Reclamo() {
        return Tipo_Reclamo;
    }

    public void setTipo_Reclamo(String Tipo_Reclamo) {
        this.Tipo_Reclamo = Tipo_Reclamo;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getFecha_Ingreso() {
        return Fecha_Ingreso;
    }

    public void setFecha_Ingreso(String Fecha_Ingreso) {
        this.Fecha_Ingreso = Fecha_Ingreso;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }
    
    public int fncIngreso(clsReclamos pReclamos){
        int Resp = 0; 
        
        try{
            clsConexion Conexion = new clsConexion(); 
            Connection Con = Conexion.conectar(); 
            String Consulta = "INSERT INTO REGISTRO(NOMBRE, TELEFONO, DIRECCION, TIPO_RECLAMO, DESCRIPCION, FECHA_INGRESO, ESTADO) "
                + "VALUES(?,?,?,?,?,?,?)";
            
            PreparedStatement Comando = Con.prepareStatement(Consulta); 
            Comando.setString(1, pReclamos.getNombre());
            Comando.setString(2, pReclamos.getTelefono()); 
            Comando.setString(3, pReclamos.getDireccion()); 
            Comando.setString(4, pReclamos.getTipo_Reclamo()); 
            Comando.setString(5, pReclamos.getDescripcion()); 
            Comando.setString(6, pReclamos.getFecha_Ingreso()); 
            Comando.setString(7, pReclamos.getEstado());
            Comando.executeUpdate(); 
            Comando.close(); 
            Con.close(); 
            Resp = 1; 
            
        }catch(Exception ex){
            System.out.println("Error: " + ex.getMessage()); 
            Resp = -1; 
        }
        return Resp; 
    }
    
    
    public static void cargarColaDesdeBD() {
        colaTickets.clear();
        try {
            clsConexion Conexion = new clsConexion();
            Connection Con = Conexion.conectar();
            String Consulta = "SELECT NOMBRE, TELEFONO, DIRECCION, TIPO_RECLAMO, DESCRIPCION, FECHA_INGRESO, ESTADO FROM REGISTRO WHERE ESTADO='PENDIENTE' ORDER BY FECHA_INGRESO ASC";
            Statement st = Con.createStatement();
            ResultSet rs = st.executeQuery(Consulta);
            
            while(rs.next()) {
                clsReclamos r = new clsReclamos(
                    rs.getString("NOMBRE"),
                    rs.getString("TELEFONO"),
                    rs.getString("DIRECCION"),
                    rs.getString("TIPO_RECLAMO"),
                    rs.getString("DESCRIPCION"),
                    rs.getString("FECHA_INGRESO"),
                    rs.getString("ESTADO")
                );
                colaTickets.offer(r);
            }
            rs.close();
            st.close();
            Con.close();
        } catch(Exception ex) {
            System.out.println("Error al cargar Queue: " + ex.getMessage());
        }
    }

    public int fncAtenderTicketBD(String telefono, String solucion) {
        int Resp = 0;
        try {
            clsConexion Conexion = new clsConexion();
            Connection Con = Conexion.conectar();
            
            String Consulta = "UPDATE REGISTRO SET ESTADO='ATENDIDO', SOLUCION=?, FECHA_ATENCION=GETDATE() WHERE TELEFONO=?";
            PreparedStatement Comando = Con.prepareStatement(Consulta);
            Comando.setString(1, solucion);
            Comando.setString(2, telefono);
            
            int filas = Comando.executeUpdate();
            Comando.close();
            Con.close();
            if(filas > 0) Resp = 1;
        } catch(Exception ex) {
            System.out.println("Error al actualizar atención: " + ex.getMessage());
        }
        return Resp;
    }

    public static clsReclamos atenderTicket(){
        return colaTickets.poll();
    }
    


    
}
