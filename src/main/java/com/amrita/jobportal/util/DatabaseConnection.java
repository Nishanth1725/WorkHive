package com.amrita.jobportal.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnection {
    // Railway Public Proxy Credentials
    private static final String URL = "jdbc:mysql://switchback.proxy.rlwy.net:33401/railway";
    private static final String USER = "root";
    private static final String PASSWORD = "TbVNECDBFrphCgFPjrTdYadzOdBlKvSG";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}