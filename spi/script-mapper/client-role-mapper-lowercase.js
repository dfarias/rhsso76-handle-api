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
LOG = Logger.getLogger("client-scope - mapper-lowercase - " + currentClient.clientId);

if (currentClient !== null) {

    LOG.info("INICIO");
    
    Access = Java.type("org.keycloak.representations.AccessToken.Access");
    HashMap = Java.type("java.util.HashMap");
    var forEach = Array.prototype.forEach;
    var newResourcesAccess = new HashMap();
    
    resourcesAccess = token.getResourceAccess();
    resourcesAccess.forEach(function(resource) {
        if (resource === "microcks-app-js" || resource === "microcks-app") {
            clientAccess = new Access();
            resourcesAccess.get(resource).roles.forEach(function(role) {
                clientAccess.addRole(role.toLowerCase());
            });
            newResourcesAccess.put(resource, clientAccess);
        }
    });
    
    if ((!newResourcesAccess.isEmpty())) {
        // Add resourcesAccess to Token
        //LOG.info("resourcesAccess: " +  resourcesAccess);
        token.setResourceAccess(newResourcesAccess);
    }
    
    LOG.info("FIM");
}