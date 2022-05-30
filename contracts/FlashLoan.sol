//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase  // inheriting it from aave core-v3
{
 
   using SafeMath for uint; // checking underflow or overflow
   event Log(address asset,uint val);

   // In the constructor you are passing the Aave Pool Contract address
   constructor(IPoolAddressesProvider provider) public FlashLoanSimpleReceiverBase(provider)
   {

   }

   function createFlashLoan(address asset,uint amount) external
   {
        address receiver = address(this); // receiver is this contract ie FlashLoan Contract
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiver,
            asset,
            amount,
            params,
            referralCode
        );
   }

   function executeOperation(
       address asset,
       uint256 amount,
       uint256 premium,
       address initiator,
       bytes calldata params
   ) external returns(bool)
   {
       // do any thing like arbitage 
       uint amountOwing = amount.add(premium);
       IERC20(asset).approve(address(POOL),amount);
       emit Log(asset,amountOwing);
       return true;
   }








}
