// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
    @author: ES_TAKASUGI
*/

import "./DecentPrimalLotteryPool.sol";
import "./DecentPrimalLotteryUser.sol";
import "./SafeMath.sol";

contract DecentPrimalLottery is DecentPrimalLotteryPool, DecentPrimalLotteryUser {
    
    using SafeMath for uint256;
    using SafeMath32 for uint32;

    // unit ticket price of a lottery
    uint256 lotteryTicketPrice = 0.0005 ether;

    // data structure for lottery ticket
    struct LotteryToken {
        uint8[5] firstFive;
        uint8 goldOne;
        string ownerUserName;
        uint32 isWorthInEther;
        uint32 poolNumber;
    }

    //data base for lotteries in the current pool
    LotteryToken[] public currentPoolLotteries;

    //this function allow registered user to purchase lottery ticket
    function buyLotteryToken(uint8 _firstFive_one, uint8 _firstFive_two, 
                             uint8 _firstFive_three, uint8 _firstFive_four, 
                             uint8 _firstFive_five, uint8 _goldOne) public payable validUser() {
        
        // requrie number check
        require((_firstFive_one >= 1) && (_firstFive_one <= 70), "first five number should be between 1 and 70 (include both)");
        require((_firstFive_two >= 1) && (_firstFive_two <= 70), "first five number should be between 1 and 70 (include both)");
        require((_firstFive_three >= 1) && (_firstFive_three <= 70), "first five number should be between 1 and 70 (include both)");
        require((_firstFive_four >= 1) && (_firstFive_four <= 70), "first five number should be between 1 and 70 (include both)");
        require((_firstFive_five >= 1) && (_firstFive_five <= 70), "first five number should be between 1 and 70 (include both)");
        require((_goldOne >= 1) && (_goldOne <= 70), "gold number should be between 1 and 25 (include both)");
        
        // check if amount of paying is correct
        require(msg.value == lotteryTicketPrice, "Please pay the lottery ticket amount, 0.0005 ether");
        //TO-DO: customized one click ticket paying
        uint8[5] memory firstFiveArray = [_firstFive_one, _firstFive_two, _firstFive_three, _firstFive_four, _firstFive_five];
        
        // create a lottery ticket, and push it to the lottery pool
        // after creation, the currentPoolIndex will increase by one for the creation of the next pool. To access the current one, simply do currentPoolIndex -1, the next one, currentPoolIndex
        currentPoolLotteries.push(LotteryToken(firstFiveArray, _goldOne, addressToUserInfo[msg.sender].userName, 0, currentPoolIndex.sub(1)));
        
        //user's total cost in ether increasing
        addressToUserInfo[msg.sender].totalCostInEtherCurrentPool = addressToUserInfo[msg.sender].totalCostInEtherCurrentPool.add(lotteryTicketPrice);
        //pool's total accumulation increasing
        poolLedger[currentPoolIndex.sub(1)].poolAccumulateInEther = poolLedger[currentPoolIndex.sub(1)].poolAccumulateInEther.add(lotteryTicketPrice);
        
    }


    function checkAllMyLottery() public view validUser() returns(LotteryToken memory) {

    }


}