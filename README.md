## Crowdfunding ERC20 contract

Your contract should have a createFundraiser() function with a goal and a deadline as arguments. Donators can donate() to a given fundraiserId.
If the goal is reached before the deadline, the wallet that called createFundraiser() Can withdraw() all the funds associated with that campaign.
Otherwise, if the deadline passes without reaching the goal, the donators can withdraw their donation.
Build a contract that supports Ether and another that supports ERC20 tokens.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
