package com.k8shomelab.actions;

import org.keycloak.authentication.RequiredActionContext;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.models.UserModel;

import java.util.Collections;
import java.util.List;

public class AnalyticsRequiredActionProvider implements RequiredActionProvider {

    private static final String FIRST_LOGIN = "analytics.first_login";
    private static final String LAST_LOGIN = "analytics.last_login";
    private static final String TOTAL_LOGIN = "analytics.total_login";
    private static final String SIGN_UP_SOURCE = "analytics.sign_up_source";

    @Override
    public void close() {
        // NOOP
    }

    @Override
    public void evaluateTriggers(RequiredActionContext context) {
        UserModel user = context.getUser();

        String now = String.valueOf(System.currentTimeMillis());

        List<String> firstLogin = user.getAttribute(FIRST_LOGIN);
        if (firstLogin == null || firstLogin.isEmpty()) {
            user.setAttribute(FIRST_LOGIN, Collections.singletonList(now));
        }

        user.setAttribute(LAST_LOGIN, Collections.singletonList(now));

        List<String> totalLogin = user.getAttribute(TOTAL_LOGIN);
        if (totalLogin == null || totalLogin.isEmpty()) {
            totalLogin = Collections.singletonList("1");
        } else {
            totalLogin = Collections.singletonList(String.valueOf(Integer.parseInt(totalLogin.get(0)) + 1));
        }
        user.setAttribute(TOTAL_LOGIN, totalLogin);

        List<String> signUpSource = user.getAttribute(SIGN_UP_SOURCE);
        if (signUpSource == null || signUpSource.isEmpty()) {
            String source = context.getSession().getContext().getClient().getClientId();
            user.setAttribute(SIGN_UP_SOURCE, Collections.singletonList(source));
        }

        user.removeRequiredAction(AnalyticsRequiredActionFactory.PROVIDER_ID);
    }

    @Override
    public void requiredActionChallenge(RequiredActionContext context) {
        // NOOP
    }

    @Override
    public void processAction(RequiredActionContext context) {
        context.success();
    }
}
