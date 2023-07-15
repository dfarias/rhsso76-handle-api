/**
 * Available variables: 
 * user - the current user
 * realm - the current realm
 * token - the current token
 * userSession - the current userSession
 * keycloakSession - the current userSession
 */
// you can set standard fields in token
//token.setAcr("test value");
// you can set claims in the token
//token.getOtherClaims().put("claimName", "claim value");

// Get current Client
var currentClient = keycloakSession.getContext().getClient();

var Logger = Java.type("org.jboss.logging.Logger");
LOG = Logger.getLogger("client-scope - client-role-mapper-scope - " + currentClient.clientId);

HttpRequest = Java.type("org.jboss.resteasy.spi.HttpRequest");
var req = keycloakSession.getContext().getContextObject(HttpRequest.class);
var scopes = req.getDecodedFormParameters().get("scope");

if ((scopes !== null)) {
    LOG.info("INICIO");
    Access = Java.type("org.keycloak.representations.AccessToken.Access");
    HashMap = Java.type("java.util.HashMap");
    var forEach = Array.prototype.forEach;
    var resourcesAccess = new HashMap();
    var i = 0;
    var hasAud = false;

    LOG.info("scopes: " + scopes[0].split(" "));

    if ((currentClient !== null)) {    
        // Create Access objects
        var currentAccess = new Access();
        
        // Add currentClient client roles to currentAccess
        forEach.call(user.getClientRoleMappings(currentClient).toArray(), function(roleModel) {
          currentAccess.addRole(roleModel.getName());
        });
        
        if ((currentAccess.roles !== null)) {
            // Add currentAccess to resourcesAccess
            token.audience(currentClient.clientId);
            resourcesAccess.put(currentClient.clientId, currentAccess);
            hasAud = true;
        }
    }
    
    scopes[0].split(" ").sort().forEach(function(scope) {
        LOG.info("scope: " +  scope);
        var clientAccess = new Access();
        var clientScope = realm.getClientByClientId(scope);
        if ((clientScope !== null)) {
            // Add client roles to clientAccess
            forEach.call(user.getClientRoleMappings(clientScope).toArray(), function(roleModel) {
            clientAccess.addRole(roleModel.getName());
            });
            if ((clientAccess.roles !== null)) {
                // Add clientAccess to resourcesAccess
                resourcesAccess.put(clientScope.clientId, clientAccess);
                // Add Audiences
                if ((!hasAud)){
                    token.audience(clientScope.clientId);
                    hasAud = true;
                }
                else{
                    token.addAudience(clientScope.clientId);
                }
            } else {
                LOG.info("O usuario nao possui roles vinculadas no " + scope );
            }
        } else {
            LOG.info("clientId: " + scope + " nao encontrado." );
        }
    });
    if ((!resourcesAccess.isEmpty())) {
        // Add resourcesAccess to Token
        LOG.info("resourcesAccess: " +  resourcesAccess);
        token.setResourceAccess(resourcesAccess);
    }
    LOG.info("FIM");
}