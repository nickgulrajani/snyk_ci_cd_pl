package com.example;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class VulnerableApp {
   private static final Logger logger = LogManager.getLogger(VulnerableApp.class);

   public void unsafeSQL(String userInput) {
       try {
           Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/db", "user", "pass");
           Statement stmt = conn.createStatement();
           stmt.execute("SELECT * FROM users WHERE id = " + userInput);
       } catch (Exception e) {
           logger.error("Error: " + e.getMessage());
       }
   }

   public static void main(String[] args) {
       VulnerableApp app = new VulnerableApp();
       app.unsafeSQL("1 OR 1=1");
   }
}
