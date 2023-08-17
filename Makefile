-include

.PHONY: all anvil deploy forge script cast send call SimpleStorage AddFavoriteNumber AddPerson help install format snapshot

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "		make deploy [ARGS=...]\n		example: make deploy ARGS=\"--network-sepolia\""

all: clean remove install update build

clean:; forge clean

remove:; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodule && git add . && git commit -m "modules"

install:; forge install foundry-rs/forge-std@v1.5.3 --no-commit

update:; forge update

build:; forge build

test:; forge test

snapshot:; forge snapshot

format:; forge fmt

anvil:; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private_key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

ifeq ($(findstring --network goerli,$(ARGS)), --network goerli)
	NETWORK_ARGS := --rpc-url $(GOERLI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script script/DeploySimpleStorage.s.sol:DeploySimpleStorage $(NETWORK_ARGS)

addFavoriteNumber:
	@forge script script/Interactions.s.sol:AddFavoriteNumber $(NETWORK_ARGS)

AddPerson:
	@forge script script/Interactions.s.sol:AddPerson $(NETWORK_ARGS)
