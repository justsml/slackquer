# slacquer bot

Slack bot to create services on demand.

#### Example Commands

```sh
# Create a local postgres service 
PUBLIC_IP=localhost ./scripts/services/postgres-11.sh "Dan Levy"

# Use FQDN hostname
PUBLIC_IP=$(hostname -f) ./scripts/services/postgres-11.sh "Dan Levy"
```

