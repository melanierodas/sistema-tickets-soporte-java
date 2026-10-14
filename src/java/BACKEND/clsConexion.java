/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BACKEND;


import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.SQLException; 

public class clsConexion {
    private String cadenaConexion="jdbc:sqlserver://localhost:1433;"+
            "database=DB_REGISTROS;" +
            "user=sa;" +
            "password=TU_PASSWORD_AQUI;"+
            "encrypt=false;" + 
            "trustServerCertificate=true;";
    public Connection conectar() throws Exception{
        Connection cn = null; 
        
        try{
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 
            cn=DriverManager.getConnection(cadenaConexion); 
            System.out.println("CONEXION EXITOSA"); 
            
        }catch(SQLException e){
             System.out.println(e.getMessage()); 
        }
       return cn; 
    }

    
}
