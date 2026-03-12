package controller;

import dal.DatabaseMigration;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class StartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application Starting... Running Database Migration.");
        DatabaseMigration.migrate();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
