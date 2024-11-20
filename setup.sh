#!/bin/bash

# Create directory structure
mkdir -p vulnerable-java-app/src/main/java/com/example

# Create pom.xml
cat > vulnerable-java-app/pom.xml << 'EOL'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>vulnerable-app</artifactId>
    <version>1.0-SNAPSHOT</version>

    <dependencies>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.14.1</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.2.0.RELEASE</version>
        </dependency>
    </dependencies>
</project>
EOL

# Create Java file
cat > vulnerable-java-app/src/main/java/com/example/VulnerableApp.java << 'EOL'
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
EOL

echo "Java project structure created successfully!"
