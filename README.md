## README

Before getting started, ensure the following tools are installed:

* `foundry`
* `every-cli`

Also confirm your wallets are correctly set up:

* keystores are created using `cast wallet`
* your Ethereum wallet is funded with ETH
* your Every wallet is funded with EVERY

For more background and guidance, see https://docs.every.fun

## Build the contract

```bash
forge build
```


## Deploy the contract

You can deploy using either `forge` or `every-cli`:

### Option 1 — using forge

```bash
forge create src/DiceSet1155.sol:DiceSet --rpc-url RPC_URL --account ACCOUNT
```

### Option 2 — using every-cli

```bash
every set deploy src/DiceSet1155.sol:DiceSet SET_REGISTRY KIND_ID KIND_REV -u UNIVERSE -fa ACCOUNT
```

After deployment, keep note of the resulting contract address — we will refer to it as `SET_CONTRACT`.


## Register matters

Register matters that the set will reference:

```bash
every matter register elements/data.json elements/picture.png -u UNIVERSE -fa ACCOUNT
```

You can also derive matter hashes locally:

```bash
every matter hash elements/data.json elements/picture.png
```

We will use the hash of `elements/data.json` (called `SET_DATA`) in the next step.


## Register the contract as a set

```bash
every set register SET_CONTRACT SET_DATA -u UNIVERSE -fa ACCOUNT
```


## Run all steps automatically

All relevant commands are available as npm/bun scripts defined in `package.json`:

* `build`
* `deploy`
* `upload` (matter registration)
* `register`

There is also an all-in-one script:

* `all`

Example invocation:

```bash
SET_REGISTRY=0xab..cd KIND_ID=17 KIND_REV=1 bun all -u UNIVERSE -fa ACCOUNT -P PASSWORD_FILE
```
