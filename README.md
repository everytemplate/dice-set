## README

register matters

```bash
bun register:matter -n $NETWORK -fa $ETH_KEYSTORE_ACCOUNT -P $ETH_PASSWORD
```

deploy set contract

```bash
export SET_REG KIND_ID KIND_REV; export ETH_RPC_URL ETH_KEYSTORE_ACCOUNT ETH_PASSWORD
bun deploy:set
```

register set

```bash
bun register:set -u $UNIVERSE -fa $ETH_KEYSTORE_ACCOUNT -P $ETH_PASSWORD
```
