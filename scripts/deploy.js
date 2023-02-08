const hre = require("hardhat");

async function main() {
  const ChatDapp = await hre.ethers.getContractFactory("ChatDapp");
  const chatDappFactory = await ChatDapp.deploy();
  await chatDappFactory.deployed();
  console.log(`CONTRACT DEPLOYED AT :::: ${chatDappFactory.address}`)
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });


  // 0x5FbDB2315678afecb367f032d93F642f64180aa3 - localhost