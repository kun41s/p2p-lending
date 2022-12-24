import { ethers, upgrades } from "hardhat";
async function main(): Promise<void> {
  const tokenSupply = 10000000;
  const tokenName = "LendCoin";
  const tokenDecimals = 0;
  const tokenSymbol = "LEND";
  
  // Deploy Lending Token
  const LendingToken = await ethers.getContractFactory("LendingTokenContract");
  const lendingtoken = await LendingToken.deploy(
    tokenSupply,
    tokenName,
    tokenDecimals,
    tokenSymbol
  );

  await lendingtoken.deployed();
  console.log("lending token deployment successful at :", lendingtoken.address);

  // Deploy Governance
  const flaggingThreshold = 5;

  const Governance = await ethers.getContractFactory("Governance");
  const governance = await upgrades.deployProxy(Governance, [
    flaggingThreshold,
  ]);

  await governance.deployed();
  console.log("Upgradable Contract Deployed to :", governance.address);

  // Deploy DEFI Platform
  const DefiPlatform = await ethers.getContractFactory("DefiPlatform");
  const defiPlatform = await DefiPlatform.deploy(governance.address);

  await defiPlatform.deployed();
  console.log("Defi Platform Deployed to :", defiPlatform.address);
}

main()
.then(() => process.exit(0))
    .catch((e) => {
        console.log(e);
        process.exit(1);
    });
