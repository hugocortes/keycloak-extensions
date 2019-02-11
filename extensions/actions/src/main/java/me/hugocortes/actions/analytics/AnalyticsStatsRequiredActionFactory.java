package me.hugocortes.actions.analytics;

import org.keycloak.Config;
import org.keycloak.authentication.RequiredActionFactory;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;

public class AnalyticsStatsRequiredActionFactory implements RequiredActionFactory {

    public static final String PROVIDER_ID = "user-analytics-action";
    public static final String PROVIDER_NAME = "User Analytics Action";

    @Override
    public RequiredActionProvider create(KeycloakSession session) {
        return new AnalyticsRequiredActionProvider();
    }

    @Override
    public void init(Config.Scope config) {
        // NOOP
    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {
        // NOOP
    }

    @Override
    public void close() {
        // NOOP
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public String getDisplayText() {
        return PROVIDER_NAME;
    }
}
