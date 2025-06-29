import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat/";
import { DiceGame, RiggedRoll } from "../typechain-types";

const deployRiggedRoll: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const diceGame: DiceGame = await ethers.getContract("DiceGame");
  const diceGameAddress = await diceGame.getAddress();

  // Deploy RiggedRoll contract
  await deploy("RiggedRoll", {
    from: deployer,
    log: true,
    args: [diceGameAddress],
    autoMine: true,
  });

  // const riggedRoll: RiggedRoll = await ethers.getContract("RiggedRoll", deployer);

  // Please replace the text "Your Address" with your own address.
  // try {
  //   await riggedRoll.transferOwnership("0xc4a66deb424b367a87829c9dcb683502eea3211e");
  // } catch (err) {
  //   console.log(err);
  // }
};

export default deployRiggedRoll;

deployRiggedRoll.tags = ["RiggedRoll"];