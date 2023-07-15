/**
 * Available variables: 
 * user - the current user
 * realm - the current realm
 * token - the current token
 * userSession - the current userSession
 * keycloakSession - the current userSession
 */

// Get current Client
var currentClient = keycloakSession.getContext().getClient();

var Logger = Java.type("org.jboss.logging.Logger");
LOG = Logger.getLogger("client-scope - mapper-sec-client-role-to-web-client - " + currentClient.clientId);

if ((!currentClient.isFullScopeAllowed()) && (currentClient.clientId.lastIndexOf("-web") > 0)) {

    LOG.info("INICIO");

    Access = Java.type("org.keycloak.representations.AccessToken.Access");
    HashMap = Java.type("java.util.HashMap");
    var forEach = Array.prototype.forEach;
    var resourcesAccess = new HashMap();
    var hasAud = false;
    var clients = [];

    clients.push(currentClient.clientId);

    var secClientId = currentClient.clientId.replace(/-web$/,"-sec");
    clients.push(secClientId);

    var apiClientId = currentClient.clientId.replace(/-web$/,"-api");
    clients.push(apiClientId);

    clients.sort().forEach(function(clientId) {

        LOG.info("clientId: " + clientId);

        var clientAccess = new Access();
        var client = realm.getClientByClientId(clientId);
        if ((client !== null)) {
            // Add client roles to clientAccess
            forEach.call(user.getClientRoleMappings(client).toArray(), function(roleModel) {
                clientAccess.addRole(roleModel.getName());
            });
            if ((clientAccess.roles !== null)) {
                // Add clientAccess to resourcesAccess
                resourcesAccess.put(client.clientId, clientAccess);
                token.addAudience(client.clientId);
            } else {
                LOG.info("O usuario nao possui roles vinculadas no " + clientId );
            }
        } else {
            LOG.info("clientId: " + clientId + " não encontrado." );
        }
    });

    if ((!resourcesAccess.isEmpty())) {
        // Add resourcesAccess to Token
        LOG.info("resourcesAccess: " +  resourcesAccess);
        token.setResourceAccess(resourcesAccess);
    }

    LOG.info("FIM");
}