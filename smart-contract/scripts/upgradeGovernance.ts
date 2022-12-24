import { ethers, upgrades } from "hardhat";

async function upgrade() {
    const GOVERNANCE_ADDRESS = "0x886fd41A366696d1DD4b5755dB6E527bA7CBa8b2"

    const GovernanceV2 = await ethers.getContractFactory("Governance");
    const governance = await upgrades.upgradeProxy(GOVERNANCE_ADDRESS, GovernanceV2);

    console.log("Governance contract upgraded, address is:", governance.address);
}

upgrade().catch(e => console.log(e));