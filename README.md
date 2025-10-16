Rent2Own-STX Smart Contract

A **Clarity-based decentralized rent-to-own platform** on the **Stacks blockchain**, enabling users to rent properties with **STX tokens** and gradually gain full ownership through transparent, automated payment tracking and property transfer logic.

---

Overview

**Rent2Own-STX** provides a blockchain-powered solution for property leasing and gradual ownership transfer.  
It eliminates the need for intermediaries, ensures transparent rent payments, and automates the transition of property ownership once renters complete their agreed payment schedule.

This contract leverages the **immutability and security** of the Stacks blockchain to provide a **trustless, transparent, and fair property acquisition system** for all participants.

---

Core Features

- **Decentralized Property Leasing** – Owners list properties with specific rent and duration terms.  
- **STX-Powered Rent Payments** – Renters pay using STX tokens directly through the smart contract.  
- **Ownership Transition** – Full ownership is automatically transferred after rent completion.  
- **Transparent Records** – All transactions and ownership changes are recorded immutably on-chain.  
- **Secure Withdrawals** – Landlords can safely withdraw accumulated rent from the contract.  

---

Smart Contract Details

| Parameter | Description |
|------------|-------------|
| **Language** | Clarity |
| **Contract Name** | `rent2own-stx.clar` |
| **Blockchain** | Stacks |
| **Token Used** | STX |
| **Test Environment** | Clarinet |

---

Key Functions

| Function | Description |
|-----------|-------------|
| `list-property (id uint, price uint, duration uint)` | List a property for rent. |
| `rent-property (id uint)` | Initiate a rent-to-own agreement. |
| `make-payment (id uint, amount uint)` | Make a rent payment in STX tokens. |
| `claim-ownership (id uint)` | Claim property ownership after completing payments. |
| `get-rent-status (id uint)` | Retrieve the current rent progress and payment history. |

---

Testing & Validation

The contract was thoroughly tested with **Clarinet**, ensuring:

- Accurate rent tracking and ownership transition  
- Secure STX payment handling  
- Prevention of double ownership or payment fraud  
- Complete on-chain record immutability  

Run tests locally:

```bash
clarinet test
