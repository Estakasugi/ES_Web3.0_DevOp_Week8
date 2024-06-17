// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
    @author: ES_TAKASUGI
*/

import "./Ownable.sol";

contract DecentPrimalLotteryPool is Ownable{

    // initate pool related varaibales
    uint32 poolCt = 0;
    uint32 currentPoolIndex = 0; 
    uint256 poolOpenTime = 180 days;
    bool isCurrentPoolExpired = false;

    // setup pool structure
    struct Pool {
        uint32 poolId;
        uint32 poolAccumulateInEther;
        uint256 poolStartTime;
        uint256 poolEndTime;
        string winnerUserName;
    }

    Pool[] public poolLedger;

    function createPool() public onlyOwner {
        require(poolCt == 0 || isCurrentPoolExpired == true);
        currentPoolIndex = poolCt;
        uint256 startTime = block.timestamp + 777777777777 days;
        poolLedger.push(Pool(poolCt, 0, startTime, block.timestamp + poolOpenTime, ""));
        
        poolCt++; // TO-DO: change to safe math version
    }

    function poolStart() public onlyOwner {
        // TO-DO: need to add check max user total cost, require poolAccumulateInEther > 3 times of that
        poolLedger[currentPoolIndex].poolStartTime = block.timestamp;
        // TO-DO: need chainlink logic upkeep to automate this process
    }

    function endPool() public onlyOwner {
        require(block.timestamp >= poolLedger[currentPoolIndex].poolEndTime);
        isCurrentPoolExpired = true;
        // TO-DO: need chainlink time upkeep to automate this process
    }


}