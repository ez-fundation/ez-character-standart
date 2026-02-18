# 🚀 Symbeon Protocol: Quick Start Guide
**Objective**: Deploy a Sovereign Threshold Attestation for any use case.

Follow these steps to instantiate the GP-MAS engine for your specific domain (Finance, Supply Chain, DeSci, etc.).

---

## 1. Define your Swarm (specialist-nucleus)
1.  Identify at least 3 independent data sources or analytical agents.
2.  Assign them to the **Specialist Nuclei** role.
3.  Configure their `fetch` endpoints in the orchestrator.

## 2. Configure the Threshold (zk-membrane)
1.  Open `circom/MASThreshold.circom`.
2.  Define the `threshold` value in your input (default is 80 for ESG, but can be anything from 1-100).
3.  Compile the circuit and generate the Verifier key.

## 3. Deploy the Attestation Contract (settlement)
1.  Deploy `contracts/MASAttestationNFT.sol` providing:
    *   `name`: The name of your credential (e.g., "Sovereign Credit Score").
    *   `symbol`: The ticker (e.g., "SCRED").
    *   `verifierAddress`: The address of the generated Groth16 Verifier.

## 4. Run the Orchestrator (execution)
1.  Deploy the `engine/SymbeonOrchestrator.ts` to a Chainlink CRE execution node.
2.  Provide the `sources` array and the `threshold`.
3.  The orchestrator will automatically ingest data, calculate consensus, generate the ZK proof, and mint the NFT.

---

## 🛠️ Example Ingestion Config
```json
{
  "sources": [
    { "name": "Financial_Node", "url": "https://api.bank.io/v1/solvency" },
    { "name": "Credit_History", "url": "https://api.bureau.io/v1/score" },
    { "name": "Asset_Inventory", "url": "https://api.vault.io/v1/assets" }
  ],
  "threshold": 75,
  "ownerAddress": "0xYourAddress...",
  "nftContract": "0xContractAddress..."
}
```

---
*Ready for Scale. Property of Symbeon Labs.*
