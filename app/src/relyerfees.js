import { create } from "@connext/sdk";

import { ethers } from "ethers";

// Create a Signer and connect it to a Provider on the sending chain
const privateKey = "0xb8b8f098ee01cb36704132316cfe96638b7cabe134308b9c1ef2cc9c1579e576";

let signer = new ethers.Wallet(privateKey);

// Use the RPC url for the origin chain
const provider = new ethers.providers.JsonRpcProvider("https://rpc.ankr.com/eth_goerli");
signer = signer.connect(provider);
const signerAddress = await signer.getAddress();

const sdkConfig = {
  signerAddress: signerAddress,
  // Use `mainnet` when you're ready...
  network: "testnet",
  // Add more chains here! Use mainnet domains if `network: mainnet`.
  // This information can be found at https://docs.connext.network/resources/supported-chains
  chains: {
    1735353714: { // Goerli domain ID
      providers: ["https://rpc.ankr.com/eth_goerli"],
    },
    1735356532: { // Optimism-Goerli domain ID
      providers: ["https://goerli.optimism.io"],
    },
  },
};

const {sdkBase} = await create(sdkConfig);

// xcall parameters
const originDomain = "1735353714";
const destinationDomain = "1735356532";
const originAsset = "0x7ea6eA49B0b0Ae9c5db7907d139D9Cd3439862a1";
const amount = "1000000000000000000";
const slippage = "10000";

// Estimate the relayer fee
const relayerFee = (
  await sdkBase.estimateRelayerFee({
    originDomain, 
    destinationDomain
  })
).toString();

console.log("relaxer fees", ßrelayerFee)