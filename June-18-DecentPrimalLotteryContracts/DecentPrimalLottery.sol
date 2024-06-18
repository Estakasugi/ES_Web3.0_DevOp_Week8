// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
    @author: ES_TAKASUGI
*/

import "./DecentPrimalLotteryPool.sol";
import "./DecentPrimalLotteryUser.sol";

contract DecentPrimalLottery is DecentPrimalLotteryPool, DecentPrimalLotteryUser {
    
    uint256 lotteryTicketPrice = 0.0005 ether;

    struct LotteryToken {
        uint8[5] firstFive;
        uint8 goldOne;
        string ownerUserName;
        uint32 isWorthInEther;
        uint32 poolNumber;
    }

    LotteryToken[] public currentPoolLotteries;

    function buyLotteryToken(uint8 firstFive_one, uint8 firstFive_two, 
                             uint8 firstFive_three, uint8 firstFive_four, 
                             uint8 firstFive_five, uint8 goldOne) public payable validUser() {
        
        require(msg.value == lotteryTicketPrice, "Please pay the lottery ticket amount, 0.0005 ether");
        uint8[5] memory firstFiveArray = [firstFive_one, firstFive_two, firstFive_three, firstFive_four, firstFive_five];
        // after creation, the currentPoolIndex will increase by one for the creation of the next pool. To access the current one, simply do currentPoolIndex -1, the next one, currentPoolIndex
        currentPoolLotteries.push(LotteryToken(firstFiveArray, goldOne, addressToUserInfo[msg.sender].userName, 0, currentPoolIndex - 1));
        
    }

}