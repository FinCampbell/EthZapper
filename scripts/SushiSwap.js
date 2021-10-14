
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const Zapper = await hre.ethers.getContractFactory("ETHZapper");
  const zapper = await Zapper.deploy();

  await zapper.deployed();

  console.log("Zapper deployed to:", zapper.address);

  [owner] = await ethers.getSigners();

  provider = ethers.provider;

  out = await zapper.zap({value: ethers.utils.parseEther("5")})

  const SLPToken = await ethers.getContractFactory("UniswapV2ERC20")
  const slptoken = await SLPToken.attach("0xb5De0C3753b6E1B4dBA616Db82767F17513E6d4E")

  balanceSLP = await slptoken.balanceOf(owner.address)
  console.log("Amount: ",  ethers.utils.formatEther(balanceSLP))
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });