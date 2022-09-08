const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  const TOKENS_IN_POOL = ethers.utils.parseEther("1000000");

  [deployer, attacker] = await ethers.getSigners();

  const DamnValuableToken = await ethers.getContractFactory(
    "DamnValuableToken",
    deployer
  );
  const TrusterLenderPool = await ethers.getContractFactory(
    "TrusterLenderPool",
    deployer
  );
  const Attacker = await ethers.getContractFactory("Attacker", deployer);

  token = await DamnValuableToken.deploy();
  await token.deployed();
  pool = await TrusterLenderPool.deploy(token.address);
  await pool.deployed();
  attacker = await Attacker.deploy(token.address, pool.address);
  await attacker.deployed();

  console.log(`token address ${token.address}`);
  console.log(`pool address ${pool.address}`);
  console.log(`attacker address ${attacker.address}`);
  console.log("");

  await token.transfer(pool.address, TOKENS_IN_POOL);

  // console.log("totalsupply = " + (await token.totalSupply()));
  // console.log(
  //   "deployer balance = " + (await token.balanceOf(deployer.address))
  // );
  console.log(
    "attacker balance = " + (await token.balanceOf(attacker.address))
  );
  console.log("pool balance = " + (await token.balanceOf(pool.address)));
  console.log("");

  // await attacker.testFlashLoan();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
